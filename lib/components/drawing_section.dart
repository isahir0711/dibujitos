import 'package:dibujitos/services/custom_painter.dart';
import 'package:dibujitos/viewmodels/main_view_mode.l.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawingSection extends StatelessWidget {
  const DrawingSection({super.key, required this.scr});

  final GlobalKey<State<StatefulWidget>> scr;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: scr,
      child: Container(
        height: 340,
        width: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.08), blurRadius: 12, spreadRadius: 0, offset: Offset(0, 4)),
          ],
        ),
        child: Consumer<MainViewModel>(
          builder: (context, viewmodel, child) {
            return ClipRect(
              child: GestureDetector(
                onPanStart: viewmodel.onTouchDown,
                onPanUpdate: viewmodel.onTouchMove,
                onPanEnd: viewmodel.onTouchEnd,
                child: CustomPaint(
                  painter: DrawingPainter(viewmodel.lines, viewmodel.tempPoints, viewmodel.paintOptions),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
