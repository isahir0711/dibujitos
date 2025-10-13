import 'package:dibujitos/services/custom_painter.dart';
import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  static const double defSwi = 10;

  Color currentColor = Colors.black;
  List<Offset> tempPoints = [];
  double strokeWidth = defSwi;
  List<DrawingLine> lines = [];

  var paintOptions = Paint()
    ..color = Colors.black
    ..isAntiAlias = true
    ..strokeWidth = defSwi
    ..strokeCap = StrokeCap.round;

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

  printLines() async {
    // controller.start();
    final tempLines = List<DrawingLine>.from(lines);

    lines.clear();

    for (var i = 0; i < tempLines.length; i++) {
      //TODO: drawing anim should be using the right colors
      for (var offset in tempLines[i].offsets) {
        await Future.delayed(Duration(milliseconds: 20));
        tempPoints.add(offset);
        notifyListeners();
      }
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

    // controller.stop();

    //TODO: this didn't work to create the video...
    // final frames = await controller.exporter.exportGif();
    // if (frames != null && frames.isNotEmpty) {
    //   try {
    //     final directory = await getDownloadsDirectory();
    //     final timestamp = DateTime.now().millisecondsSinceEpoch;

    //     // Save GIF first
    //     final gifPath = '${directory!.path}/drawing_$timestamp.mp4';
    //     print(gifPath);
    //     final gifFile = File(gifPath);
    //     await gifFile.writeAsBytes(frames.cast<int>());

    //     // // Convert GIF to MP4 using FFmpeg
    //     // final mp4Path = '${directory.path}/drawing_$timestamp.mp4';
    //     // final command =
    //     //     '-i "$gifPath" -movflags +faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$mp4Path"';

    //     // final session = await FFmpegKit.execute(command);
    //     // final returnCode = await session.getReturnCode();

    //     // if (ReturnCode.isSuccess(returnCode)) {
    //     //   // Delete the temporary GIF file
    //     //   await gifFile.delete();

    //     //   if (mounted) {
    //     //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Video saved to: $mp4Path')));
    //     //   }
    //     // } else {
    //     //   if (mounted) {
    //     //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to convert to MP4')));
    //     //   }
    //     // }
    //   } catch (e) {
    //     // Show error message
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    //       print(e);
    //     }
    //   }
    // }
  }
}
