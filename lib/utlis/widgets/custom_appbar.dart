import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ravathi_store/utlis/widgets/responsiveness.dart';

import '../App_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsiveness(context);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: AppStyle.textStyleLobster.copyWith(
          color: Colors
              .black,
          fontSize:responsive.heading,

          fontWeight: FontWeight.w700,
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        child: Material(
          elevation: 4, // shadow
          shape: const CircleBorder(),
          color: Colors.white,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack ?? () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                CupertinoIcons.arrow_left,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
