import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ravathi_store/service/sync_manager.dart';
import 'package:ravathi_store/urls/api_endpoints.dart';
import 'package:ravathi_store/utlis/widgets/custom_appbar.dart';
import 'package:ravathi_store/views/payment_screen.dart';
import 'dart:math';
import '../models/add_on.dart';
import '../models/items_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import '../utlis/App_color.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../utlis/App_image.dart';
import '../utlis/App_style.dart';
import '../utlis/share_preference_helper/sharereference_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utlis/widgets/app_text_style.dart';
import 'combo_offer_screen.dart';
import 'home_screen.dart';

class ViewOrderScreen extends StatelessWidget {
  const ViewOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderedItems = cartProvider.items;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double buttonPaddingH = isDesktop
        ? 36
        : isTablet
            ? 32
            : 28;
    final double buttonPaddingV = isDesktop
        ? 18
        : isTablet
            ? 16
            : 14;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: const CustomAppBar(
        title: 'Your Cart',
      ),
      // bottomNavigationBar: Consumer<CartProvider>(
      //   builder: (context, cartProvider, _) {
      //     final prefHelper = getIt<SharedPreferenceHelper>();
      //     final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
      //     int estimatedTimeInMinutes =
      //         cartProvider.averageEstimatedTime.round();
      //     String formattedTime = formatTime(estimatedTimeInMinutes);
      //     final estimatedTime = cartProvider
      //         .formatTime(cartProvider.averageEstimatedTime.round());
      //     // int estimatedTimeInMinutes = cartProvider.totalEstimatedTime;
      //     // String formattedTime = formatTime(estimatedTimeInMinutes);
      //     // final estimatedTime =
      //     // cartProvider.formatTime(cartProvider.totalEstimatedTime);
      //     double packingCharge = cartProvider.totalPackingCharge;
      //     print("Packing Charge: $packingCharge");
      //     if (cartProvider.items.isEmpty) {
      //       return const SizedBox.shrink(); // empty widget
      //     }
      //     double total;
      //
      //     if (isTakeAway) {
      //       total = cartProvider.subTotal;
      //     } else {
      //       total = cartProvider.subTotal - packingCharge;
      //       ;
      //     }
      //
      //     double subTotal;
      //     if (isTakeAway) {
      //       // When isTakeAway is TRUE → subtract the packing charge
      //       subTotal = cartProvider.subTotal - packingCharge;
      //     } else {
      //       // When isTakeAway is FALSE → keep the subtotal as it is
      //       subTotal = cartProvider.subTotal;
      //     }
      //     final double buttonFontSize = isDesktop
      //         ? 22
      //         : isTablet
      //             ? 17
      //             : 16;
      //     return Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //       decoration: const BoxDecoration(
      //         gradient: const LinearGradient(
      //           colors: [AppColor.secondary, AppColor.primaryColor],
      //           begin: AlignmentDirectional(0.0, -3.0), // top-center
      //           end: AlignmentDirectional(0.0, 1.0), // bottom-center
      //
      //           stops: [0.0, 1.0], // smooth gradient
      //           tileMode: TileMode.clamp,
      //         ),
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(20),
      //           topRight: Radius.circular(20),
      //         ),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.black12,
      //             blurRadius: 6,
      //             offset: Offset(0, -2),
      //           ),
      //         ],
      //       ),
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           // Price details
      //           Padding(
      //             padding:
      //                 const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      //             child: Column(
      //               children: [
      //                 _priceRow("Sub-Total", "₹${subTotal.toStringAsFixed(2)}"),
      //                 Visibility(
      //                     visible: isTakeAway,
      //                     child: _priceRow("Packing Charge",
      //                         "₹${packingCharge.toStringAsFixed(2)}")), // Show packing charge
      //                 // _priceRow("Packing Charge",
      //                 //     "₹${packingCharge.toStringAsFixed(2)}"),
      //                 const Divider(color: Colors.white54),
      //                 _priceRow(
      //                   "Total",
      //                   "₹${total.toStringAsFixed(2)}",
      //                   isBold: true,
      //                 ),
      //                 const SizedBox(height: 4),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Text(
      //                       "Order ready time",
      //                       style: AppStyle.textStyleReemKufi.copyWith(
      //                         color: Colors.white60,
      //                         fontWeight: FontWeight.w100,
      //                         fontSize: 12,
      //                       ),
      //                     ),
      //                     Text(
      //                       estimatedTime,
      //                       style: AppStyle.textStyleReemKufi.copyWith(
      //                         color: Colors.white60,
      //                         fontWeight: FontWeight.w100,
      //                         fontSize: 12,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //           const SizedBox(height: 8),
      //           // Place Order button
      //           SizedBox(
      //             // height: 60,
      //             child: ElevatedButton(
      //               onPressed: () {
      //                 showLoginSheet(context);
      //               },
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: Colors.white,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(12),
      //                 ),
      //                 padding: EdgeInsets.symmetric(
      //                   horizontal: buttonPaddingH,
      //                   vertical: buttonPaddingV,
      //                 ),
      //               ),
      //               child: Text(
      //                 'Place Order',
      //                 style: AppStyle.textStyleReemKufi.copyWith(
      //                   fontWeight: FontWeight.w600,
      //                   color: AppColor.primaryColor,
      //                   fontSize: buttonFontSize,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
            final prefHelper = getIt<SharedPreferenceHelper>();
            final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
            int estimatedTimeInMinutes =
                cartProvider.averageEstimatedTime.round();
            String formattedTime = formatTime(estimatedTimeInMinutes);
            final estimatedTime = cartProvider
                .formatTime(cartProvider.averageEstimatedTime.round());
            double packingCharge = cartProvider.totalPackingCharge;
            if (cartProvider.items.isEmpty) {
              return const SizedBox.shrink(); // empty widget
            }

            double total = isTakeAway
                ? cartProvider.subTotal
                : cartProvider.subTotal;

            double subTotal = isTakeAway
                ? cartProvider.subTotal - packingCharge
                : cartProvider.subTotal;

            final double buttonFontSize = isDesktop
                ? 22
                : isTablet
                    ? 17
                    : 17;

            return SafeArea(
              // ✅ this prevents hiding under nav bar
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                decoration: const BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.secondary, AppColor.primaryColor],
                    begin: AlignmentDirectional(0.0, -3.0), // top-center
                    end: AlignmentDirectional(0.0, 1.0), // bottom-center

                    stops: [0.0, 1.0], // smooth gradient
                    tileMode: TileMode.clamp,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight:  Radius.circular(20),
                    bottomLeft:  Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Price details
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Column(
                        children: [
                          _priceRow(
                              "Sub-Total", "₹${subTotal.toStringAsFixed(2)}"),
                          if (isTakeAway)
                            _priceRow("Packing Charge",
                                "₹${packingCharge.toStringAsFixed(2)}"),
                          const Divider(color: Colors.white54),
                          _priceRow(
                            "Tax",
                            "${15}%",
                            isBold: false,
                          ),
                          _priceRow(
                            "Total",
                            "₹${total.toStringAsFixed(2)}",
                            isBold: true,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(

                                isTakeAway? "Order ready time..":" Ready to serve in...",
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                estimatedTime,
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Place Order button
                    SizedBox(
                      width: double.infinity, // ✅ force full width
                      child: ElevatedButton(
                        onPressed: () {
                          showLoginSheet(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: buttonPaddingH,
                            vertical: buttonPaddingV,
                          ),
                        ),
                        child: Text(
                          'Place Order',
                          style: AppStyle.textStyleReemKufi.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryColor,
                            fontSize: buttonFontSize,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      body: orderedItems.isEmpty
          ? Center(
              child: Text(
              'No items were ordered',
              style: AppStyle.textStyleReemKufi.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.greyColor,
                fontSize: 18,
                height: 1.0, // remove extra line height
              ),
            ))
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "${orderedItems.length} ${orderedItems.length == 1 ? 'Item' : 'Items'} in cart",
                  style: AppStyle.textStyleReemKufi.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: orderedItems.length + 1,
                  itemBuilder: (context, index) {
                    final prefHelper = getIt<SharedPreferenceHelper>();
                    final isTakeAway =
                        prefHelper.getBool(StorageKey.isTakeAway) ?? false;

                    final screenWidth = MediaQuery.of(context).size.width;
                    final screenHeight = MediaQuery.of(context).size.height;

                    final double imageSize = screenWidth * 0.18;
                    final containerPadding = screenWidth * 0.03;
                    if (index == orderedItems.length) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.add,
                                color: AppColor.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Add more items",
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final item = orderedItems[index];
                    // final quantity = cartProvider.getQuantity(item.id);
                    final quantity = item.quantity;
                    print("Images in cart item: ${item.images}");

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 1000),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: containerPadding, vertical: 5),
                                padding: EdgeInsets.all(containerPadding),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.35),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    bool isMobile = constraints.maxWidth < 400;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (item.isCombo != null)
                                          const SizedBox(height: 10),

                                        /// ========== COMBO ITEM ==========
                                        if (item.isCombo == true) ...[
                                          /// Combo Images Row
                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              final imageSize =
                                                  (constraints.maxWidth * 0.20)
                                                      .clamp(40, 100)
                                                      .toDouble();

                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start, // 👈 top alignment
                                                children: [
                                                  for (int i = 0;
                                                      i < item.images.length;
                                                      i++) ...[
                                                    // image
                                                    Container(
                                                      width: imageSize,
                                                      height: imageSize,
                                                      child: Image.network(
                                                        "${ApiEndpoints.imageBaseUrl}${item.images[i]}",
                                                        fit: BoxFit.fill,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Icon(
                                                            Icons.broken_image,
                                                            size: 40,
                                                            color: Colors.grey,
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                    // add icon centered to image height
                                                    if (i <
                                                        item.images.length - 1)
                                                      SizedBox(
                                                        height:
                                                            imageSize, // match image height
                                                        child: const Center(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child: Icon(
                                                              Icons.add,
                                                              size: 28,
                                                              color: AppColor
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],

                                                  const Spacer(),

                                                  // clear button aligned at top
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: IconButton(
                                                      icon: SvgPicture.asset(
                                                        AppImage
                                                            .cross, // <-- your SVG asset path
                                                        width: 20,
                                                        height: 20,
                                                        color: AppColor
                                                            .primaryColor, // optional: apply color tint
                                                      ),
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(
                                                        minWidth: 20,
                                                        minHeight: 20,
                                                      ),
                                                      onPressed: () async {
                                                        final confirm =
                                                            await showDialog<
                                                                bool>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                "Confirm Delete",
                                                                style: AppStyle
                                                                    .textStyleReemKufi
                                                                    .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: AppColor
                                                                      .primaryColor,
                                                                  fontSize: 18,
                                                                  height: 1.0,
                                                                ),
                                                              ),
                                                              content: Text(
                                                                "Are you sure you want to delete this item?",
                                                                style: AppStyle
                                                                    .textStyleReemKufi
                                                                    .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: AppColor
                                                                      .blackColor,
                                                                  fontSize: 18,
                                                                  height: 1.0,
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              false),
                                                                  child: Text(
                                                                    "Cancel",
                                                                    style: AppStyle
                                                                        .textStyleReemKufi
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: AppColor
                                                                          .blackColor,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          1.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              true),
                                                                  child: Text(
                                                                    "Delete",
                                                                    style: AppStyle
                                                                        .textStyleReemKufi
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: AppColor
                                                                          .primaryColor,
                                                                      fontSize:
                                                                          14,
                                                                      height:
                                                                          1.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );

                                                        if (confirm == true) {
                                                          cartProvider
                                                              .removeItem(
                                                            item.id,
                                                            childCategoryId: item
                                                                .childCategoryId,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),

                                          const SizedBox(height: 5),

                                          /// Product details below combo images
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              /// Product name and delete button
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      (item.name != null &&
                                                              item.name!
                                                                  .isNotEmpty)
                                                          ? item.name![0]
                                                                  .toUpperCase() +
                                                              item.name!
                                                                  .substring(1)
                                                                  .toLowerCase()
                                                          : '',
                                                      //item.name,
                                                      style: AppStyle
                                                          .textStyleReemKufi
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color:
                                                            AppColor.blackColor,
                                                        fontSize: 20,
                                                        height: 1.0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          (item.categoryName
                                                                  ?.length ??
                                                              0);
                                                      i++) ...[
                                                    Text(
                                                      item.categoryName![i],
                                                      style: AppStyle
                                                          .textStyleReemKufi
                                                          .copyWith(
                                                        // fontWeight: FontWeight.w500,
                                                        color:
                                                            AppColor.blackColor,
                                                        fontSize: 15,
                                                        height: 1.0,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    if (i <
                                                        item.categoryName!
                                                                .length -
                                                            1) // only add "+" between, not after last
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 18,
                                                          color: AppColor
                                                              .blackColor,
                                                        ),
                                                      ),
                                                  ]
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),

                                              /// Price
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '₹${(item.price * quantity).toStringAsFixed(2)}',
                                                    style: AppStyle
                                                        .textStyleReemKufi
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColor.blackColor,
                                                      fontSize: 18,
                                                      height: 1.0,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            cartProvider
                                                                .decrement(
                                                                    item.id),
                                                        child: _buildQtyButton(
                                                            context,
                                                            Icons.remove),
                                                      ),
                                                      SizedBox(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.030),
                                                      Text(
                                                        '$quantity',
                                                        style: AppStyle
                                                            .textStyleReemKufi
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15,
                                                          height: 1.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.030),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            cartProvider
                                                                .increment(
                                                                    item.id),
                                                        child: _buildQtyButton(
                                                            context, Icons.add),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 14),

                                              /// Quantity controls
                                            ],
                                          ),
                                        ],

                                        /// ========== NON-COMBO ITEM ==========
                                        if (item.isCombo != true) ...[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              /// Single Product Image
                                              GestureDetector(
                                                onTap: () {
                                                  // showBurgerDialog(
                                                  //     context, item);
                                                },
                                                child: Container(
                                                  width: (constraints.maxWidth *
                                                          0.25)
                                                      .clamp(60, 80),
                                                  height:
                                                      (constraints.maxWidth *
                                                              0.25)
                                                          .clamp(60, 80),
                                                  child: Image.network(
                                                    "${ApiEndpoints.imageBaseUrl}${item.images.isNotEmpty ? item.images.first : ''}",
                                                    fit: BoxFit.fill,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Icon(
                                                        Icons.broken_image,
                                                        size: 50,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 12),

                                              /// Product Details
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    /// Product name and delete button
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        /// Product Name
                                                        Expanded(
                                                          child: Text(
                                                            item.name,
                                                            style: AppStyle
                                                                .textStyleReemKufi
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: AppColor
                                                                  .blackColor,
                                                              fontSize: 20,
                                                              height: 1.0,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),

                                                        /// Delete Icon
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: IconButton(
                                                            icon: SvgPicture
                                                                .asset(
                                                              AppImage
                                                                  .cross, // <-- your SVG asset path
                                                              width: 20,
                                                              height: 20,
                                                              color: AppColor
                                                                  .primaryColor,
                                                            ),
                                                            padding: EdgeInsets
                                                                .zero, // Prevent extra padding
                                                            constraints:
                                                                const BoxConstraints(
                                                              minWidth: 30,
                                                              minHeight: 30,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              final confirm =
                                                                  await showDialog<
                                                                      bool>(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      "Confirm Delete",
                                                                      style: AppStyle
                                                                          .textStyleReemKufi
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: AppColor
                                                                            .primaryColor,
                                                                        fontSize:
                                                                            18,
                                                                        height:
                                                                            1.0,
                                                                      ),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      "Are you sure you want to delete this item?",
                                                                      style: AppStyle
                                                                          .textStyleReemKufi
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        color: AppColor
                                                                            .blackColor,
                                                                        fontSize:
                                                                            18,
                                                                        height:
                                                                            1.0,
                                                                      ),
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(false),
                                                                        child:
                                                                            Text(
                                                                          "Cancel",
                                                                          style: AppStyle
                                                                              .textStyleReemKufi
                                                                              .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color:
                                                                                AppColor.blackColor,
                                                                            fontSize:
                                                                                14,
                                                                            height:
                                                                                1.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(true),
                                                                        child:
                                                                            Text(
                                                                          "Delete",
                                                                          style: AppStyle
                                                                              .textStyleReemKufi
                                                                              .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color:
                                                                                AppColor.primaryColor,
                                                                            fontSize:
                                                                                14,
                                                                            height:
                                                                                1.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );

                                                              if (confirm ==
                                                                  true) {
                                                                cartProvider
                                                                    .removeItem(
                                                                  item.id,
                                                                  childCategoryId:
                                                                      item.childCategoryId,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    /* if ((item.description != null && item.description!.isNotEmpty) ||*/
                                                    if (item.childCategoryName !=
                                                            null &&
                                                        item.childCategoryName!
                                                            .isNotEmpty)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (item.childCategoryName !=
                                                                  null &&
                                                              item.childCategoryName!
                                                                  .isNotEmpty) // spacing only when both exist

                                                            // type value
                                                            if (item.childCategoryName !=
                                                                    null &&
                                                                item.childCategoryName!
                                                                    .isNotEmpty)
                                                              Flexible(
                                                                child: Text(
                                                                  item.childCategoryName!,
                                                                  style: AppStyle
                                                                      .textStyleReemKufi
                                                                      .copyWith(
                                                                    //fontWeight: FontWeight.w700,
                                                                    color: AppColor
                                                                        .blackColor,
                                                                    fontSize:
                                                                        14,
                                                                    height: 1.0,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                        ],
                                                      ),
                                                    // if (item.childCategoryName !=
                                                    //         null &&
                                                    //     item.childCategoryName!
                                                    //         .isNotEmpty)
                                                    const SizedBox(
                                                      height: 5,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '₹${(isTakeAway ? (item.price * quantity) // If TakeAway is true
                                                              : (item.childCategoryId == null ? (item.price * quantity) // If TakeAway is false AND childCategory is null
                                                                  : ((item.price * quantity) - (item.takeAwayPrice ?? 0.0)) // If TakeAway is false AND childCategory is not null
                                                              )).toStringAsFixed(2)}',
                                                          style: AppStyle
                                                              .textStyleReemKufi
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppColor
                                                                .blackColor,
                                                            fontSize: 18,
                                                            height: 1.0,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  cartProvider
                                                                      .decrement(
                                                                          item.id),
                                                              child: _buildQtyButton(
                                                                  context,
                                                                  Icons.remove),
                                                            ),
                                                            SizedBox(
                                                                width: constraints
                                                                        .maxWidth *
                                                                    0.030),
                                                            Text(
                                                              '$quantity',
                                                              style: AppStyle
                                                                  .textStyleReemKufi
                                                                  .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 15,
                                                                height: 1.0,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: constraints
                                                                        .maxWidth *
                                                                    0.030),
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  cartProvider
                                                                      .increment(
                                                                          item.id),
                                                              child:
                                                                  _buildQtyButton(
                                                                      context,
                                                                      Icons
                                                                          .add),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],

                                        const SizedBox(height: 10),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              /// Badges
                              if (item.isCombo == false)
                                Positioned(
                                  top: 0,
                                  left: 20,
                                  child: Image.asset(
                                    AppImage.badge,
                                    width: 40,
                                  ),
                                ),
                              if (item.isCombo == true)
                                Positioned(
                                  top: 5,
                                  left: 20,
                                  child: Image.asset(
                                    AppImage.badge1,
                                    width: 30,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// in extra add 1 position i want to show the add to more items
            ]),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Consumer<CartProvider>(
      //   builder: (context, cartProvider, _) {
      //     final prefHelper = getIt<SharedPreferenceHelper>();
      //     final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
      //
      //     if (cartProvider.items.isEmpty) return const SizedBox.shrink();
      //
      //     int estimatedTimeInMinutes =
      //         cartProvider.averageEstimatedTime.round();
      //     String estimatedTime = formatTime(estimatedTimeInMinutes);
      //     double packingCharge = cartProvider.totalPackingCharge;
      //
      //     double total = cartProvider.subTotal;
      //     double subTotal = isTakeAway
      //         ? cartProvider.subTotal - packingCharge
      //         : cartProvider.subTotal;
      //
      //     final double buttonFontSize = isDesktop
      //         ? 22
      //         : isTablet
      //             ? 17
      //             : 17;
      //
      //     return SafeArea(
      //       child: Container(
      //         margin: const EdgeInsets.symmetric(horizontal: 16),
      //         padding: const EdgeInsets.all(16),
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             colors: [AppColor.secondary, AppColor.primaryColor],
      //             begin: AlignmentDirectional(0.0, -2.0),
      //             end: AlignmentDirectional(0.0, 1.0),
      //             stops: [0.0, 1.0],
      //             tileMode: TileMode.clamp,
      //           ),
      //           borderRadius: BorderRadius.circular(20),
      //           boxShadow: const [
      //             BoxShadow(
      //               color: Colors.black12,
      //               blurRadius: 6,
      //               offset: Offset(0, 2),
      //             ),
      //           ],
      //         ),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           children: [
      //             // Price details
      //             _priceRow("Sub-Total", "₹${subTotal.toStringAsFixed(2)}"),
      //             if (isTakeAway)
      //               _priceRow("Packing Charge",
      //                   "₹${packingCharge.toStringAsFixed(2)}"),
      //             const Divider(color: Colors.white54),
      //             _priceRow("Tax", "15%", isBold: false),
      //             _priceRow("Total", "₹${total.toStringAsFixed(2)}",
      //                 isBold: true),
      //             const SizedBox(height: 4),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Text(
      //                   isTakeAway
      //                       ? "Order ready time.."
      //                       : "Ready to serve in...",
      //                   style: AppStyle.textStyleReemKufi.copyWith(
      //                     color: Colors.white60,
      //                     fontWeight: FontWeight.w100,
      //                     fontSize: 12,
      //                   ),
      //                 ),
      //                 Text(
      //                   estimatedTime,
      //                   style: AppStyle.textStyleReemKufi.copyWith(
      //                     color: Colors.white60,
      //                     fontWeight: FontWeight.w100,
      //                     fontSize: 12,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             const SizedBox(height: 8),
      //             // Place Order button
      //             ElevatedButton(
      //               onPressed: () {
      //                 showLoginSheet(context);
      //               },
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: Colors.white,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(12),
      //                 ),
      //                 padding:
      //                     EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      //               ),
      //               child: Text(
      //                 'Place Order',
      //                 style: AppStyle.textStyleReemKufi.copyWith(
      //                   fontWeight: FontWeight.w600,
      //                   color: AppColor.primaryColor,
      //                   fontSize: buttonFontSize,
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }

  String formatTime(int totalMinutes) {
    int hours = totalMinutes ~/ 60; // Get hours
    int minutes = totalMinutes % 60; // Get remaining minutes

    if (hours > 0) {
      return "$hours hr ${minutes.toString().padLeft(2, '0')} mins";
    } else {
      return "$minutes mins";
    }
  }

  Widget _buildQtyButton(BuildContext context, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [AppColor.secondary, AppColor.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon, size: 18, color: AppColor.whiteColor),
    );
  }
//   Widget _buildQtyButton(BuildContext context, IconData icon) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     // Conditional radius
//     final borderRadius = screenWidth > 400 ? 18.0 : 10.0;
//
// // Limit max padding so it doesn't blow up on big screens
//     final horizontalPadding = min(screenWidth * 0.02, 16.0);
//     final verticalPadding   = min(screenWidth * 0.010, 10.0);
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: horizontalPadding,
//         vertical: verticalPadding,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(borderRadius),
//         gradient: const LinearGradient(
//           colors: [AppColor.secondary, AppColor.primaryColor],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           stops: [0, 0.60],
//         ),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Icon(
//         icon,
//         size: screenWidth * 0.05,
//         color: AppColor.whiteColor,
//       ),
//     );
//   }

  Widget _buildQtyButtons(String svgAsset) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColor.secondary, AppColor.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 0.60],
        ),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SvgPicture.asset(
        svgAsset,
        width: 20, // set size
        height: 20,
        color: Colors.white, // optional tint
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyle.textStyleReemKufi.copyWith(
              color: Colors.white,
              fontSize: isBold ? 20 : 17,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: AppStyle.textStyleReemKufi.copyWith(
              color: Colors.white,
              fontSize: isBold ? 20 : 17,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void showLoginSheet(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController name = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final ValueNotifier<bool> isLoading = ValueNotifier(false);
    final screenWidth = MediaQuery.of(context).size.width;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      pageBuilder: (_, __, ___) {
        final screenHeight = MediaQuery.of(context).size.height;
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // ✅ Removed fixed height
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.secondary, AppColor.primaryColor],
                      begin: AlignmentDirectional(0.0, -2.0),
                      end: AlignmentDirectional(0.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // ✅ Adjust height dynamically
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: SvgPicture.asset(
                                AppImage.cross,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Login",
                          style: AppTextStyles.nunitoMedium(20, color:  AppColor.whiteColor),
                          // style: AppStyle.textStyleReemKufi.copyWith(
                          //   fontWeight: FontWeight.w400,
                          //   color: AppColor.whiteColor,
                          //   fontSize: 20,
                          // ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white54),

                        /// Name Label
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Name (Optional)',
                              style: AppTextStyles.nunitoMedium(15, color:  AppColor.whiteColor),

                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        /// Name TextField
                        TextFormField(
                          controller: name,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Enter your name",
                            hintStyle: AppStyle.textStyleReemKufi.copyWith(
                              fontWeight: FontWeight.w200,
                              color: AppColor.lightGreyColor,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorStyle: const TextStyle(
                              fontSize: 12,
                              height: 1.2,
                              color: Colors.grey,
                            ),
                            helperText: " ",
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                              borderSide: BorderSide(
                                color: Colors.grey
                                    .shade50, // Border color when not focused
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                              borderSide: const BorderSide(
                                color: AppColor
                                    .primaryColor, // Border color when focused
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red, // Border color on error
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors
                                    .red, // Border color on error while focused
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),

                        /// Mobile Label
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Mobile Number',
                              style: AppTextStyles.nunitoMedium(15, color:  AppColor.whiteColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        /// Country code + mobile input
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Text(
                                "+91",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  hintText: "Enter your mobile number",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintStyle:
                                      AppStyle.textStyleReemKufi.copyWith(
                                    fontWeight: FontWeight.w200,
                                    color: AppColor.lightGreyColor,
                                    fontSize: 14,
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 12,
                                    height: 1.2,
                                    color: Colors.grey,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                    borderSide: BorderSide(
                                      color: Colors.grey
                                          .shade50, // Border color when not focused
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                    borderSide: const BorderSide(
                                      color: AppColor
                                          .primaryColor, // Border color when focused
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color:
                                          Colors.red, // Border color on error
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .red, // Border color on error while focused
                                      width: 2,
                                    ),
                                  ),
                                  helperText: " ",
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 12,
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your mobile number";
                                  } else if (value.length != 10) {
                                    return "Enter a valid 10-digit number";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        /// Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: isLoading,
                            builder: (_, loading, __) {
                              return ElevatedButton(
                                onPressed: loading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          isLoading.value = true;
                                          final otp = await SyncManager.login(
                                            context,
                                            phoneController.text,
                                          );
                                          isLoading.value = false;

                                          if (otp != null) {
                                            Navigator.pop(context);
                                            Future.delayed(
                                              const Duration(milliseconds: 100),
                                              () {
                                                showOtpDialog(
                                                  context,
                                                  otp.toString(),
                                                  phoneController.text,
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColor.primaryColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: loading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColor.primaryColor,
                                        ),
                                      )
                                    : Text(
                                        'Get OTP',
                                        style:
                                            AppStyle.textStyleReemKufi.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showOtpDialog(BuildContext context, String? otp, String phoneNumber) {
    final screenWidth = MediaQuery.of(context).size.width;
    List<TextEditingController> controllers =
        List.generate(4, (_) => TextEditingController());
    final ValueNotifier<bool> isLoading = ValueNotifier(false);

    List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
    final ValueNotifier<String?> errorNotifier =
        ValueNotifier(null); // ✅ error state

    if (otp != null) {
      for (int i = 0; i < controllers.length && i < otp.length; i++) {
        controllers[i].text = otp[i];
      }
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      pageBuilder: (_, __, ___) {
        final screenHeight = MediaQuery.of(context).size.height;
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.5,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.secondary, AppColor.primaryColor],
                    begin: AlignmentDirectional(0.0, -2.0), // top-center
                    end: AlignmentDirectional(0.0, 1.0), // bottom-center

                    stops: [0.0, 1.0], // smooth gradient
                    tileMode: TileMode.clamp,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            AppImage.cross,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "OTP Verification",
                      style: AppTextStyles.nunitoMedium(20, color:  AppColor.whiteColor),

                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white54),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Enter the verification code that we sent to your mobile number',
                            style: AppTextStyles.nunitoMedium(15, color:  AppColor.whiteColor),

                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // OTP fields
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double fieldWidth = (constraints.maxWidth - 40) / 4;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return SizedBox(
                              width: fieldWidth,
                              child: ValueListenableBuilder<String?>(
                                valueListenable: errorNotifier,
                                builder: (_, error, __) {
                                  return TextField(
                                    controller: controllers[index],
                                    focusNode: focusNodes[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      filled: true,
                                      fillColor: Colors.white,

                                      // ✅ Add border radius and custom colors
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            12), // Rounded corners
                                        borderSide: BorderSide(
                                          color: Colors.grey
                                              .shade50, // Border color when not focused
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            12), // Rounded corners
                                        borderSide: const BorderSide(
                                          color: AppColor
                                              .primaryColor, // Border color when focused
                                          width: 1,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors
                                              .red, // Border color on error
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors
                                              .red, // Border color on error while focused
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        if (index < focusNodes.length - 1) {
                                          FocusScope.of(context).requestFocus(
                                              focusNodes[index + 1]);
                                        } else {
                                          FocusScope.of(context).unfocus();
                                        }
                                      } else if (value.isEmpty && index > 0) {
                                        FocusScope.of(context).requestFocus(
                                            focusNodes[index - 1]);
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                          }),
                        );
                      },
                    ),

                    // ✅ Error message
                    ValueListenableBuilder<String?>(
                      valueListenable: errorNotifier,
                      builder: (_, error, __) {
                        if (error == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            error,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isLoading,
                        builder: (_, loading, __) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: ElevatedButton(
                              onPressed: loading
                                  ? null // disable when loading
                                  : () async {
                                      final enteredOtp =
                                          controllers.map((c) => c.text).join();

                                      if (enteredOtp.length != 4) {
                                        errorNotifier.value =
                                            "Please enter 4-digit OTP";
                                        return;
                                      }
                                      errorNotifier.value = null;
                                      isLoading.value = true; // start loading ✅

                                      final userId =
                                          await SyncManager.verifyOtp(
                                        context,
                                        phoneNumber,
                                        int.tryParse(enteredOtp),
                                      );

                                      final cartProvider =
                                          Provider.of<CartProvider>(context,
                                              listen: false);
                                      final subTotal = cartProvider.subTotal;
                                      final total = subTotal;
                                      final orderedItems = cartProvider.items;

                                      final order =
                                          await SyncManager.placeOrder(
                                        context,
                                        userId,
                                        total,
                                        orderedItems,
                                      );

                                      isLoading.value = false; // stop loading ✅

                                      if (order != null) {
                                        Navigator.pop(context);
                                        Future.delayed(
                                            Duration(milliseconds: 100), () {
                                          showSuccessDialog(context, order);
                                        });
                                        //  context.read<CartProvider>().clearCart();

                                        //  Navigator.pop(context);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColor.primaryColor,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: loading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColor.primaryColor,
                                      ),
                                    )
                                  : Text(
                                      'Verify',
                                      style:
                                          AppStyle.textStyleReemKufi.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.primaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       'Resend',
                    //       style: AppStyle.textStyleReemKufi.copyWith(
                    //         fontWeight: FontWeight.w200,
                    //         color: AppColor.whiteColor,
                    //         fontSize: 15,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final newOtpInt =
                                await SyncManager.login(context, phoneNumber);

                            if (newOtpInt != null) {
                              final newOtp = newOtpInt
                                  .toString()
                                  .padLeft(4, '0'); // ensure 4 digits

                              // Wrap in setState to update the UI
                              (context as Element)
                                  .markNeedsBuild(); // ensures rebuild in StatefulBuilder
                              for (int i = 0;
                                  i < controllers.length && i < newOtp.length;
                                  i++) {
                                controllers[i].text = newOtp[i];
                              }

                              errorNotifier.value =
                                  null; // clear any previous error
                            } else {
                              // Optionally show an error if OTP is null
                              errorNotifier.value =
                                  "Failed to resend OTP. Try again.";
                            }
                          },
                          child: Text(
                            'Resend',
                            style: AppStyle.textStyleReemKufi.copyWith(
                              fontWeight: FontWeight.w200,
                              color: AppColor.whiteColor,
                              fontSize: 15,
                              //   decoration: TextDecoration.underline,
                              decorationColor:
                                  AppColor.whiteColor, // underline color
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position:
              Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim),
          child: child,
        );
      },
    );
  }

  Widget _buildOptionBox(
    BuildContext context,
    String title,
    String price, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double priceSize = isDesktop
        ? 20
        : isTablet
            ? 17
            : 14;
    return GestureDetector(
      onTap: onTap,
      child: isSelected
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.secondary, AppColor.primaryColor],
                    begin: AlignmentDirectional(0.0, -2.0), // top-center
                    end: AlignmentDirectional(0.0, 1.0), // bottom-center

                    stops: [0.0, 1.0], // smooth gradient
                    tileMode: TileMode.clamp,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.1), // subtle shadow color
                  //     blurRadius: 8, // how soft the shadow looks
                  //     spreadRadius: 2, // how wide the shadow spreads
                  //     offset: const Offset(0, 4), // position of shadow (x, y)
                  //   ),
                  // ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: priceSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      price,
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontSize: priceSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(2), // border thickness
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.secondary, AppColor.primaryColor],
                    begin: AlignmentDirectional(0.0, -2.0), // top-center
                    end: AlignmentDirectional(0.0, 1.0), // bottom-center

                    stops: [0.0, 1.0], // smooth gradient
                    tileMode: TileMode.clamp,
                  ),
                  borderRadius:
                      BorderRadius.circular(14), // slightly bigger for border
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.1), // subtle shadow color
                        blurRadius: 8, // how soft the shadow looks
                        spreadRadius: 5, // how wide the shadow spreads
                        offset: const Offset(0, 4), // position of shadow (x, y)
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppStyle.textStyleReemKufi.copyWith(
                          fontSize: priceSize,
                          fontWeight: FontWeight.bold,
                          color: AppColor.blackColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        price,
                        style: AppStyle.textStyleReemKufi.copyWith(
                          fontSize: priceSize,
                          fontWeight: FontWeight.bold,
                          color: AppColor.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void showBurgerDialog(BuildContext context, CartItemModel product) {
    final prefHelper = getIt<SharedPreferenceHelper>();
    final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
    bool isExpanded = false;
    final selectedProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    // selectedProvider.setBasePrice(product.price);
    selectedProvider.setQuantity(1);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (isTakeAway) {
      selectedProvider.setBasePriceWithTakeAwayS(product);
    } else {
      selectedProvider.setBasePrice(
        product.price ?? 0.0,
      );
    }
    // selectedProvider.setBasePrice(
    //   (product.price != null && product.price!.isNotEmpty)
    //       ? double.tryParse(product.price!) ?? 0.0
    //       : 0.0,
    // );
    //selectedProvider.setBasePriceWithTakeAway(product);

    selectedProvider.setSelectedChildCategory(null);

    // Check if product is already in cart and get current quantity
    final cartItem = cartProvider.getCartItemById(product.id);
    if (cartItem != null) {
      // Set dialog quantity to existing cart quantity
      selectedProvider.setQuantity(cartItem.quantity);
    } else {
      selectedProvider.setQuantity(1);
    }
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double buttonFontSize = isDesktop
        ? 25
        : isTablet
            ? 17
            : 16;
    final double priceSize = isDesktop
        ? 27
        : isTablet
            ? 17
            : 17;
    final double description = isDesktop
        ? 20
        : isTablet
            ? 15
            : 15;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54, // dim background
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: StatefulBuilder(
            builder: (context, setState) {
              return SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenHeight = constraints.maxHeight;
                    final screenWidth = constraints.maxWidth;

                    return GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.primaryDelta! > 15) {
                          // drag down with some threshold
                          Navigator.of(context).pop();
                        }
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: screenWidth,
                          constraints: BoxConstraints(
                            maxHeight: screenHeight * 0.95,
                          ),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.primaryColor,
                                AppColor.whiteColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [
                                0.3,
                                0.25
                              ], // 👈 transition from primary → secondary at 70% height
                            ),
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: screenHeight * 0.28,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.primaryColor,
                                      AppColor.secondary,
                                    ],
                                    end: Alignment.bottomRight,
                                    begin: Alignment.topCenter,
                                    stops: [0.3, 0.9],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(80)),
                                        child: Container(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Image.network(
                                            "${ApiEndpoints.imageBaseUrl}${product.images.isNotEmpty ? product.images.first : ''}",
                                            //  fit: BoxFit.fill,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                const Icon(
                                                    Icons.image_not_supported),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 16,
                                      top: 16,
                                      child: GestureDetector(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: SvgPicture.asset(AppImage.cross),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(70),
                                      //topRight: Radius.circular(10),
                                      //  bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.all(screenWidth * 0.04),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  (product.name.isNotEmpty)
                                                      ? product.name[0]
                                                              .toUpperCase() +
                                                          product.name
                                                              .substring(1)
                                                              .toLowerCase()
                                                      : '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppStyle.textStyle400
                                                      .copyWith(
                                                    color: AppColor.blackColor,
                                                    fontSize: priceSize,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "₹${(double.tryParse(product.price.toStringAsFixed(2)))}",
                                                style: AppStyle
                                                    .textStyleReemKufi
                                                    .copyWith(
                                                  color: AppColor.blackColor,
                                                  fontSize: priceSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, right: 12.0, top: 8),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  final bool isDescriptionLong =
                                                      product.description!
                                                              .length >
                                                          350;
                                                  final String?
                                                      displayDescription =
                                                      isExpanded ||
                                                              !isDescriptionLong
                                                          ? product.description
                                                          : '${product.description?.substring(0, 350)}...';

                                                  if (isDescriptionLong) {
                                                    // Long description -> show in column
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          displayDescription!,
                                                          maxLines: isExpanded
                                                              ? null
                                                              : 4,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style: AppStyle
                                                              .textStyleReemKufi
                                                              .copyWith(
                                                            color: AppColor
                                                                .greyColor,
                                                            fontSize:
                                                                description,
                                                          ),
                                                        ),
                                                        if (isDescriptionLong)
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                isExpanded =
                                                                    !isExpanded;
                                                              });
                                                            },
                                                            child: Text(
                                                              isExpanded
                                                                  ? "See Less"
                                                                  : "See More",
                                                              style:
                                                                  const TextStyle(
                                                                color: AppColor
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                        const SizedBox(
                                                            height: 9),

                                                        /// Prep Time
                                                        if (product.prepareTime !=
                                                                null &&
                                                            product.prepareTime!
                                                                .trim()
                                                                .isNotEmpty)
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                AppImage.time,
                                                                height: 20,
                                                              ),
                                                              const SizedBox(
                                                                  width: 6),
                                                              Text(
                                                                product.prepareTime!
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            "mins")
                                                                    ? product
                                                                        .prepareTime!
                                                                    : "${product.prepareTime} mins",
                                                                style: AppStyle
                                                                    .textStyleReemKufi
                                                                    .copyWith(
                                                                  color: AppColor
                                                                      .darkGreyColor,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 9),
                                                              if (product.takeAwayPrice !=
                                                                      null &&
                                                                  isTakeAway)
                                                                Row(
                                                                  children: [
                                                                    SvgPicture
                                                                        .asset(
                                                                      AppImage
                                                                          .take,
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            4),
                                                                    Builder(
                                                                      builder:
                                                                          (context) {
                                                                        final dynamic
                                                                            packingCharge =
                                                                            product.takeAwayPrice;
                                                                        final double? chargeValue = packingCharge
                                                                                is String
                                                                            ? double.tryParse(
                                                                                packingCharge)
                                                                            : (packingCharge is double
                                                                                ? packingCharge
                                                                                : null);

                                                                        return Text(
                                                                          chargeValue != null
                                                                              ? "Wrap & Pack Fee Rs  ${chargeValue.toStringAsFixed(2)}"
                                                                              : "Rs 0.00",
                                                                          style: AppStyle
                                                                              .textStyleReemKufi
                                                                              .copyWith(
                                                                            color:
                                                                                AppColor.darkGreyColor,
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          ),

                                                        const SizedBox(
                                                            height: 6),

                                                        /// Takeaway Fee
                                                      ],
                                                    );
                                                  } else {
                                                    // Short description -> show in row with prep time first, then takeaway price
                                                    return Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        /// Description
                                                        Flexible(
                                                          child: Text(
                                                            product.description
                                                                .toString(),
                                                            // maxLines: 4,
                                                            // overflow: TextOverflow.ellipsis,
                                                            style: AppStyle
                                                                .textStyleReemKufi
                                                                .copyWith(
                                                              color: AppColor
                                                                  .darkGreyColor,
                                                              fontSize:
                                                                  description,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),

                                                        /// Prep Time
                                                        if (product.prepareTime !=
                                                                null &&
                                                            product.prepareTime!
                                                                .trim()
                                                                .isNotEmpty)
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SvgPicture.asset(
                                                                AppImage.time,
                                                                height: 20,
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                product.prepareTime!
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            "mins")
                                                                    ? product
                                                                        .prepareTime!
                                                                    : "${product.prepareTime} mins",
                                                                style: AppStyle
                                                                    .textStyleReemKufi
                                                                    .copyWith(
                                                                  color: AppColor
                                                                      .darkGreyColor,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                        const SizedBox(
                                                            width: 10),

                                                        /// Takeaway Fee
                                                        if (product.takeAwayPrice !=
                                                                null &&
                                                            isTakeAway)
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                AppImage.take,
                                                                height: 20,
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Builder(
                                                                builder:
                                                                    (context) {
                                                                  final dynamic
                                                                      packingCharge =
                                                                      product
                                                                          .takeAwayPrice;
                                                                  final double? chargeValue = packingCharge
                                                                          is String
                                                                      ? double.tryParse(
                                                                          packingCharge)
                                                                      : (packingCharge
                                                                              is double
                                                                          ? packingCharge
                                                                          : null);

                                                                  return Text(
                                                                    chargeValue !=
                                                                            null
                                                                        ? "Wrap & Pack Fee Rs  ${chargeValue.toStringAsFixed(2)}"
                                                                        : "Rs 0.00",
                                                                    style: AppStyle
                                                                        .textStyleReemKufi
                                                                        .copyWith(
                                                                      color: AppColor
                                                                          .darkGreyColor,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        if (product.childCategory != null &&
                                            product
                                                .childCategory!.isNotEmpty) ...[
                                          SizedBox(
                                              height: screenHeight * 0.025),

                                          // 🟡 Size options
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: product.childCategory!
                                                .map((child) {
                                              final provider = context
                                                  .watch<CategoryProvider>();
                                              var selectedChild = provider
                                                  .selectedChildCategory;

                                              if (selectedChild == null &&
                                                  product.childCategory!
                                                      .isNotEmpty) {
                                                // selectedChild =
                                                //     product.childCategory!.first;
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  context
                                                      .read<CategoryProvider>()
                                                      .setSelectedChildCategory(
                                                          selectedChild);
                                                });
                                              }
                                              return _buildOptionBox(
                                                context,
                                                child.name,
                                                "₹${(child.price ?? 0).toStringAsFixed(0)}",
                                                isSelected: selectedChild?.id ==
                                                    child.id,
                                                onTap: () {
                                                  context
                                                      .read<CategoryProvider>()
                                                      .setSelectedChildCategory(
                                                          child);
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                        SizedBox(height: screenHeight * 0.025),
                                        Row(
                                          children: [
                                            Visibility(
                                              visible: product.spicy == "0",
                                              child: Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Spicy Label with left padding
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15.0),
                                                      child: Text(
                                                        "Spicy",
                                                        style: AppStyle
                                                            .textStyleReemKufi
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              buttonFontSize,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    // HeatLevelSelector fills width but no left padding here
                                                    HeatLevelSelector(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 18),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Mild",
                                                            style: AppStyle
                                                                .textStyleReemKufi
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  description,
                                                              color: AppColor
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Medium",
                                                            style: AppStyle
                                                                .textStyleReemKufi
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  description,
                                                              color: AppColor
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Hot",
                                                            style: AppStyle
                                                                .textStyleReemKufi
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  description,
                                                              color: AppColor
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Quantity",
                                                        style: AppStyle
                                                            .textStyleReemKufi
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              buttonFontSize,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildIconButton(
                                                              Icons.remove, () {
                                                            selectedProvider
                                                                .decreaseQuantity();
                                                          }),
                                                          const SizedBox(
                                                              width: 12),
                                                          Consumer<
                                                              CategoryProvider>(
                                                            builder: (context,
                                                                provider,
                                                                child) {
                                                              return Text(
                                                                "${provider.quantity}",
                                                                style: AppStyle
                                                                    .textStyleReemKufi
                                                                    .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 20,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          const SizedBox(
                                                              width: 12),
                                                          _buildIconButton(
                                                              Icons.add, () {
                                                            selectedProvider
                                                                .increaseQuantity();
                                                          }),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.02),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate or open add-ons screen
                                  // Navigator.pop(context);
                                  Future.delayed(
                                      const Duration(milliseconds: 200), () {
                                    showAddOnDialog(
                                        context, product); // Your add-on dialog
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9EFE9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(AppImage.addOn,
                                          height: 20),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            "Add Add-Ons",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Make It Special — Choose Your Add-Ons Now!",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.arrow_forward_ios,
                                          size: 18, color: Colors.black54),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.015,
                                ),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.secondary,
                                      AppColor.primaryColor
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ShaderMask(
                                            shaderCallback: (bounds) =>
                                                const LinearGradient(colors: [
                                              AppColor.primaryColor,
                                              AppColor.primaryColor
                                            ]).createShader(Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    bounds.width,
                                                    bounds.height)),
                                            child: Text('Price',
                                                style: AppStyle
                                                    .textStyleReemKufi
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontSize: isDesktop ? 17 : 16,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                          Selector<CategoryProvider, double>(
                                            selector: (context, provider) {
                                              final prefHelper = getIt<
                                                  SharedPreferenceHelper>();
                                              final isTakeAway =
                                                  prefHelper.getBool(StorageKey
                                                          .isTakeAway) ??
                                                      false;

                                              // If TakeAway is true, use totalPrice else use totalPrices
                                              return isTakeAway
                                                  ? provider.totalPrice
                                                  : provider.totalPrices;
                                            },
                                            builder:
                                                (context, finalTotal, child) {
                                              return ShaderMask(
                                                shaderCallback: (bounds) =>
                                                    const LinearGradient(
                                                  colors: [
                                                    AppColor.primaryColor,
                                                    AppColor.primaryColor
                                                  ],
                                                ).createShader(Rect.fromLTWH(
                                                        0,
                                                        0,
                                                        bounds.width,
                                                        bounds.height)),
                                                child: Text(
                                                  '₹${finalTotal.toStringAsFixed(2)}',
                                                  style: AppStyle
                                                      .textStyleReemKufi
                                                      .copyWith(
                                                    color: Colors.white,
                                                    fontSize:
                                                        isDesktop ? 17 : 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),

                                    // Add to Cart button
                                    Expanded(
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            /// include childcategorytakeawayprice
                                            //                                           final dynamic packingCharge = (product.childCategory != null &&
                                            //                                               product.childCategory.isNotEmpty &&
                                            //                                               product.childCategory.first.takeAwayPrice != null)
                                            //                                               ? product.childCategory.first.takeAwayPrice
                                            //                                               : product.takeAwayPrice;
                                            //
                                            // // Convert to double safely
                                            //                                           final double? packingChargeValue = packingCharge is String
                                            //                                               ? double.tryParse(packingCharge)
                                            //                                               : (packingCharge is double ? packingCharge : null);
                                            // Take only product-level takeAwayPrice
                                            final dynamic packingCharge =
                                                product.takeAwayPrice;

                                            // Convert to double safely
                                            final double? packingChargeValue =
                                                packingCharge is String
                                                    ? double.tryParse(
                                                        packingCharge)
                                                    : (packingCharge is double
                                                        ? packingCharge
                                                        : null);

                                            final selectedChild = context
                                                .read<CategoryProvider>()
                                                .selectedChildCategory;
                                            final totalTime = context
                                                .read<CategoryProvider>()
                                                .totalTime;
                                            final cartProvider =
                                                context.read<CartProvider>();
                                            final selectedProvider = context
                                                .read<CategoryProvider>();

                                            final cartItem = CartItemModel(
                                                id: product.id,
                                                name: product.name,
                                                description:
                                                    product.description,
                                                images: product.images,
                                                categoryId: product.categoryId,
                                                price: isTakeAway
                                                    ? (selectedProvider
                                                            .selectedPrices ??
                                                        0.0)
                                                    : (selectedProvider
                                                            .selectedPrices ??
                                                        0.0),
                                                quantity:
                                                    selectedProvider.quantity,
                                                takeAwayPrice: isTakeAway
                                                    ? packingChargeValue
                                                    : null,
                                                childCategory:
                                                    product.childCategory,
                                                subCategoryId: product.id,
                                                childCategoryId: selectedChild
                                                    ?.id
                                                    .toString(),
                                                childCategoryName:
                                                    selectedChild?.name,
                                                isCombo: null,
                                                heatLevel: selectedProvider
                                                    .selectedHeatLabel,
                                                totalDeliveryTime: totalTime,
                                                type: "normal",
                                                prepareTime:
                                                    product.prepareTime,
                                                image: '');
                                            cartProvider.addToCart(cartItem);
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColor.whiteColor,
                                            foregroundColor:
                                                AppColor.whiteColor,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 28, vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: ShaderMask(
                                            shaderCallback: (bounds) =>
                                                const LinearGradient(
                                              colors: [
                                                AppColor.primaryColor,
                                                AppColor.primaryColor
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomRight,
                                            ).createShader(Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    bounds.width,
                                                    bounds.height)),
                                            child: Text(
                                              'Add To Cart',
                                              style: AppStyle.textStyleReemKufi
                                                  .copyWith(
                                                color: Colors.white,
                                                fontSize: isDesktop ? 22 : 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(anim1),
          child: child,
        );
      },
    );
  }

  void showAddOnDialog(BuildContext context, CartItemModel product) {
    final selectedProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 0.15;
    // Keep selectedAddOns persistent during dialog lifecycle
    final List<String> selectedAddOns = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: screenHeight * 0.95,
              decoration: const BoxDecoration(
                //  color: AppColor.primaryColor,
                gradient: LinearGradient(
                  colors: [
                    AppColor.primaryColor, // Top color
                    AppColor.primaryColor, // Middle transition color
                    AppColor.whiteColor, // Bottom color
                  ],
                  begin: Alignment.topCenter, // Start at the top
                  end: Alignment.bottomCenter, // End at the bottom
                  stops: [0.0, 0.2, 1.0], // Match colors length (3 values here)
                ),

                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 22.0, top: 18, bottom: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(AppImage.backArrow, height: 25),
                    ),
                  ),
                  // Replace the current image + name section with this:
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            "${ApiEndpoints.imageBaseUrl}${product.images.isNotEmpty ? product.images.first : ''}",
                            height: imageSize,
                            width: imageSize,
                            //   fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 70),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Product Name + Price (if needed)
                        Expanded(
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (product.name != null &&
                                        product.name!.isNotEmpty)
                                    ? product.name![0].toUpperCase() +
                                        product.name!.substring(1).toLowerCase()
                                    : '',
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  color: AppColor.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // Optional: show price here
                              Text(
                                "₹${(double.tryParse(product.price.toStringAsFixed(2)))}",
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  color: AppColor.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Text(
                              //   "₹${product.discountPrice ?? '0'}",
                              //   style: AppStyle.textStyleReemKufi.copyWith(
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.w600,
                              //     color: Colors.white,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ===== Add-ons Section =====
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(70),
                          // topRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          // Title
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                            child: Text(
                              "Choose Your Add-ons",
                              style: AppStyle.textStyleReemKufi.copyWith(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Divider(),
                          // Add-ons List
                          Expanded(
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: sampleAddOnJson
                                  .length, // Use sample data length
                              itemBuilder: (context, index) {
                                // Create the AddOnModel list from sample JSON
                                final addOns = sampleAddOnJson
                                    .map((json) => AddOnModel.fromJson(json))
                                    .toList();

                                final addOn = addOns[
                                    index]; // <-- Fix: reference the specific addOn
                                final isSelected =
                                    selectedAddOns.contains(addOn.name);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedAddOns.remove(addOn.name);
                                      } else {
                                        selectedAddOns.add(addOn.name);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 8),
                                    decoration: BoxDecoration(
                                        // border: Border(
                                        //   bottom: BorderSide(color: Colors.grey.shade300),
                                        // ),
                                        ),
                                    child: Row(
                                      children: [
                                        // Custom Checkbox
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColor.primaryColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: AppColor.primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: isSelected
                                              ? const Icon(Icons.check,
                                                  size: 16, color: Colors.white)
                                              : null,
                                        ),
                                        const SizedBox(width: 12),

                                        // Add-on Name
                                        Expanded(
                                          child: Text(
                                            addOn.name,
                                            style: AppStyle.textStyleReemKufi
                                                .copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),

                                        // Price
                                        Text(
                                          "₹${addOn.price}",
                                          style: AppStyle.textStyleReemKufi
                                              .copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===== Footer Section =====
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.015,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColor.secondary, AppColor.primaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Price Box
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price',
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  color: AppColor.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Selector<CategoryProvider, double>(
                                selector: (_, provider) => provider.totalPrice,
                                builder: (context, totalPrice, child) {
                                  return Text(
                                    '₹${totalPrice.toStringAsFixed(2)}',
                                    style: AppStyle.textStyleReemKufi.copyWith(
                                      color: AppColor.primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),

                        // Add to Cart Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final prefHelper =
                                  getIt<SharedPreferenceHelper>();
                              final isTakeAway =
                                  prefHelper.getBool(StorageKey.isTakeAway) ??
                                      false;
                              final cartProvider = Provider.of<CartProvider>(
                                  context,
                                  listen: false);
                              final dynamic packingCharge =
                                  product.takeAwayPrice;
                              final totalTime =
                                  context.read<CategoryProvider>().totalTime;
                              // Convert to double safely
                              final double? packingChargeValue =
                                  packingCharge is String
                                      ? double.tryParse(packingCharge)
                                      : (packingCharge is double
                                          ? packingCharge
                                          : null);

                              final selectedChild = context
                                  .read<CategoryProvider>()
                                  .selectedChildCategory;

                              final cartItem = CartItemModel(
                                  id: product.id,
                                  name: product.name,
                                  description: product.description,
                                  images: product.images,
                                  categoryId: product.categoryId,
                                  price: isTakeAway
                                      ? (selectedProvider.selectedPrices ?? 0.0)
                                      : (selectedProvider.selectedPrices ??
                                          0.0),
                                  quantity: selectedProvider.quantity,
                                  takeAwayPrice:
                                      isTakeAway ? packingChargeValue : null,
                                  childCategory: product.childCategory,
                                  subCategoryId: product.id,
                                  childCategoryId: selectedChild?.id.toString(),
                                  childCategoryName: selectedChild?.name,
                                  isCombo: null,
                                  heatLevel: selectedProvider.selectedHeatLabel,
                                  totalDeliveryTime: totalTime,
                                  type: "normal",
                                  prepareTime: product.prepareTime,
                                  image: '');
                              cartProvider.addToCart(cartItem);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColor.primaryColor,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Add To Cart',
                              style: AppStyle.textStyleReemKufi.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColor.secondary, AppColor.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 0.60],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }

  void showSuccessDialog(BuildContext context, OrderModel order) {
    Future.delayed(Duration.zero, () {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        pageBuilder: (_, __, ___) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          return Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding:
                    EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.5,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppColor.secondary, AppColor.primaryColor],
                        begin: AlignmentDirectional(0.0, -2.0), // top-center
                        end: AlignmentDirectional(0.0, 1.0), // bottom-center
                        stops: [0.0, 1.0], // smooth gradient
                        tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center vertically
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center horizontally
                    children: [
                      const Icon(Icons.check_circle,
                          size: 60, color: Colors.white),
                      const SizedBox(height: 20),
                      Text(
                        "You've successfully logged in.",
                        style: AppTextStyles.nunitoRegular(20, color:  AppColor.whiteColor),

                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        // transitionBuilder: (_, anim, __, child) {
        //   return SlideTransition(
        //     position: Tween(begin: const Offset(0, 1), end: Offset.zero)
        //         .animate(anim),
        //     child: child,
        //   );
        // },
      );

      // Automatically navigate to PaymentScreen after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // close success dialog
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PaymentScreen(
                    order: order,
                  )),
        );
      });
    });
  }
}

class HeatLevelSelector extends StatefulWidget {
  @override
  _HeatLevelSelectorState createState() => _HeatLevelSelectorState();
}

class _HeatLevelSelectorState extends State<HeatLevelSelector> {
  int _selectedHeat = 0; // 0 - Mild, 1 - Medium, 2 - Hot

  final List<String> heatLabels = ['Mild', 'Medium', 'Hot'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              activeTrackColor:
                  AppColor.primaryColor, // Hide default active track color
              inactiveTrackColor:
                  Colors.grey, // Hide default inactive track color
              valueIndicatorColor: AppColor.primaryColor,
              thumbColor: AppColor.primaryColor),
          child: Slider(
            value: _selectedHeat.toDouble(),
            min: 0,
            max: 2,
            divisions: 2,
            label: heatLabels[_selectedHeat],
            onChanged: (double value) {
              setState(() {
                _selectedHeat = value.round();
              });
            },
          ),
        ),
      ],
    );
  }
}

/// now Tax value added in static value
