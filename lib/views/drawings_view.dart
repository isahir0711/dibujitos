import 'package:dibujitos/components/sim_sections.dart';
import 'package:dibujitos/views/main_view.dart';
import 'package:flutter/material.dart';

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
      body: SafeArea(child: SimSection()),
    );
  }
}
