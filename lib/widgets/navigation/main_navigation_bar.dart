import 'package:flutter/material.dart';

class MainNavigationBar extends StatelessWidget {
  const MainNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final void Function(int index) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide())),
      child: NavigationBar(
        onDestinationSelected: onDestinationSelected,
        selectedIndex: selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: 32),
            label: "Home",
            selectedIcon: Icon(Icons.home, size: 32),
          ),
          NavigationDestination(
            icon: Icon(Icons.add_outlined, size: 32),
            label: "Add",
            selectedIcon: Icon(Icons.add, size: 32),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined, size: 32),
            label: "Profile",
            selectedIcon: Icon(Icons.person, size: 32),
          ),
        ],
      ),
    );
  }
}
