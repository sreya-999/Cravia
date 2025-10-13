import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utlis/App_color.dart';
import '../utlis/App_image.dart';
import 'boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) =>  const AutoScrollLiquidSwipeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    double logoHeight = screenHeight * 0.30;
    return  Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.secondary, AppColor.primaryColor],
            begin: AlignmentDirectional(0.0, -2.0),
            end: AlignmentDirectional(0.0, 1.0),
          ),
        ),
        child: Center(
          child: Image.asset(AppImage.logo2, height: logoHeight),
        ),
      ),
    );
  }
}
