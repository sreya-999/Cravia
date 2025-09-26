import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ravathi_store/models/order_model.dart';

import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/App_style.dart';
import 'package:provider/provider.dart';
import 'package:ravathi_store/views/selection_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import '../providers/dashboard_provider.dart';
import '../utlis/App_image.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../utlis/widgets/responsive.dart';
import '../utlis/widgets/responsiveness.dart';

class OrderSuccessScreen extends StatefulWidget {
  final OrderModel? order; // Add order model

  const OrderSuccessScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsive = Responsiveness(context);
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    OrderModel? order;
    final r = Responsive(context);
    final isDineIn =
        Provider.of<CategoryProvider>(context, listen: false).isDineIn;
    final cartProvider = Provider.of<CartProvider>(context);
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
                gradient: LinearGradient(
                  colors: [AppColor.secondary, AppColor.primaryColor],
                  begin: AlignmentDirectional(0.0, -3.0), // top-center
                  end: AlignmentDirectional(0.0, 1.0),   // bottom-center
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
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
                  mainAxisAlignment: MainAxisAlignment.center, // 👈 Center vertically
                  crossAxisAlignment: CrossAxisAlignment.center, // 👈 Center horizontally
                  children: [
                    /// Success icon and text in the same row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppImage.success,
                          fit: BoxFit.cover,
                          height: r.hp(5),
                        ),
                        SizedBox(width: r.wp(3)),
                        Text(
                          "Order Success!",
                          style: AppStyle.textStyleReemKufi.copyWith(
                            fontSize: r.sp(5.5, max: 32),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: r.hp(5)),

                    Image.asset(
                      AppImage.receipt,
                      height: r.hp(25),
                      fit: BoxFit.cover,
                    ),

                    SizedBox(height: r.hp(3.5)),

                    Text(
                      "Your Order No: ${widget.order?.orderId}",
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: r.sp(5, max: 27),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${widget.order?.orderNo}",
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: r.sp(5, max: 27),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (cartProvider.selectedTable != null)
                      Text(
                        'Selected table: ${cartProvider.selectedTable}',
                        style: AppStyle.textStyleReemKufi.copyWith(
                          fontSize: r.sp(5, max: 27),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    SizedBox(height: r.hp(4)),

                    Text(
                      "Collect your Food on Counter",
                      textAlign: TextAlign.center,
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: r.sp(5, max: 22),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: r.hp(1)),

                    Text(
                      "Note: Please collect Your receipt",
                      textAlign: TextAlign.center,
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: r.sp(3.5, max: 16),
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),

                    SizedBox(height: r.hp(15)),

                    Consumer<CartProvider>(
                      builder: (context, cartProvider, _) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 35.0),
                          child: SizedBox(
                            height:isTablet ? 50 :45,

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
                                final provider = Provider.of<DashboardProvider>(context, listen: false);
                                provider.clearSort();
                                cartProvider.clearCart();
                                cartProvider.clearSelection();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => SelectionScreen()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                                "Go Home",
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  fontSize: r.sp(4.5, max: 22),
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
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
