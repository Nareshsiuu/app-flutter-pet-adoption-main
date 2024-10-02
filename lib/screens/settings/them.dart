import 'package:flutter/material.dart';

class AppThemeScreen extends StatefulWidget {
  @override
  _AppThemeScreenState createState() => _AppThemeScreenState();
}

class _AppThemeScreenState extends State<AppThemeScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Theme'),
      ),
      body: Center(
        child: SwitchListTile(
          title: Text('Enable Dark Mode'),
          value: isDarkMode,
          onChanged: (value) {
            setState(() {
              isDarkMode = value;
            });
          },
        ),
      ),
    );
  }
}
