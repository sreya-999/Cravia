import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/views/view_order_screen.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import '../providers/dashboard_provider.dart';
import '../urls/api_endpoints.dart';
import '../utlis/App_color.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../utlis/App_style.dart';
import '../utlis/widgets/custom_appbar.dart';

class BuyOneGetOne extends StatefulWidget {
  const BuyOneGetOne({super.key});

  @override
  State<BuyOneGetOne> createState() => _BuyOneGetOneState();
}

class _BuyOneGetOneState extends State<BuyOneGetOne> {

  void initState() {
    super.initState();
    print("sreya");

    WidgetsBinding.instance.addPostFrameCallback((_) {

      final categoryProvider =
      Provider.of<CategoryProvider>(context, listen: false);

      categoryProvider.getOffer(context, null);
    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    final products = provider.selectedCategoryProducts;
    final cartProvider = Provider.of<CartProvider>(context);
    double subTotal = cartProvider.subTotal;
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: const CustomAppBar(
      title: 'Buy one Get one',
    ),
        bottomNavigationBar: Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
            final totalAmount = cartProvider.getTotalAmount(products);

            final double screenWidth = MediaQuery.of(context).size.width;
            final bool isDesktop = screenWidth >= 1024;
            final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
            final bool isMobile = screenWidth < 600;

            // Dynamic sizes based on device type
            final double barHeight = isDesktop ? 110 : isTablet ? 90 : 80;
            final double paddingHorizontal = isDesktop ? 40 : isTablet ? 24 : 16;
            final double paddingVertical = isDesktop ? 16 : isTablet ? 12 : 10;
            final double titleFontSize = isDesktop ? 18 : isTablet ? 16 : 15;
            final double priceFontSize = isDesktop ? 20 : isTablet ? 18 : 16;
            final double buttonFontSize = isDesktop ? 22 : isTablet ? 17 : 16;
            final double buttonPaddingH = isDesktop ? 36 : isTablet ? 32 : 28;
            final double buttonPaddingV = isDesktop ? 18 : isTablet ? 16 : 14;

            return Container(
              height: barHeight,
              padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
                vertical: paddingVertical,
              ),
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
                            colors: [AppColor.primaryColor, AppColor.primaryColor],
                          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          child: Text(
                            'Price',
                            style: AppStyle.textStyleReemKufi.copyWith(
                              color: Colors.white,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColor.primaryColor, AppColor.primaryColor],
                            stops: [0.10, 0],
                          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          child: Text(
                            '₹${subTotal.toStringAsFixed(2)}',
                            style: AppStyle.textStyleReemKufi.copyWith(
                              color: Colors.white,
                              fontSize: priceFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                            colors: [AppColor.primaryColor, AppColor.primaryColor],
                            stops: [0.60, 0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          child: Text(
                            'Go To Cart',
                            style: AppStyle.textStyleReemKufi.copyWith(
                              color: Colors.white,
                              fontSize: buttonFontSize,
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

        body:  SingleChildScrollView(

        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           Padding(
            padding: EdgeInsets.all(15.0),
            child: SearchCartRow(),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Consumer<CategoryProvider>(
            builder: (context, provider, child) {
              final products = provider.buyOneGetOne;
        if (products == null) {
                       return const Center(child: CircularProgressIndicator());
                    }
                    if (products.isEmpty) {
                      return const Center(child: Text("No products available"));
                    }
              return LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;

                  // Dynamic columns, aspect ratio, and image height
                  int crossAxisCount;
                  double aspectRatio;
                  double imageHeight;

                  if (screenWidth >= 1000) {
                    crossAxisCount = 4;
                    aspectRatio = 0.95;
                    imageHeight = 180;
                  } else if (screenWidth >= 700) {
                    crossAxisCount = 3;
                    aspectRatio = 0.85;
                    imageHeight = 150;
                  } else {
                    crossAxisCount = 2;
                    aspectRatio = 0.74;
                    imageHeight = 120;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products?.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: aspectRatio * 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final product = products?[index];

                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: crossAxisCount,
                        duration: const Duration(milliseconds: 800),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child:Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Product card container
                                Container(
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1.2,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              "${ApiEndpoints.imageBaseUrl}${product?.image}", // ✅ prepend baseUrl
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.image_not_supported),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          product?.name.toString() ?? '',
                                          style: AppStyle.textStyleReemKufi.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                        product?.description.toString() ?? '',
                                          textAlign: TextAlign.center,
                                          style: AppStyle.textStyleReemKufi.copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: AppColor.blackColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            '₹${double.parse(product?.price ?? '0').toStringAsFixed(2)}',

                                            style: AppStyle.textStyleReemKufi.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color: AppColor.blackColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Add icon exactly in bottom-right corner
                                Positioned(
                                  bottom: 0,
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
                                          colors: [AppColor.secondary, AppColor.primaryColor],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0, 0.60],
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(14),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: const Icon(Icons.add, color: Colors.white, size: 22),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
         ),
              SizedBox(height: 30,)
        ]),
      ),
    );
  }

  void showBurgerDialog(BuildContext context, ProductModel product) {
    final selectedProvider =
    Provider.of<CategoryProvider>(context, listen: false);
    selectedProvider.setBasePrice(product.price);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double buttonFontSize = isDesktop ? 25 : isTablet ? 17 : 16;
    final double priceSize = isDesktop ? 27 : isTablet ? 17 : 17;
    final double description = isDesktop ? 20 : isTablet ? 15 : 15;
    // Set base price
    selectedProvider.setBasePrice(product.price);

    final cartItem = cartProvider.getCartItemById(product.id);
    if (cartItem != null) {

      selectedProvider.setQuantity(cartItem.quantity);
    } else {

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
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),

                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(80)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          product.image,
                                          //fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 16,
                                    top: 16,
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: const Icon(Icons.close,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
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
                                      SizedBox(height: 15,),// Title + Price
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

                                      // 🟡 Size options
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: _buildOptionBox(
                                              "Small",
                                              "₹${product.price.toStringAsFixed(0)}",
                                              isSelected: context
                                                  .watch<CategoryProvider>()
                                                  .selectedSize ==
                                                  "Small",
                                              onTap: () {
                                                context
                                                    .read<CategoryProvider>()
                                                    .setSelectedSize("Small");
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: _buildOptionBox(
                                              "Medium",
                                              "₹${(product.price + 10).toStringAsFixed(0)}",
                                              isSelected: context
                                                  .watch<CategoryProvider>()
                                                  .selectedSize ==
                                                  "Medium",
                                              onTap: () {
                                                context
                                                    .read<CategoryProvider>()
                                                    .setSelectedSize("Medium");
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: _buildOptionBox(
                                              "Large",
                                              "₹${(product.price + 20).toStringAsFixed(0)}",
                                              isSelected: context
                                                  .watch<CategoryProvider>()
                                                  .selectedSize ==
                                                  "Large",
                                              onTap: () {
                                                context
                                                    .read<CategoryProvider>()
                                                    .setSelectedSize("Large");
                                              },
                                            ),
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
                                                    SizedBox(
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
                                          final cartProvider =
                                          Provider.of<CartProvider>(context,
                                              listen: false);
                                          final cartItem = CartItemModel(
                                            id: product.id,
                                            name: product.name,
                                            images: [product.image],
                                            categoryId: product.categoryId,
                                            price:
                                            selectedProvider.selectedPrice,
                                            quantity: selectedProvider.quantity,
                                            isCombo: false
                                          );
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

  Widget _buildOptionBox(
      String title,
      String price, {

        required bool isSelected,
        required VoidCallback onTap,
      }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double priceSize = isDesktop ? 20 : isTablet ? 17 : 14;
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: AppStyle.textStyleReemKufi.copyWith(
                    fontSize: priceSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
            BorderRadius.circular(14), // slightly bigger for border
          ),
          child: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child:
                Text(
                  title,
                  style: AppStyle.textStyleReemKufi.copyWith(
                    fontSize: priceSize,
                    fontWeight: FontWeight.bold,
                    color: AppColor.blackColor,
                  ),
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
              decoration: const InputDecoration(
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
                    .getOffer(context,_controller.text);
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
