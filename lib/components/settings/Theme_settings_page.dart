import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';  

class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); 

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Settings'),
      ),
      body: Center(
        child: Text(
          'Current Theme: ${themeProvider.themeMode}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
