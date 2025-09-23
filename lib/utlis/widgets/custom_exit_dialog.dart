import 'package:flutter/material.dart';

import '../App_color.dart';
import 'app_text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomActionDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String title,           // Main message
    // Subtext/description
    required String imagePath,       // Top icon
    Color iconColor = Colors.orange, // Icon background color
    String cancelText = "Cancel",    // Left button text
    String confirmText = "Confirm",  // Right button text
    Color confirmButtonColor = AppColor.primaryColor, // Right button color
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Can't close by tapping outside
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Slightly larger corners
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              /// Main Container
              Container(
                width: screenSize.width * 0.9, // Increased width (90% of screen width)
                padding: const EdgeInsets.fromLTRB(24, 50, 24, 24), // More padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.nunitoMedium(
                        18, // Increased title font size
                        color: AppColor.blackColor,
                      ),
                    ),

                    // Message
                    const SizedBox(height: 34),

                    /// Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel Button
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColor.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              cancelText,
                              style: AppTextStyles.nunitoRegular(
                                16,
                                color: AppColor.blackColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Confirm Button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: confirmButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              confirmText,
                              style: AppTextStyles.nunitoMedium(
                                16,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Top Floating SVG Icon
              Positioned(
                top: -12, // Position it slightly higher
                child: SvgPicture.asset(
                    imagePath,
                    width: 40,  // Larger SVG
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),

            ],
          ),
        );
      },
    );
  }
}

