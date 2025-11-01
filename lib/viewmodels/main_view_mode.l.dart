import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dibujitos/models/drawing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class MainViewModel extends ChangeNotifier {
  static const double defSwi = 10;

  Color currentColor = Colors.black;
  List<Offset> tempPoints = [];
  double strokeWidth = defSwi;
  List<DrawingLine> lines = [];

  GlobalKey paintKey = GlobalKey();

  var paintOptions = Paint()
    ..color = Colors.black
    ..isAntiAlias = true
    ..strokeWidth = defSwi
    ..strokeCap = StrokeCap.round;

  setSCR(GlobalKey key) {
    paintKey = key;
  }

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

  Future<void> printLines() async {
    print("DRAWING SIMULTAION");
    //We can save the lines and be able to do the drawing effect at any moment

    final tempLines = List<DrawingLine>.from(lines);
    final json = jsonEncode(tempLines.map((line) => line.toJson()).toList());
    final encodedJson = utf8.encode(json);
    final gZipJson = gzip.encode(encodedJson);
    print("encoded ziped json*********************************");
    final base64json = base64.encode(gZipJson);
    print(base64json);

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

  Future<void> saveImage() async {
    print("SAVING IMAGE");
    //not really sure if we need this, if not delete the Manifest User permissions as well
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   // If not we will ask for permission first
    //   await Permission.storage.request();
    // }
    //TODO: move this to a separate function to get the correct dir

    var dir = Directory('');
    if (Platform.isAndroid) {
      //TODO: create a folder for the drawings iunstead of usfied ing the Download one
      dir = Directory("/storage/emulated/0/Download/");
    } else {
      final docsDir = await getApplicationDocumentsDirectory();
      dir = Directory(docsDir.path);
    }
    RenderRepaintBoundary boundary = paintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = await bytes!.buffer.asUint8List();
    //TODO: file name should be timestampqq
    String fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.png';
    String completedir = p.join(dir.path, fileName);
    File newFile = File(completedir);
    try {
      await newFile.writeAsBytes(pngBytes);
    } catch (e) {
      print(e);
    }
  }
}
