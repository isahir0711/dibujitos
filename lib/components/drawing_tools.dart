import 'package:dibujitos/components/drawing_options_dialog.dart';
import 'package:dibujitos/viewmodels/main_view_mode.l.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawingTools extends StatefulWidget {
  const DrawingTools({super.key});

  @override
  State<DrawingTools> createState() => _DrawingToolsState();
}

class _DrawingToolsState extends State<DrawingTools> {
  void showDrawModal() {
    //TODO: maybe use this to stablish the size of the canvas?
    final height = MediaQuery.sizeOf(context).height;
    showModalBottomSheet<void>(
      context: context,
      enableDrag: true,
      builder: (BuildContext context) {
        return DrawingOptionsDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
