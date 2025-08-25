import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../App_color.dart';

class ShowSnackBar {
  static OverlayEntry? _overlayEntry;

  void customSnackBar({
    required BuildContext context,
    required String type,
    required String strMessage,
    Duration duration = const Duration(seconds: 4),
  }) {
    _overlayEntry?.remove(); // Remove existing snackbar if any

    OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom + 10, // Positioning at top
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: type == "1" ? AppColor.greenColor : AppColor.redColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    strMessage,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColor.whiteColor,
                      // fontFamily: AppFonts.fontOutFit,
                    ),
                  ),
                ),
                // Lottie.asset(
                //   type == "1"
                //       ? 'assets/lottie/snack_success.json'
                //       : 'assets/lottie/snack_failed.json',
                //   width: 24,
                //   height: 24,
                //   repeat: false,
                // ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);

    // Remove after the specified duration
    Future.delayed(duration, () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}