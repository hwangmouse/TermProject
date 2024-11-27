import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main structure of the screen
      body: Center(
        // Center the content
        child: Text(
          'Home Screen', // Displayed text
          style: TextStyle(fontSize: 24.0), // Font size for the text
        ),
      ),
    );
  }
}
