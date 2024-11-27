import 'package:flutter/material.dart';
import 'package:term_project/screen/home_tab.dart' as home_screen; // Add alias for HomeScreen
import 'package:term_project/screen/settings_tab.dart';
import 'package:term_project/screen/weekly_tab.dart';
import 'package:term_project/cons/colors.dart';

// BottomNavigationScreen is a StatefulWidget that manages bottom navigation
class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0; // The index of the currently selected tab
  final List<Widget> _screens = [
    home_screen.HomeScreen(), // Reference HomeScreen using its alias
    WeeklyTab(), // Weekly tab screen
    SettingsTab(), // Settings tab screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the screen corresponding to the current index
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Highlight the selected tab
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab index
          });
        },
        selectedItemColor: PRIMARY_COLOR, // Color of the selected item
        unselectedItemColor: DARK_GREY_COLOR, // Color of unselected items
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon for the Home tab
            label: 'Home', // Label for the Home tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check), // Icon for the Weekly tab
            label: 'Algorithm', // Label for the Weekly tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Icon for the Settings tab
            label: 'Settings', // Label for the Settings tab
          ),
        ],
      ),
    );
  }
}
