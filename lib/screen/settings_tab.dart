import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:term_project/settings_category/category_management_screen.dart'; // 카테고리 관리 화면 추가
import '../main.dart'; // ThemeProvider 클래스 가져오기

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Manage Categories'),
            subtitle: Text('Add and manage Subject and General categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
              );
            },
          ),
          Divider(), // 구분선 추가
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            subtitle: Text('Enable or disable dark mode'),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(value); // 테마 변경 호출
              },
            ),
          ),
        ],
      ),
    );
  }
}
