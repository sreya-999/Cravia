import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:ravathi_store/utlis/widgets/responsiveness.dart';

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:ravathi_store/views/selection_screen.dart';
import 'package:ravathi_store/views/splash_screen.dart';

import '../utlis/App_color.dart';
import '../utlis/App_style.dart';
import '../utlis/widgets/app_text_style.dart';

class AutoScrollLiquidSwipeScreen extends StatefulWidget {
  const AutoScrollLiquidSwipeScreen({super.key});

  @override
  State<AutoScrollLiquidSwipeScreen> createState() =>
      _AutoScrollLiquidSwipeScreenState();
}

class _AutoScrollLiquidSwipeScreenState
    extends State<AutoScrollLiquidSwipeScreen>
    with SingleTickerProviderStateMixin {
  late LiquidController _liquidController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();


    _liquidController = LiquidController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    final List<Widget> pages = [
      _buildPage(
        context: context,
        bgColor: const Color(0xFFFFC107),
        imageUrl: "assets/icons/onboard1.png",
        title: 'Make It Your Way!',
        subtitle: 'Turn your meal into a feast — add a little extra love!',
        buttonText: 'Order Now',
        isTablet: isTablet,
      ),
      _buildPage(
        context: context,
        bgColor: const Color(0xFFEF5350),
        imageUrl: "assets/icons/onboard2.png",
        title: 'Order Smart. Dine Easy.',
        subtitle: 'Taste the best burgers in town!',
        buttonText: 'Order Now',
        isTablet: isTablet,
      ),
      _buildPage(
        context: context,
        bgColor: Colors.blueAccent,
        imageUrl: "assets/icons/onboard7.png",
        title: 'Meal Deals You’ll Love',
        subtitle: 'A tasty combo at a great price — just for you.',
        buttonText: 'Order Now',
        isTablet: isTablet,
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        // Navigate to splash screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SplashScreen()),
        );
        // Prevent default back action
        return false;
      },
      child: Scaffold(
        body: LiquidSwipe(
          pages: pages,
          liquidController: _liquidController,
          enableLoop: true,
          enableSideReveal: false,
          waveType: WaveType.liquidReveal,
          positionSlideIcon: 0.8,
          slideIconWidget: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPageChangeCallback: (page) {
            _animationController.reset();
            _animationController.forward();
          },
        ),
      ),
    );
  }

  Widget _buildPage({
    required BuildContext context,
    required Color bgColor,
    required String imageUrl,
    required String title,
    required String subtitle,
    required String buttonText,
    required bool isTablet,
  }) {
    final responsive = Responsiveness(context);
    return Container(
        width: MediaQuery.of(context).size.width,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor.withOpacity(0.9), bgColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 10),
          Image.asset(
                  imageUrl,
                  height: isTablet ? 350 : 250,
                  fit: BoxFit.contain,
                ),

              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Text(
                        title,
                        style:  AppStyle.textStyleLobster.copyWith(
                  color: Colors
                      .white,
                    fontSize:responsive.onBoarding,
                    fontWeight: FontWeight.w700,
                  ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                            style: AppTextStyles
                                .nunitoRegular(
                                responsive
                                    .priceTotal,
                                color: AppColor
                                    .whiteColor)
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Button animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: bgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    elevation: 6,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>  SelectionScreen()),
                    );
                  },
                  child: Text(
                    buttonText,
                    style: AppStyle
                        .textStyleReemKufi
                        .copyWith(
                      fontSize: responsive.mainTitleSize,
                      fontWeight: FontWeight.w600,
                    ),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

