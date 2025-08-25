import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

   ShimmerWidget.rectangular({
    super.key,
    required this.width,
    required this.height,
    BorderRadius? borderRadius,
  }) : shapeBorder = RoundedRectangleBorder(
    borderRadius: borderRadius ?? BorderRadius.circular(8),
  );

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
  }) : shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: Colors.grey.shade400,
        shape: shapeBorder,
      ),
    ),
  );
}

