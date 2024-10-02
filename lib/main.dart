import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login/login.dart'; // Your login screen
import 'screens/root_app.dart'; // Your main UI screen
import 'theme/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet App',
      theme: ThemeData(
        primaryColor: AppColor.primary,
      ),
      home: AuthCheck(), // Check authentication status
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if a user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, show the main UI
      return RootApp(); // Replace with your main UI screen
    } else {
      // User is not logged in, show the login screen
      return AuthScreen(); // Your login screen
    }
  }
}
