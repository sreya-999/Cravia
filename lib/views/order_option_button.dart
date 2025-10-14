import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utlis/App_color.dart';
import '../utlis/App_image.dart';
import '../utlis/widgets/app_text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
class OrderOptionButton extends StatefulWidget {
  const OrderOptionButton({super.key});

  @override
  State<OrderOptionButton> createState() => _OrderOptionButtonState();
}

class _OrderOptionButtonState extends State<OrderOptionButton> {
  bool _isTakeAway = true;
  String orderText = "Takeaway";
  String orderImage = AppImage.takeaway;
  OverlayEntry? _overlayEntry;

  void _showCustomPopup(BuildContext context, Offset position) {
    String alternativeOption = _isTakeAway ? "Dine In" : "Takeaway";
    String alternativeImage = _isTakeAway ? AppImage.dinein : AppImage.takeaway;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + 40, // show below the button
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColor.secondary, AppColor.primaryColor],
                  begin: AlignmentDirectional(0.0, -2.0),
                  end: AlignmentDirectional(0.0, 1.0),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () async {
                  setState(() {
                    orderText = alternativeOption;
                    _isTakeAway = alternativeOption == "Takeaway";
                    orderImage = _isTakeAway ? AppImage.takeaway : AppImage.dinein;
                  });

                  // TODO: Update providers and SharedPreferences here
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 28,
                      height: 25,
                      child: SvgPicture.asset(
                        alternativeImage,
                        fit: BoxFit.fill,
                        color: AppColor.whiteColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      alternativeOption,
                      style: AppTextStyles.nunitoBold(14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _showCustomPopup(context, details.globalPosition);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.secondary, AppColor.primaryColor],
            begin: AlignmentDirectional(0.0, -2.0),
            end: AlignmentDirectional(0.0, 1.0),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 25,
              child: SvgPicture.asset(
                orderImage,
                fit: BoxFit.fill,
                color: AppColor.whiteColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              orderText,
              style: AppTextStyles.nunitoBold(14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
