import 'package:dibujitos/components/drawing_section.dart';
import 'package:dibujitos/components/drawing_tools.dart';
import 'package:dibujitos/components/ui/button.dart';
import 'package:dibujitos/viewmodels/main_view_mode.l.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.title});

  final String title;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var scr = GlobalKey();

  @override
  void initState() {
    Provider.of<MainViewModel>(context, listen: false).setSCR(scr);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 36),
            DrawingSection(scr: scr),
            SizedBox(height: 36),
            DrawingTools(),
            SizedBox(height: 36),
            // this can be do better, the whole "div" should have a padding x
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Consumer<MainViewModel>(
                    builder: (context, value, child) {
                      return CustomButton(label: 'Draw it', action: value.printLines);
                    },
                  ),
                  SizedBox(height: 16),
                  Consumer<MainViewModel>(
                    builder: (context, value, child) {
                      return CustomButton(label: 'Save it', action: value.saveImage);
                    },
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
