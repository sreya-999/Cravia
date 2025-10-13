import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/utlis/widgets/responsiveness.dart';

import '../../views/buy_one_get_one.dart';
import '../../views/combo_offer_screen.dart';
import '../../views/home_screen.dart';
import '../utlis/App_color.dart';
import '../utlis/widgets/app_text_style.dart';

class ExpandableMenuButton extends StatefulWidget {
  const ExpandableMenuButton({super.key});

  @override
  State<ExpandableMenuButton> createState() => _ExpandableMenuButtonState();
}

class _ExpandableMenuButtonState extends State<ExpandableMenuButton> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsiveness(context);

    return FloatingActionButton.extended(
      onPressed: () async {
        setState(() {
          isMenuOpen = true;
        });

        // get FAB position
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
        final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

        // dynamically calculate space above FAB based on screen height
        final double screenHeight = MediaQuery.of(context).size.height;
        final double spaceAbove = screenHeight * 0.20; // 25% of screen height

        final selected = await showMenu(
          context: context,
          position: RelativeRect.fromRect(
            Rect.fromLTWH(
              position.dx,
              position.dy - spaceAbove, // responsive offset
              button.size.width,
              button.size.height,
            ),
            Offset.zero & overlay.size,
          ),
          color: AppColor.whiteColor,
          items: [
            PopupMenuItem(
              value: "BuyOneGetOne",
              child: Text(
                "BuyOneGetOne",
                style: AppTextStyles.latoBold(responsive.adOn,
                    color: AppColor.blackColor),
              ),
            ),
            PopupMenuItem(
              value: "Combo",
              child: Text(
                "Combo Offer",
                style: AppTextStyles.latoBold(responsive.adOn,
                    color: AppColor.blackColor),
              ),
            ),
            PopupMenuItem(
              value: "HomeScreen",
              child: Text(
                "HomeScreen",
                style: AppTextStyles.latoBold(responsive.adOn,
                    color: AppColor.blackColor),
              ),
            ),
          ],
        );

        setState(() {
          isMenuOpen = false;
        });

        if (selected != null) {
          switch (selected) {
            case "BuyOneGetOne":
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => BuyOneGetOne()));
              break;
            case "Combo":
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ComboOfferScreen()));
              break;
            case "HomeScreen":
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              break;
          }
        }
      },

      icon: SvgPicture.asset(
        isMenuOpen ? AppImage.cross : AppImage.spoon,
        width: responsive.adOn, // responsive width
        height: responsive.adOn, // responsive height
        color: Colors.black,
      ),
      label: Text(
        isMenuOpen ? "Close" : "Menu",
        style: AppTextStyles.latoBold(responsive.adOn, color: AppColor.blackColor),
      ),
      backgroundColor: Colors.white,
      elevation: 4,
    );
  }
}
