import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:pet_app/screens/root_app.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  bool isLoading = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _checkEmailVerifiedPeriodically();
  }

  Future<void> _checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    setState(() {
      isEmailVerified = user?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      timer?.cancel();
      // Navigate to main UI after email verification
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RootApp()),
      );
    }
  }

  void _checkEmailVerifiedPeriodically() {
    timer = Timer.periodic(Duration(seconds: 5), (_) => _checkEmailVerified());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      isLoading = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification email sent!')));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send verification email')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Your Email'),
        centerTitle: true,
        backgroundColor: Colors.green, // Pet-themed color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'email_verification',
                child: Icon(Icons.pets, size: 100, color: Colors.orange), // Pet-themed icon
              ),
              SizedBox(height: 20),
              Text(
                'A verification email has been sent to your email. Please verify your account to proceed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.brown), // Pet-themed text style
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkEmailVerified,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent, // Pet-themed button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('I have verified my email'),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _resendVerificationEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Pet-themed button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Resend Verification Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}