import 'package:flutter/material.dart';





class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationPreferencesPageState createState() => _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState extends State<NotificationSettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  bool _smsNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Preferences'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your notification preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Email Notifications'),
              subtitle: Text('Receive notifications via email'),
              value: _emailNotifications,
              onChanged: (bool value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Push Notifications'),
              subtitle: Text('Receive notifications via app push'),
              value: _pushNotifications,
              onChanged: (bool value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('SMS Notifications'),
              subtitle: Text('Receive notifications via SMS'),
              value: _smsNotifications,
              onChanged: (bool value) {
                setState(() {
                  _smsNotifications = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}