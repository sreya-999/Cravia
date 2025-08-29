 import 'package:flutter/material.dart';
import 'package:ravathi_store/utlis/App_color.dart';

class GradientSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required Offset thumbCenter,
        Offset? secondaryOffset,
        bool isEnabled = false,
        bool isDiscrete = false,
        required TextDirection textDirection,
      }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Gradient gradient = LinearGradient(
      colors: <Color>[
        AppColor.primaryColor,
        AppColor.secondary,
        AppColor.primaryColor,
      ],
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(trackRect);

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(trackRect.height / 2)),
      paint,
    );
  }
}
