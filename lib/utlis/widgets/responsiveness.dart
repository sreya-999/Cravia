import 'package:flutter/material.dart';

class Responsiveness {
  final BuildContext context;

  Responsiveness(this.context);

  // ✅ Get screen width
  double get screenWidth => MediaQuery.of(context).size.width;

  // ✅ Check if device is desktop
  bool get isDesktop => screenWidth >= 1024;

  // ✅ Check if device is tablet
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  // ✅ Check if device is mobile
  bool get isMobile => screenWidth < 600;

  /// Button Font Size
  double get buttonFontSize {
    if (isDesktop) return 22;
    if (isTablet) return 17;
    return 16;
  }

  /// Price Text Size
  double get priceSize {
    if (isDesktop) return 23;
    if (isTablet) return 20;
    return 20;
  }

  /// Description Text Size
  double get descriptionSize {
    if (isDesktop) return 22;
    if (isTablet) return 20;
    return 14;
  }

  /// Main Title Text Size
  double get mainTitleSize {
    if (isDesktop) return 24;
    if (isTablet) return 22;
    return 20;
  }
  double get adOn {
    if (isDesktop) return 24;
    if (isTablet) return 22;
    return 17;
  }
  /// Subtitle Text Size
  double get subtitleSize {
    if (isDesktop) return 22;
    if (isTablet) return 20;
    return 16;
  }
  double get save {
    if (isDesktop) return 23;
    if (isTablet) return 20;
    return 12;
  }

  double get heading {
    if (isDesktop) return 30;
    if (isTablet) return 30;
    return 22;
  }
  double get hintTextSize {
    if (isDesktop) return 18; // Desktop
    if (isTablet) return 18;  // Tablet
    return 14;                // Mobile
  }

  double get badgeSize {
    if (isDesktop) return 90; // Desktop
    if (isTablet) return 90;  // Tablet
    return 80;                // Mobile
  }
  double get productName {
    if (isDesktop) return 27; // Desktop
    if (isTablet) return 25;  // Tablet
    return 20;                // Mobile
  }

  double get time {
    if (isDesktop) return 15; // Desktop
    if (isTablet) return 14;  // Tablet
    return 12;                // Mobile
  }

  double get subTotal {
    if (isDesktop) return 30;
    if (isTablet) return 28;
    return 20;
  }

  double get subTitle {
    if (isDesktop) return 18;
    if (isTablet) return 16;
    return 10;
  }

  double get category {
    if (isDesktop) return 18; // Desktop
    if (isTablet) return 16;  // Tablet
    return 14;                // Mobile
  }
  double get success {
    if (isDesktop) return 43; // Desktop
    if (isTablet) return 40;  // Tablet
    return 30;                // Mobile
  }
  double get des {
    if (isDesktop) return 18; // Desktop
    if (isTablet) return 16;  // Tablet
    return 12;                // Mobile
  }

  double get priceTitle {
    if (isDesktop) return 18; // Desktop
    if (isTablet) return 17;  // Tablet
    return 16;                // Mobile
  }
  double get priceTotal {
    if (isDesktop) return 24; // Desktop
    if (isTablet) return 22;  // Tablet
    return 17;                // Mobile
  }
  double get onBoarding {
    if (isDesktop) return 32; // Desktop
    if (isTablet) return 30;  // Tablet
    return 25;                // Mobile
  }
}
