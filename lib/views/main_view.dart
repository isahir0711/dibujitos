import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.title});

  final String title;

  @override
  State<MainView> createState() => _MainViewState();
}

Color selectedColor = Colors.red;

double strokeWidth = 5;

class _MainViewState extends State<MainView> {
  List<DrawingPoint?> drawingPoints = [];
  List<Offset> tempPoints = [];
  List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.amberAccent,
    Colors.purple,
    Colors.green,
  ];

  List<DrawingLine> lines = [];

  void _onTouchDown(DragStartDetails details) {
    // print("************START*****************");
    // print(details.localPosition);
    // print("************START*****************");

    // lines = [];
    setState(() {
      tempPoints.add(details.localPosition);
    });
  }

  void _onTouchMove(DragUpdateDetails details) {
    // print(details.localPosition);

    setState(() {
      tempPoints.add(details.localPosition);
    });
  }

  void _onTouchEnd(DragEndDetails details) {
    // print("************END*****************");
    // print(details.localPosition);
    // print("************END*****************");

    setState(() {
      tempPoints.add(details.localPosition);

      final tempPaint = Paint()
        ..color = selectedColor
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final newLine = DrawingLine(List.from(tempPoints), tempPaint);

      lines.add(newLine);
      tempPoints.clear();
    });
  }

  void _printLines() async {
    final tempLines = List<DrawingLine>.from(lines);
    lines.clear();

    //TODO: INSTEAD OF DRAWING AGAIN THE LINES DRAW THE POINTS TO SIMULATE THE PAINT ACTION
    for (var i = 0; i < tempLines.length; i++) {
      await Future.delayed(Duration(milliseconds: 800));
      setState(() {
        lines.add(tempLines[i]);
      });
    }
  }

  void _undo() async {
    if (lines.isNotEmpty) {
      lines.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24),
            Container(
              color: Colors.grey,
              height: 340,
              width: 340,
              child: ClipRect(
                child: GestureDetector(
                  onPanStart: _onTouchDown,
                  onPanUpdate: _onTouchMove,
                  onPanEnd: _onTouchEnd,
                  child: CustomPaint(painter: _DrawingPainter(drawingPoints, lines, tempPoints)),
                ),
              ),
            ),
            Row(spacing: 12, children: [Text("Undo"), Text("Erase"), Text("Delete"), Text("Options")]),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: _printLines, child: Text("Save")),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: _undo, child: Text("Save")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;
  final List<DrawingLine> lines;
  final List<Offset> tempPoints;

  _DrawingPainter(this.drawingPoints, this.lines, this.tempPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    // Draw completed lines
    for (DrawingLine line in lines) {
      if (line.offsets.length > 1) {
        // Draw connected lines
        for (int i = 0; i < line.offsets.length - 1; i++) {
          canvas.drawLine(line.offsets[i], line.offsets[i + 1], line.paint);
        }
      } else if (line.offsets.length == 1) {
        // Draw single point
        canvas.drawPoints(PointMode.points, line.offsets, line.paint);
      }
    }

    if (tempPoints.length > 1) {
      final tempPaint = Paint()
        ..color = selectedColor
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      for (int i = 0; i < tempPoints.length - 1; i++) {
        canvas.drawLine(tempPoints[i], tempPoints[i + 1], tempPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}

class DrawingLine {
  List<Offset> offsets;
  Paint paint;

  DrawingLine(this.offsets, this.paint);
}
