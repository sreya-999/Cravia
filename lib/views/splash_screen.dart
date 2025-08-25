import 'package:flutter/material.dart';

import 'dart:async';

import 'package:ravathi_store/utlis/App_image.dart';

import 'selection_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SelectionScreen()
        ),
      );// Navigate after splash
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImage.splash,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
