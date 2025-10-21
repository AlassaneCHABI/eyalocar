import 'package:eyav2/new/entry_screen.dart';
import 'package:eyav2/new/sign-in.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final String? email;
  SplashScreen({super.key, this.email});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3), () {});

    if (widget.email == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EntryScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.85,
            child: Image.asset(
              'assets/back-car.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            color: Color(0xFF104912).withOpacity(0.80),
          ),
          Center(child: Image.asset('assets/logo-4x.png', height: 100)),
          ],
      ),
    );
  }

  }
