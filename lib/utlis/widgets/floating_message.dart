import 'package:flutter/material.dart';
import 'package:ravathi_store/utlis/widgets/responsiveness.dart';

import 'app_text_style.dart';

class FloatingMessage {
  static void show(
      {required BuildContext context,
        required GlobalKey key,
        required String message,
        Duration duration = const Duration(seconds: 2)}) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final responsive = Responsiveness(context);
    final overlay = Overlay.of(context);
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy - 50, // above the button
        left: (screenWidth - size.width) / 2, // center horizontally
        width: size.width, // match button width
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.nunitoRegular(responsive.hintTextSize, color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(duration, () {
      entry.remove();
    });
  }
}


class FloatingMessages {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).size.height * 0.1, // 10% from top
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style:  AppTextStyles.nunitoMedium(14,color:Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(duration, () {
      entry.remove();
    });
  }
}

