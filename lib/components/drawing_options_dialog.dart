import 'package:dibujitos/viewmodels/main_view_mode.l.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawingOptionsDialog extends StatefulWidget {
  final Function(Color, double)? onSelectionChanged;

  const DrawingOptionsDialog({super.key, this.onSelectionChanged});

  @override
  State<DrawingOptionsDialog> createState() => _DrawingOptionsDialogState();
}

class _DrawingOptionsDialogState extends State<DrawingOptionsDialog> {
  double _currentSliderValue = 5.0; // Default brush size

  // Expanded color palette similar to the image
  final List<Color> colors = [
    Colors.black,
    Colors.grey[800]!,
    Colors.grey[600]!,
    Colors.grey[400]!,
    Colors.white,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
  ];

  void pickColor(Color selected) {
    Provider.of<MainViewModel>(context, listen: false).changeColor(selected);
    // Navigator.pop(context);
  }

  void _onBrushSizeChanged(double size) {
    Provider.of<MainViewModel>(context, listen: false).changeStrokeWidth(size);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: height / 2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color picker title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('Choose Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),

            // Color picker grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, // 6 colors per row
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    final color = colors[index];
                    //TODO: Wrap with a provider widget maybe?
                    final isSelected = color == Provider.of<MainViewModel>(context, listen: true).currentColor;

                    return GestureDetector(
                      onTap: () => pickColor(color),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.shade300,
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(7, 0, 0, 0),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Brush size slider
            const Text('Brush Size', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Text('1', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: Slider(
                      //TODO : USE CONSUMER INSTEAD
                      value: Provider.of<MainViewModel>(context, listen: true).strokeWidth,
                      min: 1,
                      max: 20,
                      divisions: 19,
                      label: Provider.of<MainViewModel>(context, listen: true).strokeWidth.round().toString(),
                      onChanged: (double value) {
                        _onBrushSizeChanged(value);
                      },
                    ),
                  ),
                  const Text('20', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
