import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dibujitos/components/drawing_options.dart';
import 'package:dibujitos/services/custom_painter.dart';
import 'package:dibujitos/viewmodels/main_view_mode.l.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path/path.dart' as p;

class MainView extends StatefulWidget {
  const MainView({super.key, required this.title});

  final String title;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  double canvasHeight = 340;
  double canvasWidth = 340;
  var scr = GlobalKey();

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

  Future<void> saveImage() async {
    //not really sure if we need this, if not delete the Manifest User permissions as well
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    //TODO: move this to a separate function to get the correct dir
    var dir = Directory('');
    if (Platform.isAndroid) {
      //TODO: create a folder for the drawings iunstead of using the Download one
      dir = Directory("/storage/emulated/0/Download/");
    } else {
      final docsDir = await getApplicationDocumentsDirectory();
      dir = Directory(docsDir.path);
    }
    RenderRepaintBoundary boundary = scr.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = await bytes!.buffer.asUint8List();
    //TODO: file name should be timestamp
    String fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.png';
    String completedir = p.join(dir.path, fileName);
    File newFile = File(completedir);
    try {
      await newFile.writeAsBytes(pngBytes);
    } catch (e) {
      print(e);
    }
  }

  //TODO: create components for the different sections of the view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 36),
            RepaintBoundary(
              key: scr,
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
                          painter: DrawingPainter(viewmodel.lines, viewmodel.tempPoints, viewmodel.paintOptions),
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
                    child: ElevatedButton(onPressed: saveImage, child: Text("Upload")),
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
