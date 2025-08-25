import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ravathi_store/service/sync_manager.dart';
import 'package:ravathi_store/urls/api_endpoints.dart';
import 'package:ravathi_store/utlis/widgets/custom_appbar.dart';
import 'package:ravathi_store/views/payment_screen.dart';

import '../models/order_model.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../utlis/App_color.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../utlis/App_image.dart';
import '../utlis/App_style.dart';

class ViewOrderScreen extends StatelessWidget {
  const ViewOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderedItems = cartProvider.items;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isMobile = screenWidth < 600;
    final double buttonPaddingH = isDesktop ? 36 : isTablet ? 32 : 28;
    final double buttonPaddingV = isDesktop ? 18 : isTablet ? 16 : 14;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: const CustomAppBar(
        title: 'Your Cart',
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.items.isEmpty) {
            return const SizedBox.shrink(); // empty widget
          }

          double subTotal = cartProvider.subTotal;
          //double packingCharge = 10;
          double total = subTotal;
          String estimatedTime = "30-40 mins";
          final double buttonFontSize = isDesktop ? 22 : isTablet ? 17 : 16;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.secondary,
                  AppColor.primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                stops: [0, 0.7],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
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
                      _priceRow("Sub-Total", "₹${subTotal.toStringAsFixed(2)}"),
                      // _priceRow("Packing Charge",
                      //     "₹${packingCharge.toStringAsFixed(2)}"),
                      const Divider(color: Colors.white54),
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
                            "Estimated delivery time",
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
                  height: 60,
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
          );
        },
      ),
      body: orderedItems.isEmpty
          ? const Center(child: Text('No items ordered.'))
          : ListView.builder(
              itemCount: orderedItems.length,
              itemBuilder: (context, index) {
                final screenWidth = MediaQuery.of(context).size.width;
                final screenHeight = MediaQuery.of(context).size.height;

                final double imageSize = screenWidth * 0.18;
                final containerPadding = screenWidth * 0.03;

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
                                horizontal: containerPadding, vertical: 6),
                            padding: EdgeInsets.all(containerPadding),
                            decoration: BoxDecoration(
                              color: Colors.white,
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

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Product Images (Responsive - No Fixed Height)
                                    Flexible(
                                      flex: 0,
                                      child: isMobile
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 14.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  for (int i = 0;
                                                      i < item.images.length;
                                                      i++) ...[
                                                    Container(
                                                      width: (constraints
                                                                  .maxWidth *
                                                              0.25)
                                                          .clamp(40, 80),
                                                      height: (constraints
                                                                  .maxWidth *
                                                              0.25)
                                                          .clamp(40, 80),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColor
                                                                .greyColor,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      child: Image.network(
                                                        "${ApiEndpoints.imageBaseUrl}${item.images[i]}",
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return const Icon(
                                                            Icons.broken_image,
                                                            size: 50,
                                                            color: Colors.grey,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    if (i <
                                                        item.images.length - 1)
                                                      const Icon(Icons.add,
                                                          size: 30,
                                                          color: AppColor
                                                              .primaryColor),
                                                  ],
                                                ],
                                              ),
                                            )
                                          : Wrap(
                                              spacing: 4,
                                              runSpacing:
                                                  4, // allows wrapping to next line
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                for (int i = 0;
                                                    i < item.images.length;
                                                    i++) ...[
                                                  Container(
                                                    width:
                                                        (constraints.maxWidth *
                                                                0.15)
                                                            .clamp(40, 80),
                                                    height:
                                                        (constraints.maxWidth *
                                                                0.15)
                                                            .clamp(40, 80),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColor
                                                              .greyColor,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: Image.network(
                                                      "${ApiEndpoints.imageBaseUrl}${item.images[i]}",
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return const Icon(
                                                          Icons.broken_image,
                                                          size: 50,
                                                          color: Colors.grey,
                                                        );
                                                      },
                                                    ),

                                                  ),
                                                  if (i <
                                                      item.images.length - 1)
                                                    const Icon(Icons.add,
                                                        size: 30,
                                                        color: AppColor
                                                            .primaryColor),
                                                ],
                                              ],
                                            ),
                                    ),

                                    SizedBox(width: screenWidth * 0.03),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize
                                            .min, // prevent extra space from Column
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center, // align center vertically
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.name,
                                                  style: AppStyle
                                                      .textStyleReemKufi
                                                      .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.blackColor,
                                                    fontSize: 18,
                                                    height:
                                                        1.0, // remove extra line height
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.clear_outlined,
                                                  color: AppColor.primaryColor,
                                                  size: 20,
                                                ),
                                                padding: EdgeInsets.zero, // remove default padding
                                                constraints: const BoxConstraints(
                                                  minWidth: 20,
                                                  minHeight: 20,
                                                ),
                                                onPressed: () async {
                                                  final confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title:  Text("Confirm Delete", style: AppStyle
                                                            .textStyleReemKufi
                                                            .copyWith(
                                                          fontWeight: FontWeight.w500,
                                                          color: AppColor.primaryColor,
                                                          fontSize: 18,
                                                          height:
                                                          1.0, // remove extra line height
                                                        ),),
                                                        content:  Text("Are you sure you want to delete this item?",style: AppStyle
                                                            .textStyleReemKufi
                                                            .copyWith(
                                                          fontWeight: FontWeight.w300,
                                                          color: AppColor.blackColor,
                                                          fontSize: 18,
                                                          height:
                                                          1.0, // remove extra line height
                                                        )),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child:  Text("Cancel",style: AppStyle
                                                                .textStyleReemKufi
                                                                .copyWith(
                                                              fontWeight: FontWeight.w300,
                                                              color: AppColor.blackColor,
                                                              fontSize: 14,
                                                              height:
                                                              1.0, // remove extra line height
                                                            ),),
                                                          ),
                                                          TextButton(
                                                            onPressed: () => Navigator.of(context).pop(true),
                                                            child:  Text(
                                                              "Delete",
                                                              style: AppStyle
                                                                  .textStyleReemKufi
                                                                  .copyWith(
                                                                fontWeight: FontWeight.w300,
                                                                color: AppColor.primaryColor,
                                                                fontSize: 14,
                                                                height:
                                                                1.0, // remove extra line height
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );

                                                  if (confirm == true) {
                                                    cartProvider.removeItem(item.id);
                                                  }
                                                },
                                              ),

                                            ],
                                          ),

                                          Text(
                                            '₹${(item.price * quantity).toStringAsFixed(2)}',
                                            style: AppStyle.textStyleReemKufi
                                                .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: AppColor.blackColor,
                                              fontSize: 16,
                                              height:
                                                  1.0, // remove extra line height
                                            ),
                                          ),
                                          if (item.childCategoryName != null && item.childCategoryName!.isNotEmpty)
                                            Row(
                                              children: [
                                                Text(
                                                  "Type : ",
                                                  style: AppStyle.textStyleReemKufi.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.greyColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  item.childCategoryName!,
                                                  style: AppStyle.textStyleReemKufi.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.blackColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),


                                          const SizedBox(
                                              height:
                                                  14), // small gap before qty
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => cartProvider
                                                    .decrement(item.id),
                                                child: _buildQtyButton(
                                                    Icons.remove),
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.030),
                                              Text(
                                                '$quantity',
                                                style: AppStyle
                                                    .textStyleReemKufi
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                  height: 1.0,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.030),
                                              GestureDetector(
                                                onTap: () => cartProvider
                                                    .increment(item.id),
                                                child:
                                                    _buildQtyButton(Icons.add),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    )
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
                                width: 50,
                              ),
                            ),
                          if (item.isCombo == true)
                            Positioned(
                              top: 0,
                              left: 20,
                              child: Image.asset(
                                AppImage.badge1,
                                width: 50,
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
  }

  Widget _buildQtyButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
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
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final screenWidth = MediaQuery.of(context).size.width;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
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
                width: MediaQuery.of(context).size.width,
                height: screenHeight * 0.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.secondary,
                      AppColor.primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.7],
                  ),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20), bottom: Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center, // centers content vertically
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Login",
                        style: AppStyle.textStyleReemKufi.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColor.whiteColor,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white54),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Mobile Number',
                            style: AppStyle.textStyleReemKufi.copyWith(
                              fontWeight: FontWeight.w200,
                              color: AppColor.whiteColor,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                  
                      // Country code + mobile input
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Text(
                              "+91",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
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
                              ),
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
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            final otp = await SyncManager.login(context, phoneController.text);
                  
                            if (otp != null) {
                              showOtpDialog(context, otp.toString(),phoneController.text); // ✅ Pass OTP
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Get OTP',
                            style: AppStyle.textStyleReemKufi.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColor.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
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
    List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
    final ValueNotifier<String?> errorNotifier = ValueNotifier(null); // ✅ error state

    if (otp != null) {
      for (int i = 0; i < controllers.length && i < otp.length; i++) {
        controllers[i].text = otp[i];
      }
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
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
                  gradient: LinearGradient(
                    colors: [
                      AppColor.secondary,
                      AppColor.primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.7],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "OTP Verification",
                      style: AppStyle.textStyleReemKufi.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColor.whiteColor,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white54),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Enter the verification code that we sent to your mobile number',
                            style: AppStyle.textStyleReemKufi.copyWith(
                              fontWeight: FontWeight.w200,
                              color: AppColor.whiteColor,
                              fontSize: 15,
                            ),
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
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: error != null
                                              ? Colors.red
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
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
                                        FocusScope.of(context)
                                            .requestFocus(focusNodes[index - 1]);
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
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final enteredOtp =
                          controllers.map((c) => c.text).join();

                          if (enteredOtp.length != 4) {
                            errorNotifier.value = "Please enter 4-digit OTP"; // ✅ validation
                            return;
                          }

                          errorNotifier.value = null; // clear error

                          final userId = await SyncManager.verifyOtp(
                            context,
                            phoneNumber,
                            int.tryParse(enteredOtp),
                          );

                          final cartProvider =
                          Provider.of<CartProvider>(context, listen: false);
                          final subTotal = cartProvider.subTotal;
                          final total = subTotal;
                          final orderedItems = cartProvider.items;

                          final order = await SyncManager.placeOrder(
                            context,
                            userId,
                            total,
                            orderedItems,
                          );
                          if (order != null) {
                            showSuccessDialog(context, order);
                            Navigator.pop(context); // Close OTP dialog
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Verify',
                          style: AppStyle.textStyleReemKufi.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Resend',
                          style: AppStyle.textStyleReemKufi.copyWith(
                            fontWeight: FontWeight.w200,
                            color: AppColor.whiteColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim),
          child: child,
        );
      },
    );
  }

  // void showOtpDialog(BuildContext context, String? otp, String phoneNumber){
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   List<TextEditingController> controllers =
  //       List.generate(4, (_) => TextEditingController());
  //   List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  //   if (otp != null) {
  //     for (int i = 0; i < controllers.length && i < otp.length; i++) {
  //       controllers[i].text = otp[i];
  //     }
  //   }
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: '',
  //     pageBuilder: (_, __, ___) {
  //       final screenWidth = MediaQuery.of(context).size.width;
  //       final screenHeight = MediaQuery.of(context).size.height;
  //       return Align(
  //         alignment: Alignment.center,
  //         child: Material(
  //           color: Colors.transparent,
  //           child: Padding(
  //             padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
  //             child: Container(
  //               width: screenWidth,
  //               height: screenHeight * 0.5,
  //               padding: const EdgeInsets.all(16),
  //               decoration: const BoxDecoration(
  //                   gradient: LinearGradient(
  //                     colors: [
  //                       AppColor.secondary,
  //                       AppColor.primaryColor,
  //                     ],
  //                     begin: Alignment.topLeft,
  //                     end: Alignment.bottomCenter,
  //                     stops: [0, 0.7],
  //                   ),
  //                   borderRadius: BorderRadius.vertical(
  //                       top: Radius.circular(20), bottom: Radius.circular(20))),
  //               child: Column(
  //
  //                 mainAxisAlignment:
  //                     MainAxisAlignment.center, // centers content vertically
  //                 crossAxisAlignment:
  //                     CrossAxisAlignment.center, // centers horizontally if needed
  //                 //  mainAxisSize: MainAxisSize.min,
  //                 children: [
  //
  //                   Text(
  //                     "OTP Verification",
  //                     style: AppStyle.textStyleReemKufi.copyWith(
  //                       fontWeight: FontWeight.w400,
  //                       color: AppColor.whiteColor,
  //                       fontSize: 20,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   const Divider(color: Colors.white54),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Expanded(
  //                         child: Text(
  //                           'Enter the verification code that we sent to your mobile number',
  //                           style: AppStyle.textStyleReemKufi.copyWith(
  //                             fontWeight: FontWeight.w200,
  //                             color: AppColor.whiteColor,
  //                             fontSize: 15,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 20),
  //                   LayoutBuilder(
  //                     builder: (context, constraints) {
  //                       double fieldWidth = (constraints.maxWidth - 40) / 4;
  //
  //                       return Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         children: List.generate(4, (index) {
  //                           return SizedBox(
  //                             width: fieldWidth,
  //                             child: TextField(
  //                               controller: controllers[index],
  //                               focusNode: focusNodes[index],
  //                               textAlign: TextAlign.center,
  //                               style: const TextStyle(fontSize: 18),
  //                               keyboardType: TextInputType.number,
  //                               maxLength: 1, // only one digit
  //                               decoration: InputDecoration(
  //                                 counterText: "", // hides the counter
  //                                 filled: true,
  //                                 fillColor: Colors.white,
  //                                 border: OutlineInputBorder(
  //                                   borderRadius: BorderRadius.circular(8),
  //                                 ),
  //                                 contentPadding:
  //                                     const EdgeInsets.symmetric(vertical: 12),
  //                               ),
  //                               onChanged: (value) {
  //                                 if (value.isNotEmpty) {
  //                                   // Move to next field if available
  //                                   if (index < focusNodes.length - 1) {
  //                                     FocusScope.of(context)
  //                                         .requestFocus(focusNodes[index + 1]);
  //                                   } else {
  //                                     FocusScope.of(context)
  //                                         .unfocus(); // Last field, hide keyboard
  //                                   }
  //                                 } else if (value.isEmpty && index > 0) {
  //                                   // Move back if deleted
  //                                   FocusScope.of(context)
  //                                       .requestFocus(focusNodes[index - 1]);
  //                                 }
  //                               },
  //                             ),
  //                           );
  //                         }),
  //                       );
  //                     },
  //                   ),
  //
  //                   const SizedBox(height: 20),
  //                   SizedBox(
  //                     width: double.infinity,
  //                     height: 50,
  //                     child: SizedBox(
  //                       width: double.infinity,
  //                       height: 50,
  //                       child: ElevatedButton(
  //                         onPressed: () async {
  //                           final cartProvider = Provider.of<CartProvider>(context, listen: false);
  //
  //                           double subTotal = cartProvider.subTotal;
  //                           double total = subTotal;
  //                           final orderedItems = cartProvider.items;
  //                           final enteredOtp = controllers.map((c) => c.text).join();
  //                           if (enteredOtp.length != 4) {
  //                             // Optional: show error if OTP is incomplete
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               const SnackBar(content: Text("Please enter 4-digit OTP")),
  //                             );
  //                             return;
  //                           }
  //
  //                           final userId = await SyncManager.verifyOtp(
  //                               context, phoneNumber,// mobile number
  //                               int.tryParse(enteredOtp) // OTP as int
  //                           );
  //
  //
  //                           final order = await SyncManager.placeOrder(
  //                             context,
  //                             userId,
  //                             total,
  //                             orderedItems,
  //                           );
  //                           if (order != null) {
  //                             // Order successful, show success dialog
  //                             showSuccessDialog(context, order);
  //                             Navigator.pop(context); // Close OTP dialog
  //                           }
  //
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.white,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                         ),
  //                         child: Text(
  //                           'Verify',
  //                           style: AppStyle.textStyleReemKufi.copyWith(
  //                             fontWeight: FontWeight.w600,
  //                             color: AppColor.primaryColor,
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //
  //                   ),
  //                   const SizedBox(height: 20),
  //                   Padding(
  //                     padding: const EdgeInsets.only(right: 8.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         Text(
  //                           'Resend',
  //                           style: AppStyle.textStyleReemKufi.copyWith(
  //                             fontWeight: FontWeight.w200,
  //                             color: AppColor.whiteColor,
  //                             fontSize: 15,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (_, anim, __, child) {
  //       return SlideTransition(
  //         position:
  //             Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim),
  //         child: child,
  //       );
  //     },
  //   );
  // }

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
                padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.5,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.secondary,
                        AppColor.primaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.7],
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                    children: [
                      const Icon(Icons.check_circle,
                          size: 60, color: Colors.white),
                      const SizedBox(height: 20),
                      Text(
                        "You've successfully logged in.",
                        style: AppStyle.textStyleReemKufi.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColor.whiteColor,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
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

      // Automatically navigate to PaymentScreen after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // close success dialog
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) =>  PaymentScreen(order: order,)),
        );
      });
    });
  }

}
