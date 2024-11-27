import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:term_project/components/bottom_navigation.dart';
import 'package:term_project/cons/schedule_provider.dart'; // ScheduleProvider for schedule management
import 'package:term_project/cons/colors.dart';
import 'package:term_project/alarm/background_alarm.dart'; // For initializing alarms and background tasks

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter system bindings
  print("Initializing alarms..."); // Debug log
  await initializeAlarms(); // Initialize local notifications
  print("Alarms initialized."); // Debug log

  print("Registering background alarms..."); // Debug log
  registerBackgroundAlarms(); // Register background alarm tasks
  print("Background alarms registered."); // Debug log

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScheduleProvider()), // Schedule state management
        ChangeNotifierProvider(create: (context) => ThemeProvider()), // Theme state management
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access theme provider

    return MaterialApp(
      title: 'Navigation Example',
      theme: ThemeData(
        brightness: Brightness.light, // Light theme settings
        primaryColor: PRIMARY_COLOR,
        scaffoldBackgroundColor: LIGHT_GREY_COLOR,
        appBarTheme: AppBarTheme(
          backgroundColor: PRIMARY_COLOR,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: PRIMARY_COLOR,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: DARK_GREY_COLOR),
          bodyMedium: TextStyle(color: DARK_GREY_COLOR),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Dark theme settings
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.grey[800],
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: themeProvider.themeMode, // Dynamically switch theme based on provider
      home: BottomNavigationScreen(), // Main screen with bottom navigation
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Default to light theme

  ThemeMode get themeMode => _themeMode; // Current theme mode

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light; // Toggle theme mode
    notifyListeners(); // Notify listeners of the state change
  }
}
