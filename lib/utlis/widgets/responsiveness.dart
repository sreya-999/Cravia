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
    if (isDesktop) return 25;
    if (isTablet) return 17;
    return 16;
  }

  /// Price Text Size
  double get priceSize {
    if (isDesktop) return 27;
    if (isTablet) return 20;
    return 20;
  }

  /// Description Text Size
  double get descriptionSize {
    if (isDesktop) return 20;
    if (isTablet) return 15;
    return 15;
  }

  /// Main Title Text Size
  double get mainTitleSize {
    if (isDesktop) return 32;
    if (isTablet) return 26;
    return 22;
  }

  /// Subtitle Text Size
  double get subtitleSize {
    if (isDesktop) return 24;
    if (isTablet) return 20;
    return 15;
  }
}
