import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ravathi_store/models/order_model.dart';

import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/App_style.dart';
import 'package:provider/provider.dart';
import 'package:ravathi_store/views/selection_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import '../utlis/App_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utlis/widgets/resonsive.dart';

class OrderSuccessScreen extends StatefulWidget {
  final OrderModel? order; // Add order model

  const OrderSuccessScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    OrderModel? order;
    final r = Responsive(context);
    final isDineIn =
        Provider.of<CategoryProvider>(context, listen: false).isDineIn;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SelectionScreen()),
                (route) => false, // remove all previous routes
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background Gradient + Bottom Image
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColor.secondary, AppColor.primaryColor],
                  begin: AlignmentDirectional(0.0, -2.0), // top-center
                  end: AlignmentDirectional(0.0, 1.0), // bottom-center

                  stops: [0.0, 1.0], // smooth gradient
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  AppImage.burger,
                  fit: BoxFit.contain,
                  height: r.hp(25),
                ),
              ),
            ),

            // Foreground Content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: r.wp(6),
                  vertical: r.hp(2),
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center vertically
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImage.success,
                      fit: BoxFit.cover,
                      height: r.hp(10),
                    ),
                    SizedBox(height: r.hp(1.5)),

                    Text(
                      "Order Success !",
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: r.sp(5.5, max: 24),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: r.hp(5)),

                    Image.asset(
                      AppImage.receipt,
                      height: r.hp(15),
                      fit: BoxFit.cover,
                    ),

                    SizedBox(height: r.hp(3.5)),

                    Text(
                      "Your Order No: ${widget.order?.orderId}",
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: r.sp(5, max: 22),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${widget.order?.orderNo}",
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: r.sp(5, max: 22),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // if (isDineIn)
                    //   Consumer<CartProvider>(
                    //     builder: (context, cartProvider, _) {
                    //       final selectedTableName = cartProvider.selectedTable ?? 'No Table Selected';
                    //       return Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Text(
                    //           "Selected Table: - $selectedTableName",
                    //           style: AppStyle.textStyleReemKufi.copyWith(
                    //             fontSize: r.sp(5, max: 22),
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),

                    SizedBox(height: r.hp(4)),

                    Text(
                      "Collect your Food on Counter",
                      textAlign: TextAlign.center,
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: r.sp(5, max: 20),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: r.hp(1)),

                    Text(
                      "Note: Please collect your receipt",
                      textAlign: TextAlign.center,
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: r.sp(3.5, max: 16),
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),

                    SizedBox(height: r.hp(5)),

                    Consumer<CartProvider>(
                      builder: (context, cartProvider, _) {
                        return SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, r.hp(4)),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              cartProvider.clearCart();
                              cartProvider.clearSelection();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SelectionScreen()),
                                (Route<dynamic> route) =>
                                    false, // removes all previous routes
                              );
                            },
                            child: Text(
                              "Back to home",
                              style: AppStyle.textStyleReemKufi.copyWith(
                                fontSize: r.sp(4.5, max: 18),
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
