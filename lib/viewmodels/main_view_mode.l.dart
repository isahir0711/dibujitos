import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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
  //Used for 'drawing sim'
  List<DrawingLine> tlines = [];
  List<Offset> tpoints = [];
  Paint tpaint = new Paint()..strokeCap = StrokeCap.round;
  String currDrawing = "";
  int currD = 0;

  //TODO: fetch this from a db
  List<String> drawingsData = [
    "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",
  ];

  GlobalKey paintKey = GlobalKey();

  var paintOptions = Paint()
    ..color = Colors.black
    ..isAntiAlias = true
    ..strokeWidth = defSwi
    ..strokeCap = StrokeCap.round;

  setSCR(GlobalKey key) {
    paintKey = key;
  }

  changePrev(int i) async {
    currDrawing = drawingsData[i];
    await foo();
    print(currDrawing);
    notifyListeners();
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

  Future<void> foo() async {
    tlines.clear();
    Uint8List decodedBytes = base64.decode(currDrawing);
    List<int> decompressJson = gzip.decode(decodedBytes);
    String jsonString = utf8.decode(decompressJson);
    final List<dynamic> decodedJson = jsonDecode(jsonString);
    // final List<DrawingLine> lines2 = decodedJson.map((line) => DrawingLine.fromJson(line as Map<String, dynamic>)).toList();
    final List<DrawingLine> lines2 = List<DrawingLine>.from(decodedJson.map((line) => DrawingLine.fromJson(line)));

    for (var i = 0; i < lines2.length; i++) {
      //Change the current paintOptions to match the current line
      tpaint.strokeWidth = lines2[i].paint.strokeWidth;
      tpaint.color = lines2[i].paint.color;

      //Draw the offset for each line, with a delay so we can mimic the drawing effect
      for (var offset in lines2[i].offsets) {
        await Future.delayed(Duration(milliseconds: 20));
        tpoints.add(offset);
        notifyListeners();
      }

      // We add the temporary drawed line into the lines arr, so we can undo or save them later
      final tempPaint = Paint()
        ..color = lines2[i].paint.color
        ..isAntiAlias = true
        ..strokeWidth = lines2[i].paint.strokeWidth
        ..strokeCap = StrokeCap.round;
      final newLine = DrawingLine(List.from(tpoints), tempPaint);

      tlines.add(newLine);
      tpoints.clear();
      notifyListeners();
    }
  }

  Future<void> saveImage() async {
    if (lines.isEmpty) {
      print("bro");
      return;
    }

    //TODO: store the base64 string in a db
    //     final tempLines = List<DrawingLine>.from(lines);
    // final json = jsonEncode(tempLines.map((line) => line.toJson()).toList());
    // final encodedJson = utf8.encode(json);
    // final gZipJson = gzip.encode(encodedJson);
    // print("encoded ziped json*********************************");
    // final base64json = base64.encode(gZipJson);
    // print(base64json);

    var dir = Directory('');
    if (Platform.isAndroid) {
      //this works but not sure why the folders doesnt appear on the gallery
      //also this only works for android>11
      dir = await Directory("/storage/emulated/0/DCIM/Dibujitos/").create();
    } else {
      final docsDir = await getApplicationDocumentsDirectory();
      dir = Directory(docsDir.path);
    }
    RenderRepaintBoundary boundary = paintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = await bytes!.buffer.asUint8List();
    String fileName = "${DateTime.now().microsecondsSinceEpoch.toString()}.png";
    String completedir = p.join(dir.path, fileName);
    File newFile = File(completedir);
    try {
      await newFile.writeAsBytes(pngBytes);
    } catch (e) {
      print(e);
    }
  }
}
