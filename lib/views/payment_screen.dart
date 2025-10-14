import 'package:flutter/material.dart';
import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/utlis/widgets/custom_appbar.dart';
import 'package:ravathi_store/utlis/widgets/responsiveness.dart';
import 'package:ravathi_store/views/payment.dart';
import 'package:ravathi_store/views/payment_success_screen.dart';
import 'package:ravathi_store/views/table_selection_screen.dart';

import '../models/order_model.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import '../utlis/App_style.dart';
import 'order_success_screen.dart';
import 'package:provider/provider.dart';


class PaymentScreen extends StatefulWidget {
  OrderModel? order;
  PaymentScreen({Key? key, this.order}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds, then navigate
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => PaymentSuccessScreen(order: widget.order,)),
              );
      // if (mounted) {
      //   final isDineIn = Provider.of<CategoryProvider>(context, listen: false).isDineIn;
      //
      //   if (isDineIn) {
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (_) => TableSelectionScreen(order: widget.order)),
      //     );
      //     context.read<CartProvider>().clearCart();
      //     // Navigator.pushReplacement(
      //     //   context,
      //     //   MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: widget.order,)),
      //     // );
      //   } else {
      //     Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: widget.order,)),
      //     );
      //   }
      // }
    });

  }
  Widget build(BuildContext context) {

final responsive = Responsiveness(context);
    return WillPopScope(
      onWillPop: () async {
        // return false to prevent back navigation
        // return true to allow it
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Payment'),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Builder(
                      builder: (context) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        final isMobile = screenWidth < 600;

                        // Dynamic sizes
                        final qrSize = screenWidth * 0.4; // 60% of width
                        final titleFontSize = isMobile ? 16.0 : 22.0;
                        final totalLabelFontSize = isMobile ? 14.0 : 18.0;
                        final totalAmountFontSize = isMobile ? 18.0 : 24.0;

                        return Column(
                          children: [
                            SizedBox(height: isMobile ? 20 : 40),

                            // Title
                            Text(
                              "Scan QR to pay",
                              style: AppStyle.textStyleReemKufi.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSize,
                              ),
                            ),

                            SizedBox(height: isMobile ? 20 : 30),

                            // QR Code
                            Image.asset(
                              AppImage.qrCode,
                              width: qrSize,
                              height: qrSize,
                              fit: BoxFit.contain,
                            ),

                            SizedBox(height: isMobile ? 16 : 24),

                            // Payment method logos
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImage.payment,
                                  width: screenWidth * 0.5, // 50% of screen width
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),

                            SizedBox(height: isMobile ? 20 : 30),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Fixed total section
              Builder(
                builder: (context) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final isMobile = screenWidth < 600;
                  final cartProvider = Provider.of<CartProvider>(context);
                  return Container(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          "Total",
                          style: AppStyle.textStyleReemKufi.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.subtitleSize
                          ),
                        ),
                        SizedBox(height: isMobile ? 5 : 8),
                        Text(
                          "Rs ${cartProvider.total.toStringAsFixed(2)}",
                          style: AppStyle.textStyleReemKufi.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.subtitleSize
                          ),
                        ),

                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

  }
}
