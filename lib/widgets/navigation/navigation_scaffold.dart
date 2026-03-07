import 'package:blur/functions/navigation_functions.dart';
import 'package:blur/widgets/navigation/main_navigation_bar.dart';
import 'package:flutter/material.dart';

class NavigationScaffold extends StatefulWidget {
  const NavigationScaffold({super.key, required this.child});

  final Widget child;

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: calculateSelectedIndex(context),
        onDestinationSelected: (index) {
          setState(() {
            onDestinationSelected(context, index: index);
          });
        },
      ),
    );
  }
}
