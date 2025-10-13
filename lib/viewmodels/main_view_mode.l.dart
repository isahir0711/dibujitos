import 'dart:developer';

import 'package:dibujitos/services/custom_painter.dart';
import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  static const double defSwi = 10;

  Color currentColor = Colors.black;
  List<Offset> tempPoints = [];
  double strokeWidth = defSwi;
  List<DrawingLine> lines = [];

  var paintOptions = Paint()
    ..color = Colors.black
    ..isAntiAlias = true
    ..strokeWidth = defSwi
    ..strokeCap = StrokeCap.round;

  changeColor(Color newColor) {
    currentColor = newColor;
    paintOptions.color = newColor;
    notifyListeners();
  }

  changeStrokeWidth(double newWidth) {
    strokeWidth = newWidth;
    paintOptions.strokeWidth = newWidth;
    notifyListeners();
  }

  onTouchDown(DragStartDetails details) {
    tempPoints.add(details.localPosition);
    notifyListeners();
  }

  onTouchMove(DragUpdateDetails details) {
    tempPoints.add(details.localPosition);
    notifyListeners();
  }

  onTouchEnd(DragEndDetails details) {
    tempPoints.add(details.localPosition);

    //need to create a new paint for each line....
    final tempPaint = Paint()
      ..color = currentColor
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final newLine = DrawingLine(List.from(tempPoints), tempPaint);

    lines.add(newLine);
    tempPoints.clear();
    notifyListeners();
  }

  undo() async {
    if (lines.isNotEmpty) {
      lines.removeLast();
      notifyListeners();
    }
  }

  delete() {
    lines.clear();
    notifyListeners();
  }

  printLines() async {
    //We can save the lines and be able to do the drawing effect at any moment

    final tempLines = List<DrawingLine>.from(lines);

    lines.clear();

    for (var i = 0; i < tempLines.length; i++) {
      //Change the current paintOptions to match the current line
      paintOptions.strokeWidth = tempLines[i].paint.strokeWidth;
      paintOptions.color = tempLines[i].paint.color;

      //Draw the offset for each line, with a delay so we can mimic the drawing effect
      for (var offset in tempLines[i].offsets) {
        await Future.delayed(Duration(milliseconds: 20));
        tempPoints.add(offset);
        notifyListeners();
      }

      //We add the temporary drawed line into the lines arr, so we can undo or save them later
      final tempPaint = Paint()
        ..color = tempLines[i].paint.color
        ..isAntiAlias = true
        ..strokeWidth = tempLines[i].paint.strokeWidth
        ..strokeCap = StrokeCap.round;
      final newLine = DrawingLine(List.from(tempPoints), tempPaint);
      lines.add(newLine);
      tempPoints.clear();
      notifyListeners();
    }
  }
}
