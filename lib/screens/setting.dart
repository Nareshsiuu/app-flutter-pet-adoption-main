import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/screens/login/login.dart';
import 'package:pet_app/screens/settings/history.dart';
import 'package:pet_app/screens/settings/notify.dart';
import 'package:pet_app/screens/settings/policy.dart';
import 'package:pet_app/screens/settings/profile.dart';
import 'package:pet_app/screens/settings/term.dart';
import 'package:pet_app/screens/settings/them.dart';

class Setting extends StatefulWidget {


  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification Preferences'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationSettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Adoption History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdoptionHistoryScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('App Theme'),
            subtitle: Text('Light/Dark Mode'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppThemeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.rule),
            title: Text('Terms & Conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TermsConditionsScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () async {await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AuthScreen()),
            );
              // Handle logout functionality
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out successfully!')));
            },
          ),
        ],
      ),
    );
  }
}
