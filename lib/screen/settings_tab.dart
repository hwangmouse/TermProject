import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:term_project/settings_category/category_management_screen.dart'; // Category management screen import
import '../main.dart'; // Import ThemeProvider

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'), // App bar title
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.category), // Icon for category management
            title: Text('Manage Categories'), // Title for category management
            subtitle: Text('Add and manage Subject and General categories'), // Subtitle
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryManagementScreen(), // Navigate to category management
                ),
              );
            },
          ),
          Divider(), // Divider between list items
          ListTile(
            leading: Icon(Icons.dark_mode), // Icon for dark mode
            title: Text('Dark Mode'), // Title for dark mode
            subtitle: Text('Enable or disable dark mode'), // Subtitle
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark, // Dark mode state
              onChanged: (value) {
                themeProvider.toggleTheme(value); // Call theme toggle method
              },
            ),
          ),
        ],
      ),
    );
  }
}
