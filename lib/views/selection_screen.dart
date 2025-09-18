import 'package:flutter/material.dart';
import 'package:ravathi_store/service/download_manager.dart';

import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/utlis/App_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../utlis/share_preference_helper/sharereference_helper.dart';
import '../utlis/widgets/app_text_style.dart';
import 'home_screen.dart';

void main() {
  runApp(MaterialApp(home: SelectionScreen()));
}

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final bool isDesktop = screenWidth >= 1024;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double logoHeight = screenHeight * 0.30;
          double spacing = screenHeight * 0.05;

          return Stack(
            children: [
              /// Background gradient
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.secondary, AppColor.primaryColor],
                      begin: AlignmentDirectional(0.0, -2.0), // top-center
                      end: AlignmentDirectional(0.0, 1.0), // bottom-center
                      stops: [0.0, 1.0], // smooth gradient
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
              ),

              /// Foreground UI
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Column(
                    children: [
                      /// Scrollable main content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: spacing * 0.8),

                              /// App Logo
                              Image.asset(AppImage.logo2, height: logoHeight),

                              SizedBox(height: spacing * 1.2),

                              /// Dine-In & Takeaway options
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildOption(
                                    context: context,
                                    label: 'Dine-In',
                                    svgAssetPath: AppImage.dinein,
                                    isSelected: selectedOption == 'dinein',
                                    onTap: () async {
                                      Provider.of<CategoryProvider>(context, listen: false).setDineIn(true);
                                      setState(() => selectedOption = 'dinein');

                                      await getIt<SharedPreferenceHelper>().storeStringData(
                                        key: StorageKey.dineInOption,
                                        value: "dinein",
                                      );
                                      await getIt<SharedPreferenceHelper>().storeBoolData(
                                        key: StorageKey.isTakeAway,
                                        value: false,
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                                      );
                                    },
                                  ),
                                  SizedBox(width: screenWidth * 0.05),
                                  _buildOption(
                                    context: context,
                                    label: 'Take Away',
                                    svgAssetPath: AppImage.takeaway,
                                    isSelected: selectedOption == 'takeaway',
                                    onTap: () async {
                                      Provider.of<CategoryProvider>(context, listen: false).setDineIn(false);
                                      setState(() => selectedOption = 'takeaway');

                                      await getIt<SharedPreferenceHelper>().storeStringData(
                                        key: StorageKey.dineInOption,
                                        value: "takeaway",
                                      );

                                      await getIt<SharedPreferenceHelper>().storeBoolData(
                                        key: StorageKey.isTakeAway,
                                        value: true,
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              SizedBox(height: spacing * 2),
                            ],
                          ),
                        ),
                      ),

                      /// Fixed bottom "Powered by M8"
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      //   child: Text(
                      //     'Powered by M8',
                      //     style: AppStyle.textStyleLobster.copyWith(
                      //       fontSize: isDesktop ? 18 : 16,
                      //       color: AppColor.whiteColor,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

    );
  }


  Widget _buildOption({
    required BuildContext context,
    required String label,
    required String svgAssetPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;


    final double width = isWide ? screenWidth * 0.25 : screenWidth * 0.4;
    final double height = isWide ? 150 : 120;
    final double iconSize = isWide ? 100 : 52;
    final double fontSize = isWide ? 22 : 16;

    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.95, end: isSelected ? 1.0 : 0.95),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                      colors: [AppColor.primaryColor, AppColor.secondary], // Your gradient colors
                    )
                        : null,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.all(isSelected ? 5 : 1),
                  child: Container(
                    width: width,
                    height: height,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: !isSelected
                          ? Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppColor.blackColor.withOpacity(0.4)
                              : Colors.grey.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        svgAssetPath,
                        height: iconSize,
                        width: iconSize,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  label,
                  style: AppTextStyles.nunitoBold(fontSize, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }



}
