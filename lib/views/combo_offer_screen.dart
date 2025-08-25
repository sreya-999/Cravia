import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ravathi_store/views/view_order_screen.dart';


import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import '../utlis/App_color.dart';
import '../utlis/App_image.dart';
import '../utlis/App_style.dart';
import '../utlis/widgets/custom_appbar.dart';
import 'buy_one_get_one.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ComboOfferScreen extends StatelessWidget {
  const ComboOfferScreen({super.key});

  @override

  Widget build(BuildContext context) {
    Future.microtask(() {
      Provider.of<CategoryProvider>(context, listen: false)
          .getComboProduct(context,null);
    });

    final provider = Provider.of<CategoryProvider>(context);
    final products = provider.selectedCategoryProducts;
    final cartProvider = Provider.of<CartProvider>(context);
    double subTotal = cartProvider.subTotal;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Combo Offers',
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          final totalAmount = cartProvider.getTotalAmount(products);

          final double screenWidth = MediaQuery.of(context).size.width;
          final bool isDesktop = screenWidth >= 1024;
          final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
          final bool isMobile = screenWidth < 600;

          // Dynamic sizing
          final double barHeight = isDesktop
              ? 110
              : isTablet
                  ? 90
                  : 80;
          final double paddingH = isDesktop
              ? 32
              : isTablet
                  ? 20
                  : 16;
          final double paddingV = isDesktop
              ? 16
              : isTablet
                  ? 12
                  : 10;
          final double priceTitleFont = isDesktop
              ? 18
              : isTablet
                  ? 16
                  : 15;
          final double priceValueFont = isDesktop
              ? 20
              : isTablet
                  ? 18
                  : 16;
          final double buttonFont = isDesktop
              ? 18
              : isTablet
                  ? 17
                  : 16;
          final double buttonPaddingH = isDesktop
              ? 36
              : isTablet
                  ? 30
                  : 28;
          final double buttonPaddingV = isDesktop
              ? 18
              : isTablet
                  ? 16
                  : 14;

          return Container(
            height: barHeight,
            padding:
                EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
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
            child: Row(
              children: [
                // Price Box
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 16 : 12,
                    vertical: isDesktop ? 10 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppColor.primaryColor,
                            AppColor.primaryColor
                          ],
                        ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                        child: Text(
                          'Price',
                          style: AppStyle.textStyleReemKufi.copyWith(
                            color: Colors.white,
                            fontSize: priceTitleFont,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppColor.primaryColor,
                            AppColor.primaryColor
                          ],
                          stops: [0.10, 0],
                        ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                        child: Text(
                          '₹${subTotal.toStringAsFixed(2)}',
                          style: AppStyle.textStyleReemKufi.copyWith(
                            color: Colors.white,
                            fontSize: priceValueFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 15),

                // Cart Button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ViewOrderScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.whiteColor,
                        foregroundColor: AppColor.whiteColor,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: buttonPaddingH,
                          vertical: buttonPaddingV,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppColor.primaryColor,
                            AppColor.primaryColor
                          ],
                          stops: [0.60, 0],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomRight,
                        ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                        child: Text(
                          'Go To Cart',
                          style: AppStyle.textStyleReemKufi.copyWith(
                            color: Colors.white,
                            fontSize: buttonFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(children: [
           Padding(
            padding: EdgeInsets.all(15.0),
            child: SearchCartRow(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Consumer<CategoryProvider>(
              builder: (context, provider, child) {
                final products = provider.comboProduct;
                final size = MediaQuery.of(context).size;
                final imageSize = size.width * 0.15;
                final badgeSize = size.width * 0.10;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  key: ValueKey(provider.selectedCategoryId),
                  itemCount: products?.length,
                  itemBuilder: (context, index) {
                    final product = products?[index];
                   // final quantity = cartProvider.getQuantity(product.id);

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 800),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.35),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 100.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Combo offers",
                                            style: AppStyle.textStyleLobster
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "SAVE 30%",
                                            style: AppStyle.textStyleLobster
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              foreground: Paint()
                                                ..shader = const LinearGradient(
                                                  colors: [
                                                    AppColor.secondary,
                                                    AppColor.primaryColor,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ).createShader(
                                                  const Rect.fromLTWH(
                                                      0.0, 0.0, 200.0, 70.0),
                                                ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Images Row
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: List.generate(
                                    //     product?.images.length * 2 - 1,
                                    //     (i) {
                                    //       if (i.isEven) {
                                    //         final img = product.images[i ~/ 2];
                                    //         return Container(
                                    //           height: imageSize,
                                    //           width: imageSize,
                                    //           margin:
                                    //               const EdgeInsets.symmetric(
                                    //                   horizontal: 4),
                                    //           decoration: BoxDecoration(
                                    //             color: Colors.white,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(20),
                                    //             border: Border.all(
                                    //               color: Colors.grey.shade300,
                                    //               width: 1.5,
                                    //             ),
                                    //             image: DecorationImage(
                                    //               image: NetworkImage(img),
                                    //               fit: BoxFit.cover,
                                    //             ),
                                    //           ),
                                    //         );
                                    //       } else {
                                    //         return Padding(
                                    //           padding:
                                    //               const EdgeInsets.symmetric(
                                    //                   horizontal: 4),
                                    //           child: ShaderMask(
                                    //             shaderCallback: (bounds) =>
                                    //                 const LinearGradient(
                                    //               colors: [
                                    //                 AppColor.secondary,
                                    //                 AppColor.primaryColor,
                                    //               ],
                                    //               begin: Alignment.topLeft,
                                    //               end: Alignment.bottomRight,
                                    //             ).createShader(
                                    //               Rect.fromLTWH(
                                    //                   0,
                                    //                   0,
                                    //                   bounds.width,
                                    //                   bounds.height),
                                    //             ),
                                    //             child: const Icon(
                                    //               Icons.add,
                                    //               size: 35,
                                    //               color: Colors.white,
                                    //             ),
                                    //           ),
                                    //         );
                                    //       }
                                    //     },
                                    //   ),
                                    // ),

                                    const SizedBox(height: 10),
                                    Text(
                                      '₹${double.parse(product?.price ?? '0').toStringAsFixed(2)}',

                                      style:
                                          AppStyle.textStyleReemKufi.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppColor.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -10,
                                left: 5,
                                child: Image.asset(
                                  AppImage.badge1,
                                  width: badgeSize,
                                ),
                              ),
                              // Positioned Add Button
                              Positioned(
                                bottom: 18,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                   // showBurgerDialog(context, product);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.secondary,
                                          AppColor.primaryColor
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        stops: [0, 0.60],
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: const Icon(Icons.add,
                                        color: Colors.white, size: 22),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  void showBurgerDialog(BuildContext context, ComboProductModel product) {
    final selectedProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    selectedProvider.setBasePrice(product.price.toDouble());

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double buttonFontSize = isDesktop ? 25 : isTablet ? 17 : 16;
    final double priceSize = isDesktop ? 27 : isTablet ? 17 : 17;
    final double description = isDesktop ? 20 : isTablet ? 15 : 15;
    // Check if product is already in cart and get current quantity
    final cartItem = cartProvider.getCartItemById(product.id);
    if (cartItem != null) {
      // Set dialog quantity to existing cart quantity
      selectedProvider.setQuantity(cartItem.quantity);
    } else {
      // Or set default quantity
      selectedProvider.setQuantity(1);
    }

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

                    return Material(
                      color: Colors.transparent,
                      child: Container(
                        width: screenWidth,
                        constraints: BoxConstraints(
                          maxHeight: screenHeight * 0.95,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.whiteColor,
                              AppColor.whiteColor,
                              AppColor.whiteColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [
                              0.0,
                              0.2,
                              1.0
                            ], // <- this controls how much of the top is secondary
                          ),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: screenHeight * 0.30,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.secondary,
                                    AppColor.primaryColor
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final screenWidth = constraints.maxWidth;
                                  final screenHeight = constraints.maxHeight;

                                  // Count both images and add icons (total items)
                                  final totalItems = product.images.length * 2 - 1;

                                  // Calculate image size so all items fit into screen width
                                  final spacing = 8.0; // fixed spacing
                                  final imageSize =
                                      (screenWidth - (spacing * (totalItems - 1))) / totalItems;

                                  return Container(
                                    height: imageSize + 40,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [AppColor.secondary, AppColor.primaryColor],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: List.generate(totalItems, (index) {
                                                if (index.isEven) {
                                                  final img = product.images[index ~/ 2];
                                                  return Container(
                                                    width: imageSize,
                                                    height: imageSize,
                                                    margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      image: DecorationImage(
                                                        image: NetworkImage(img),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Icon(Icons.add, size: 20, color: Colors.white);

                                                }
                                              }),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 16,
                                          top: 16,
                                          child: GestureDetector(
                                            onTap: () => Navigator.of(context).pop(),
                                            child: const Icon(Icons.close, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                            ),

                            // 🟡 BODY (Scrollable)
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
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
                                     SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              product.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppStyle.textStyleReemKufi
                                                  .copyWith(
                                                color: AppColor.blackColor,
                                                fontSize: priceSize,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "₹${product.price.toStringAsFixed(2)}",
                                            style: AppStyle.textStyleReemKufi
                                                .copyWith(
                                              color: AppColor.blackColor,
                                              fontSize: priceSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.015),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "Tomato, Lettuce, Onions",
                                              style: AppStyle.textStyleReemKufi
                                                  .copyWith(
                                                      color: AppColor.greyColor,
                                                      fontSize: 15),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "14 mins",
                                            style: AppStyle.textStyleReemKufi
                                                .copyWith(
                                                    color: AppColor.greyColor,
                                                    fontSize: 15),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: screenHeight * 0.025),

                                      // 🟡 Spicy + Portion
                                      Row(
                                        children: [
                                          Expanded(
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
                                                      fontSize: buttonFontSize,
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
                                                              FontWeight.w600,
                                                          fontSize: description,
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
                                                              FontWeight.w600,
                                                          fontSize: description,
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
                                                              FontWeight.w600,
                                                          fontSize: description,
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
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Portion",
                                                      style: AppStyle
                                                          .textStyleReemKufi
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: buttonFontSize,
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
                                                        Text(
                                                          "${selectedProvider.quantity}",
                                                          style: AppStyle
                                                              .textStyleReemKufi
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 20,
                                                          ),
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

                            // 🟡 Footer: Total Price + Add to Cart
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
                                  // Price box
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
                                          ]).createShader(Rect.fromLTWH(0, 0,
                                                  bounds.width, bounds.height)),
                                          child: Text('Price',
                                              style: AppStyle.textStyleReemKufi
                                                  .copyWith(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              )),
                                        ),
                                        ShaderMask(
                                          shaderCallback: (bounds) =>
                                              const LinearGradient(colors: [
                                            AppColor.primaryColor,
                                            AppColor.primaryColor
                                          ]).createShader(Rect.fromLTWH(0, 0,
                                                  bounds.width, bounds.height)),
                                          child: Text(
                                              '₹${selectedProvider.totalPrice.toStringAsFixed(2)}',
                                              style: AppStyle.textStyleReemKufi
                                                  .copyWith(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        )
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print(
                                              "Images in product: ${product.images}");

                                          final cartProvider =
                                              Provider.of<CartProvider>(context,
                                                  listen: false);
                                          final cartItem = CartItemModel(
                                              id: product.id,
                                              name: product.name,
                                              images: product.images,
                                              categoryId: product.categoryId,
                                              price: selectedProvider
                                                  .selectedPrice,
                                              quantity:
                                                  selectedProvider.quantity,
                                              isCombo: true);
                                          cartProvider.addToCart(cartItem);
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
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
                                          ).createShader(Rect.fromLTWH(0, 0,
                                                  bounds.width, bounds.height)),
                                          child: Text(
                                            'Add To Cart',
                                            style: AppStyle.textStyleReemKufi
                                                .copyWith(
                                              color: Colors.white,
                                              fontSize: 16,
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



  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
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
        icon: Icon(icon),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              activeTrackColor:
                  AppColor.primaryColor, // Hide default active track color
              inactiveTrackColor:
                  Colors.grey, // Hide default inactive track color

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

class SearchCartRow extends StatelessWidget {
  final int cartItemCount;

  SearchCartRow({super.key, this.cartItemCount = 4});
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Box
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade50, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child:  TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontFamily: 'Reem Kufi',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(Icons.search, color: AppColor.primaryColor),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                border: InputBorder.none, // Disable TextField's internal border
              ),
              onChanged: (value) {
                Provider.of<CategoryProvider>(context, listen: false)
                    .getComboProduct(context,_controller.text);
              },
            ),
          ),
        ),


        const SizedBox(width: 8),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.primaryColor),
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                AppColor.secondary,
                AppColor.primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, color: AppColor.whiteColor),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}