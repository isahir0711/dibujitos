import 'package:dibujitos/components/sim_sections.dart';
import 'package:dibujitos/viewmodels/main_view_mode.l.dart';
import 'package:dibujitos/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawingsView extends StatefulWidget {
  const DrawingsView({super.key});

  @override
  State<DrawingsView> createState() => DrawingsViewState();
}

//TODO: MOVE THIS TO VIEW MODEL
// ONCE TAPED THE VIEW MODEL CHANGES THE current drawing
class DrawingsViewState extends State<DrawingsView> {
  void navigate(int v) {
    bool hasKey = routes.containsKey(v);
    String route = hasKey ? routes[v]! : '/';
    print(route);
    Navigator.pushNamed(context, route);
  }

  @override
  void initState() {
    // String demo = Provider.of<MainViewModel>(context, listen: false).drawingsData[0];
    // print(demo);
    super.initState();
  }

  // _changeSelected(int index) {
  //   setState(() {
  //     selected = drawingsData[index];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => {navigate(value)},
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.draw), label: 'Drawings'),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Provider.of<MainViewModel>(context, listen: false).currDrawing != ""
                ? Consumer<MainViewModel>(
                    builder: (context, value, child) {
                      return SimSection(drawingData: value.currDrawing);
                    },
                  )
                : Text("NO drawings"),
            Row(children: [Text("Here you could pick the drawing to render")]),
            Expanded(
              child: Provider.of<MainViewModel>(context, listen: true).drawingsData.isNotEmpty
                  ? Consumer<MainViewModel>(
                      builder: (context, value, child) {
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                          itemCount: value.drawingsData.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => value.changePrev(index),
                              child: Container(color: Colors.amber, child: Text(value.drawingsData[index])),
                            );
                          },
                        );
                      },
                    )
                  : Text("dude"),
            ),
          ],
        ),
      ),
    );
  }
}
