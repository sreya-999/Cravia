import 'package:flutter/material.dart';

class ResponsiveHelper {
  final BuildContext context;
  late final double screenWidth;
  late final bool isDesktop;
  late final bool isTablet;

  ResponsiveHelper(this.context) {
    screenWidth = MediaQuery.of(context).size.width;
    isDesktop = screenWidth >= 1024;
    isTablet = screenWidth >= 600 && screenWidth < 1024;
  }

  /// Button font size
  double getButtonFontSize({
    double mobile = 16,
    double tablet = 17,
    double desktop = 27,
  }) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet;
    return mobile;
  }

  /// Medium text size
  double getMediumFontSize({
    double mobile = 14,
    double tablet = 16,
    double desktop = 20,
  }) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet;
    return mobile;
  }
}
