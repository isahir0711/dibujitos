import 'dart:io';
import 'dart:ui';

import 'package:dibujitos/components/drawing_options.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_recorder/screen_recorder.dart';

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

  ScreenRecorderController controller = ScreenRecorderController();

  bool _isCreatingVideo = false;

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
    controller.start();
    final tempLines = List<DrawingLine>.from(lines);

    lines.clear();

    //TODO: INSTEAD OF DRAWING AGAIN THE LINES DRAW THE POINTS TO SIMULATE THE PAINT ACTION
    //this wouldnt affet the  main behaviur of the app so we can store the points on a list that once we need it we use it to create the lines to show the 'drawing effect'
    for (var i = 0; i < tempLines.length; i++) {
      for (var offset in tempLines[i].offsets) {
        await Future.delayed(Duration(milliseconds: 20));
        setState(() {
          tempPoints.add(offset);
        });
      }
      setState(() {
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

    controller.stop();
    final frames = await controller.exporter.exportGif();
    if (frames != null && frames.isNotEmpty) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filePath = '${directory.path}/drawing_$timestamp.gif'; // or .mp4 depending on format

        final file = File(filePath);
        await file.writeAsBytes(frames.cast<int>());

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Drawing saved to: $filePath')));
        }
      } catch (e) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
        }
      }
    }
  }

  void _undo() async {
    if (lines.isNotEmpty) {
      setState(() {
        lines.removeLast();
      });
    }
  }

  void _delete() {
    setState(() {
      lines.clear();
    });
  }

  void showDrawModal() {
    //TODO: maybe use this to stablish the size of the canvas?
    final height = MediaQuery.sizeOf(context).height;
    showModalBottomSheet<void>(
      context: context,
      enableDrag: true,
      builder: (BuildContext context) {
        return CustomDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 36),
            ScreenRecorder(
              controller: controller,
              //TODO: MAGIC STRINGS
              width: 340,
              height: 340,
              child: Container(
                height: 340,
                width: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRect(
                  child: GestureDetector(
                    onPanStart: _onTouchDown,
                    onPanUpdate: _onTouchMove,
                    onPanEnd: _onTouchEnd,
                    child: CustomPaint(painter: _DrawingPainter(drawingPoints, lines, tempPoints, _isCreatingVideo)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 12,
                children: [
                  IconButton.filled(onPressed: _undo, icon: Icon(Icons.undo)),
                  IconButton.filled(onPressed: _delete, icon: Icon(Icons.delete)),
                  IconButton.filled(onPressed: showDrawModal, icon: Icon(Icons.create)),
                ],
              ),
            ),
            SizedBox(height: 36),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(onPressed: _printLines, child: Text("Save")),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(onPressed: _undo, child: Text("Upload")),
                  ),
                ],
              ),
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
  final bool creatingVideo;

  _DrawingPainter(this.drawingPoints, this.lines, this.tempPoints, this.creatingVideo);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) async {
    if (tempPoints.length > 1) {
      final tempPaint = Paint()
        ..color = selectedColor
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < tempPoints.length - 1; i++) {
        canvas.drawLine(tempPoints[i], tempPoints[i + 1], tempPaint);
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
