import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ravathi_store/utlis/App_color.dart';

import '../utlis/App_style.dart';
import '../utlis/widgets/custom_appbar.dart';

class BucketPage extends StatefulWidget {
  const BucketPage({super.key});

  @override
  State<BucketPage> createState() => _BucketPageState();
}

class _BucketPageState extends State<BucketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: const CustomAppBar(
          title: '',
        ),
        body: Center(
          child: Text(
            "No products found",
            style: AppStyle.textStyleReemKufi.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColor.greyColor,
              fontSize: 18,
            ),
          ),
        ));
  }
}
