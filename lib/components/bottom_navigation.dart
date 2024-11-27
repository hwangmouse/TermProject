import 'package:flutter/material.dart';
import 'package:term_project/screen/home_tab.dart' as home_screen; // Alias added for HomeScreen
import 'package:term_project/screen/settings_tab.dart'; // SettingsTab import
import 'package:term_project/screen/weekly_tab.dart'; // WeeklyTab import
import 'package:term_project/cons/colors.dart'; // Colors import for theme

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0; // Index of the currently selected tab
  final List<Widget> _screens = [
    home_screen.HomeScreen(), // Referencing HomeScreen using the alias
    WeeklyTab(), // This Week screen
    SettingsTab(), // Alarm/Settings screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the currently selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Highlight the selected tab
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected tab index
          });
        },
        selectedItemColor: PRIMARY_COLOR, // Color for the selected tab
        unselectedItemColor: DARK_GREY_COLOR, // Color for unselected tabs
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon for the Home tab
            label: 'Home', // Label for the Home tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check), // Icon for the Algorithm tab
            label: 'Algorithm', // Label for the Algorithm tab
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
