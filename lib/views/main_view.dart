import 'dart:io';
import 'dart:ui';

import 'package:dibujitos/components/drawing_options.dart';
import 'package:dibujitos/services/custom_painter.dart';
import 'package:dibujitos/viewmodels/main_view_mode.l.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screen_recorder/screen_recorder.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.title});

  final String title;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  double canvasHeight = 340;
  double canvasWidth = 340;

  ScreenRecorderController controller = ScreenRecorderController();

  bool _isCreatingVideo = false;

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
              width: canvasHeight,
              height: canvasWidth,
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
                child: Consumer<MainViewModel>(
                  builder: (context, viewmodel, child) {
                    return ClipRect(
                      child: GestureDetector(
                        onPanStart: viewmodel.onTouchDown,
                        onPanUpdate: viewmodel.onTouchMove,
                        onPanEnd: viewmodel.onTouchEnd,
                        child: CustomPaint(
                          painter: DrawingPainter(
                            viewmodel.lines,
                            viewmodel.tempPoints,
                            _isCreatingVideo,
                            viewmodel.paintOptions,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Consumer<MainViewModel>(
                builder: (context, viewmodel, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 12,
                    children: [
                      IconButton.filled(onPressed: viewmodel.undo, icon: Icon(Icons.undo)),
                      IconButton.filled(onPressed: viewmodel.delete, icon: Icon(Icons.delete)),
                      IconButton.filled(onPressed: showDrawModal, icon: Icon(Icons.create)),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 36),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                children: [
                  Expanded(
                    child: Consumer<MainViewModel>(
                      builder: (context, viewmodel, child) {
                        return ElevatedButton(onPressed: viewmodel.printLines, child: Text("Save"));
                      },
                    ),
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
                    child: ElevatedButton(onPressed: () {}, child: Text("Upload")),
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
