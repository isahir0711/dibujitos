import 'package:dibujitos/services/sim_painter.dart';
import 'package:dibujitos/viewmodels/main_view_mode.l.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SimSection extends StatefulWidget {
  const SimSection({super.key});

  @override
  State<SimSection> createState() => _SimSectionState();
}

class _SimSectionState extends State<SimSection> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
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
          builder: (context, value, child) {
            return CustomPaint(painter: SimPainter(value.tlines, value.tpoints, value.tpaint));
          },
        ),
      ),
    );
  }
}
