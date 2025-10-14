import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/views/buy_one_get_one.dart';


import '../utlis/App_image.dart';
import '../utlis/widgets/app_text_style.dart';
import '../utlis/widgets/responsiveness.dart';
import 'combo_offer_screen.dart';
import 'home_screen.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({Key? key}) : super(key: key);

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool isMenuOpen = false;


  @override
  Widget build(BuildContext context) {
    final responsive = Responsiveness(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight = responsive.adOn + screenHeight * 0.03; // font size + vertical padding
    double fontSize = responsive.adOn.toDouble();
    double horizontalPadding = screenWidth * 0.03;
    double verticalPadding = screenHeight * 0.015;

    // Calculate container height based on font size + vertical padding

    return GestureDetector(
      onTap: () async {
        // Open the popup menu
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
        final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

        final double screenHeight = MediaQuery.of(context).size.height;
        final double spaceAbove = screenHeight * 0.20;

        final selected = await showMenu<String>(
          context: context,
          position: RelativeRect.fromRect(
            Rect.fromLTWH(
              position.dx,
              position.dy - spaceAbove,
              button.size.width,
              button.size.height,
            ),
            Offset.zero & overlay.size,
          ),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          items: [
            PopupMenuItem<String>(
              enabled: false,
              height: 30, // reduce default height
             // padding: EdgeInsets.zero, // remove default padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      AppImage.cross,
                      color: AppColor.blackColor,
                      height: responsive.mainTitleSize,
                      width: responsive.mainTitleSize,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: "BuyOneGetOne",
              height: 35, // reduce item height
              padding: EdgeInsets.symmetric(horizontal: 10), // adjust horizontal padding
              child: Text(
                "Buy One Get One",
                style: AppTextStyles.nunitoMedium(
                  responsive.adOn,
                  color: AppColor.blackColor,
                ),
              ),
            ),
            PopupMenuItem(
              value: "Combo",
              height: 35,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Combo Offer",
                style: AppTextStyles.nunitoMedium(
                  responsive.adOn,
                  color: AppColor.blackColor,
                ),
              ),
            ),
            PopupMenuItem(
              value: "HomeScreen",
              height: 35,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Home Screen",
                style: AppTextStyles.nunitoMedium(
                  responsive.adOn,
                  color: AppColor.blackColor,
                ),
              ),
            ),

          ],
        );

        if (selected != null) {
          switch (selected) {
            case "BuyOneGetOne":
              Navigator.push(context, MaterialPageRoute(builder: (_) => BuyOneGetOne()));
              break;
            case "Combo":
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ComboOfferScreen()));
              break;
            case "HomeScreen":
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              break;
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
          border: Border.all(
            color: AppColor.primaryColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left text container
            Container(
              height: containerHeight,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "MENU",
                style: AppTextStyles.latoBold(
                  fontSize,
                  color: AppColor.blackColor,
                ),
              ),
            ),

            // Right icon container
            Container(
              height: containerHeight,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              decoration: const BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppImage.spoon,
                width: fontSize,
                height: fontSize,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
