import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_app/screens/login/email_verification_screen.dart';
import 'package:pet_app/screens/root_app.dart';


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool isLogin = true;
  bool isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  AnimationController? _controller;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      isLogin = !isLogin;
      if (isLogin) {
        _controller?.reverse();
      } else {
        _controller?.forward();
      }
    });
  }

  Future<void> _authenticate(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      if (isLogin) {
        // Sign In
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Navigate to main UI after successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RootApp(), // Replace with your main UI screen
          ),
        );
      } else {
        // Sign Up
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FirebaseAuth.instance.currentUser?.updateDisplayName(_usernameController.text.trim());

        // Send email verification
        User? user = FirebaseAuth.instance.currentUser;
        await user?.sendEmailVerification();

        // Navigate to email verification screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.green, // Pet-themed color
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isLogin ? 350 : 450,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isLogin)
                        FadeTransition(
                          opacity: _fadeAnimation!,
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.pets, color: Colors.orange), // Pet-themed icon
                            ),
                          ),
                        ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.orangeAccent), // Pet-themed icon
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: Colors.brown), // Pet-themed icon
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      if (isLoading)
                        CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () => _authenticate(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange, // Pet-themed button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: Text(isLogin ? 'Login' : 'Sign Up'),
                        ),
                      TextButton(
                        onPressed: toggleView,
                        child: Text(
                          isLogin ? 'Create a new account' : 'Already have an account?',
                          style: TextStyle(color: Colors.green), // Pet-themed text color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
