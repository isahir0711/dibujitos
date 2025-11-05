import 'dart:ui';

import 'package:dibujitos/models/drawing.dart';
import 'package:flutter/material.dart';

class SimPainter extends CustomPainter {
  final List<DrawingLine> lines;

  SimPainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) async {
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
