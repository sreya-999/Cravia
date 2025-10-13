import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/App_image.dart';

import 'selection_screen.dart';
import '../utlis/App_style.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<String> _images = [
   AppImage.onboard1,
    AppImage.onboard2,
    AppImage.onboard3,
  ];

  void _onNext() {
    if (_currentPage < _images.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to your main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) return; // already popped

      },
      child: Scaffold(
        body: PageView.builder(
          controller: _controller,
          itemCount: _images.length,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
          itemBuilder: (context, index) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Full screen image
                Image.asset(
                  _images[index],
                  fit: BoxFit.cover,
                ),
      
                // Gradient overlay (optional for better button visibility)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
      
                // Bottom button
                Positioned(
                  bottom: 60,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.redAccent],
      
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: _onNext,
                      child: Text(
                        "Let's go",
                        style: AppStyle.textStyleReemKufi.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColor.whiteColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
      
              ],
            );
          },
        ),
      ),
    );
  }
}
