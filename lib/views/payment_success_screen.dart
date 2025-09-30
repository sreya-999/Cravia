import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/widgets/responsiveness.dart';
import 'package:ravathi_store/views/table_selection_screen.dart';
// import your OrderModel
import '../models/order_model.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import 'package:provider/provider.dart';

import '../utlis/App_style.dart';
import '../utlis/widgets/app_text_style.dart';
import 'order_success_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final OrderModel? order;

  const PaymentSuccessScreen({super.key, this.order});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds, then navigate
    Future.delayed(const Duration(seconds: 3), () {

      if (mounted) {
        final isDineIn = Provider.of<CategoryProvider>(context, listen: false).isDineIn;

        if (isDineIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => TableSelectionScreen(order: widget.order)),
          );
          context.read<CartProvider>().clearCart();
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: widget.order,)),
          // );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: widget.order,)),
          );
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final double buttonSize = isTablet ? 20 : 18;
    final responsive = Responsiveness(context);
    return Scaffold(
      backgroundColor: AppColor.whiteColor, // Light pink background
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Success Icon with Green Circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Green particles effect

                    Container(
                      height: MediaQuery.of(context).size.height * 0.20, // 15% of screen height
                      width: MediaQuery.of(context).size.width * 0.50, // Optional: width scaling
                      child: Lottie.asset(
                        'assets/icons/success.json',
                        repeat: false,
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 40),

                // ✅ "Thank you!" text
                 Text(
                  "Thank you!",
                  style: AppTextStyles.nunitoBold(
                    responsive.success,
                    color: AppColor.blackColor,
                  ),
                ),

                const SizedBox(height: 8),

                // ✅ Subtitle text
                 Text(
                  "Your payment has been completed successfully",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.nunitoRegular(
                    responsive.hintTextSize,
                    color: AppColor.lightBlackColor,
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

