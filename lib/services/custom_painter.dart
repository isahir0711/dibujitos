import 'dart:ui';

import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingLine> lines;
  final List<Offset> tempPoints;
  final bool creatingVideo;
  final Paint paintOptions;

  DrawingPainter(this.lines, this.tempPoints, this.creatingVideo, this.paintOptions);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) async {
    if (tempPoints.length > 1) {
      for (int i = 0; i < tempPoints.length - 1; i++) {
        canvas.drawLine(tempPoints[i], tempPoints[i + 1], paintOptions);
      }
    }

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
