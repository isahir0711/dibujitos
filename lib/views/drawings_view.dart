import 'package:dibujitos/components/sim_section.dart';
import 'package:dibujitos/viewmodels/main_view_mode.l.dart';
import 'package:dibujitos/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawingsView extends StatefulWidget {
  const DrawingsView({super.key});

  @override
  State<DrawingsView> createState() => DrawingsViewState();
}

class DrawingsViewState extends State<DrawingsView> {
  void navigate(int v) {
    bool hasKey = routes.containsKey(v);
    String route = hasKey ? routes[v]! : '/';
    print(route);
    Navigator.pushNamed(context, route);
  }

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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 12,
            children: [
              SimSection(),
              Expanded(
                child: Provider.of<MainViewModel>(context, listen: true).drawingsData.isNotEmpty
                    ? Consumer<MainViewModel>(
                        builder: (context, value, child) {
                          return ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 12);
                            },
                            itemCount: value.drawingsData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => value.changePrev(index),
                                child: Container(
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                                    child: Text(index.toString()),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Text("you dont have drawings yet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
