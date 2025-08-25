import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ravathi_store/models/product_model.dart';
import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/views/selection_screen.dart';
import 'package:ravathi_store/views/view_order_screen.dart';

import '../models/category_models.dart';
import '../models/items_model.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/dashboard_provider.dart';
import '../urls/api_endpoints.dart';
import '../utlis/App_style.dart';
import '../utlis/widgets/shimmer_loading.dart';
import 'buy_one_get_one.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'combo.dart';
import 'combo_offer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    print("sreya");
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    provider.selectCategory(-1); // preselect All
    provider.getCategoryBasedItems(context, null); // load all items initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false)
          .getBannerImage(context);

      Provider.of<DashboardProvider>(context, listen: false)
          .getCategoryBasedItems(context,null);

      Provider.of<DashboardProvider>(context, listen: false)
          .getCategorys(context);
    });
  }
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<CategoryProvider>(context);
    final categories = provider.categories;
    final products = provider.selectedCategoryProducts;
    final cartProvider = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    double subTotal = cartProvider.subTotal;

    double searchHeight = screenWidth * 0.05;
    double fontSize = screenWidth * 0.018; // 1.8% of width
    double hintFontSize = screenWidth * 0.017;
    double iconSize = screenWidth * 0.025;
    double filterBtnSize = screenWidth * 0.055;
    double filterIconSize = screenWidth * 0.025;
    double horizontalPadding = screenWidth * 0.010;
    return SafeArea(
      child: PopScope(
        canPop: false, // prevent direct pop
        onPopInvoked: (didPop) async {
          if (didPop) return;

          final shouldExit = await showExitDialog(context);

          if (shouldExit) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(

              toolbarHeight: isDesktop
                  ? 100
                  : isTablet
                      ? 100
                      : 70,
              automaticallyImplyLeading: false,
              centerTitle: false,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (cartProvider.items.isNotEmpty) {
                          final shouldExit = await showExitDialog(context);
                          if (shouldExit) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SelectionScreen()),
                            );
                          }
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SelectionScreen()),
                          );
                        }
                      },
                      child: Image.asset(
                        AppImage.logo3,
                        height: isDesktop
                            ? 180
                            : isTablet
                                ? 180
                                : 90,
                      ),
                    ),

                    Expanded(
                      child: Container(
                        height: searchHeight.clamp(50, 60),
                        margin:
                            EdgeInsets.symmetric(horizontal: horizontalPadding),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ), // horizontal padding inside container
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: iconSize.clamp(18, 28),
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                textAlign: TextAlign.start,
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: fontSize.clamp(14, 20),
                                  color: AppColor.blackColor,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle:
                                      AppStyle.textStyleReemKufi.copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: hintFontSize.clamp(14, 20),
                                    color: AppColor.blackColor.withOpacity(0.6),
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.zero, // remove extra padding
                                ),
                                onChanged: (value) {
                                  Provider.of<DashboardProvider>(context, listen: false)
                                      .getSearchProduct(context,_controller.text);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Filter button
                    Container(
                      margin: EdgeInsets.all(horizontalPadding),
                      height: filterBtnSize.clamp(36, 55),
                      width: filterBtnSize.clamp(36, 55),
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
                        icon: Icon(
                          Icons.tune,
                          size: filterIconSize.clamp(18, 28),
                          color: AppColor.whiteColor,
                        ),
                        onPressed: () {
                          // Filter action here
                        },
                      ),
                    ),

                    SizedBox(width: horizontalPadding),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                if (cartProvider.items.isEmpty) {
                  return const SizedBox.shrink(); // empty widget
                }
                final totalAmount = cartProvider.getTotalAmount(products);

                final double screenWidth = MediaQuery.of(context).size.width;
                final bool isDesktop = screenWidth >= 1024;
                final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
                final bool isMobile = screenWidth < 600;

                // Dynamic sizes based on device type
                final double barHeight = isDesktop
                    ? 110
                    : isTablet
                        ? 90
                        : 80;
                final double paddingHorizontal = isDesktop
                    ? 40
                    : isTablet
                        ? 24
                        : 16;
                final double paddingVertical = isDesktop
                    ? 16
                    : isTablet
                        ? 12
                        : 10;
                final double titleFontSize = isDesktop
                    ? 18
                    : isTablet
                        ? 16
                        : 15;
                final double priceFontSize = isDesktop
                    ? 20
                    : isTablet
                        ? 18
                        : 16;
                final double buttonFontSize = isDesktop
                    ? 22
                    : isTablet
                        ? 17
                        : 16;
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
                                colors: [
                                  AppColor.primaryColor,
                                  AppColor.primaryColor
                                ],
                              ).createShader(Rect.fromLTWH(
                                  0, 0, bounds.width, bounds.height)),
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
                                colors: [
                                  AppColor.primaryColor,
                                  AppColor.primaryColor
                                ],
                                stops: [0.10, 0],
                              ).createShader(Rect.fromLTWH(
                                  0, 0, bounds.width, bounds.height)),
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
                                colors: [
                                  AppColor.primaryColor,
                                  AppColor.primaryColor
                                ],
                                stops: [0.60, 0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomRight,
                              ).createShader(Rect.fromLTWH(
                                  0, 0, bounds.width, bounds.height)),
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
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildPromoCard(
                            badgeText: AppImage.badge,
                            title: "BOGO SALE is ON!",
                            subtitle: "Add two items to cart —pay \nfor one!",
                            imagePath:
                                'https://img.pikbest.com/origin/09/17/77/71vpIkbEsTIN8.png!sw800',
                            context: context,
                            onTap: () {
                              print("buyonegetone");
                              Future.delayed(Duration.zero, () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => BuyOneGetOne()),
                                );
                              });
                            },
                          ),
                          _buildPromoCard(
                            badgeText: AppImage.badge1,
                            title: "Special Combo Deal!",
                            subtitle: "Shop the Combo & Save More!",
                            imagePath:
                                'https://img.pikbest.com/origin/09/17/77/71vpIkbEsTIN8.png!sw800',
                            context: context,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Combo()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Consumer<DashboardProvider>(
                      builder: (context, provider, child) {
                        // Determine the number of placeholders
                        final placeholderCount = provider.categoryList?.length ?? 6;

                        if (provider.isLoading) {
                          return SizedBox(
                            height: 100,
                            child: ListView.builder(
                              itemCount: placeholderCount,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: ShimmerWidget.rectangular(
                                  width: double.infinity,
                                  height: 80, // Match your category card height
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
                        }

                        final data = provider.categoryList;

                        if (data == null || data.isEmpty) {
                          return const Center(child: Text("No categories found"));
                        }

                        return buildCategoryList(categories: data);
                      },
                    )

                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Product Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Selector<DashboardProvider, List<Item>>(
                          selector: (_, provider) => provider.items ?? [],
                        builder: (context, products, child) {
                       // final products = provider.items ?? [];
                        if (provider.isLoading) {
                          // Show shimmer placeholders
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              double screenWidth = constraints.maxWidth;

                              int crossAxisCount;
                              double aspectRatio;

                              if (screenWidth >= 1000) {
                                crossAxisCount = 4;
                                aspectRatio = 0.95;
                              } else if (screenWidth >= 700) {
                                crossAxisCount = 3;
                                aspectRatio = 0.85;
                              } else {
                                crossAxisCount = 2;
                                aspectRatio = 0.74;
                              }

                              final placeholderCount = products.isNotEmpty ? products.length : 6;

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: placeholderCount,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: aspectRatio * 0.9,
                                ),
                                itemBuilder: (context, index) {
                                  return ShimmerWidget.rectangular(
                                    width: double.infinity,
                                    height: double.infinity,
                                    borderRadius: BorderRadius.circular(16),
                                  );
                                },
                              );
                            },
                          );
                        }

                        if (products.isEmpty) {
                          return const Center(child: Text("No products found"));
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            double screenWidth = constraints.maxWidth;

                            int crossAxisCount;
                            double aspectRatio;

                            if (screenWidth >= 1000) {
                              crossAxisCount = 4;
                              aspectRatio = 0.95;
                            } else if (screenWidth >= 700) {
                              crossAxisCount = 3;
                              aspectRatio = 0.85;
                            } else {
                              crossAxisCount = 2;
                              aspectRatio = 0.74;
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: aspectRatio * 0.9,
                              ),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final quantity = cartProvider.getQuantity(product.id);

                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  columnCount: crossAxisCount,
                                  duration: const Duration(milliseconds: 800),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Stack(
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
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  AspectRatio(
                                                    aspectRatio: 1.2,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.network(
                                                        "${ApiEndpoints.imageBaseUrl}${product.image}", // prepend baseUrl
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) =>
                                                        const Icon(Icons.image_not_supported),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    product.name,
                                                    style: AppStyle.textStyleReemKufi.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    product.description ?? "", // show description
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
                                                      product.price != null
                                                          ? '₹${product.price}'
                                                          : "0",
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

                                          // Add icon in bottom-right corner
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                showBurgerDialog(context, product);
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
                        );
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )),
      ),
    );
  }





  Widget _buildPromoCard({
    required String badgeText,
    required String title,
    required String subtitle,
    required String imagePath,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (screenWidth - 36) / 2; // 12 (left) + 12 (between) + 12 (right)
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.secondary, AppColor.primaryColor],
            begin: AlignmentDirectional(0.0, -1.0), // top-center
            end: AlignmentDirectional(0.0, 1.0), // bottom-center
      
            stops: [0.0, 1.0], // smooth gradient
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -15,
              left: 0,
              child: Image.asset(
                badgeText,
                height: isDesktop
                    ? 80
                    : isTablet
                        ? 65
                        : 50, // scale by device type
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppStyle.textStyleLobster.copyWith(
                      color: AppColor.whiteColor,
                      fontSize: isDesktop
                          ? 22
                          : isTablet
                              ? 18 // Tablet font size
                              : 15,
                      fontWeight: isTablet
                          ? FontWeight.w600 // Slightly bolder on tablet
                          : FontWeight.normal,
                    ),
                  ),
      
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          subtitle,
                          style: AppStyle.textStyleReemKufi.copyWith(
                            color: Colors.white,
                            fontSize: isDesktop
                                ? 22
                                : isTablet
                                    ? 16 // Tablet font size
                                    : 12,
                            fontWeight:
                                isTablet ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.network(
                        imagePath,
                        height: 100,
                        width: 100,
                      ),
                    ],
                  ),
                  //const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: AppColor.primaryColor,
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop
                                ? 32
                                : isTablet
                                    ? 24
                                    : 15, // Wider on large screens
                            vertical: isDesktop
                                ? 14
                                : isTablet
                                    ? 12
                                    : 8,
                          ),
                        ),
                        child: Text(
                          "Buy Now",
                          style: AppStyle.textStyleReemKufi.copyWith(
                            color: AppColor.primaryColor,
                            fontSize: isDesktop
                                ? 20
                                : isTablet
                                    ? 18
                                    : 16, // Bigger font for bigger screens
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
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
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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

  void showBurgerDialog(BuildContext context, Item product) {
    final selectedProvider =
        Provider.of<CategoryProvider>(context, listen: false);
   // selectedProvider.setBasePrice(product.price);

    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Set base price
    //selectedProvider.setBasePrice(product.price);
    selectedProvider.setBasePrice(
      double.tryParse(product.price ?? '0') ?? 0.0,
    );
    selectedProvider.setSelectedChildCategory(null);
    selectedProvider.setQuantity(1); // reset quantity
    // Check if product is already in cart and get current quantity
    final cartItem = cartProvider.getCartItemById(product.id);
    if (cartItem != null) {
      // Set dialog quantity to existing cart quantity
      selectedProvider.setQuantity(cartItem.quantity);
    } else {
      // Or set default quantity
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
                                      child:  Image.network(
                                          "${ApiEndpoints.imageBaseUrl}${product.image}", // prepend baseUrl
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.image_not_supported),
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
                                      SizedBox(
                                        height: 15,
                                      ),
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
                                            "₹${(double.tryParse(product.price ?? '0') ?? 0.0).toStringAsFixed(2)}",

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
                                            product.description,
                                              style: AppStyle.textStyleReemKufi
                                                  .copyWith(
                                                      color: AppColor.greyColor,
                                                      fontSize: description),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            product.time != null ? '${product.time} mins' : '',
                                            style: AppStyle.textStyleReemKufi.copyWith(
                                              color: AppColor.greyColor,
                                              fontSize: 15,
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.025),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: product.childCategory?.map((child) {
                                        //  final selectedSize =context.watch<CategoryProvider>().selectedSize;
                                          final selectedChild = context.watch<CategoryProvider>().selectedChildCategory;
                                          return _buildOptionBox(
                                            child.name, // 👈 dynamic name from API
                                            "₹${(child.price ?? 0).toStringAsFixed(0)}", // 👈 dynamic price from API
                                            isSelected: selectedChild?.id == child.id,
                                            onTap: () {
                                              context.read<CategoryProvider>().setSelectedChildCategory(child);
                                            },
                                          );
                                        }).toList() ?? [],
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
                                                fontSize: isDesktop ? 17 : 16,
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
                                                fontSize: isDesktop ? 17 : 16,
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
                                          final selectedChild = context.read<CategoryProvider>().selectedChildCategory; // ✅ use read

                                          final cartProvider = context.read<CartProvider>(); // ✅ same here
                                          final selectedProvider = context.read<CategoryProvider>(); // or your actual provider

                                          final cartItem = CartItemModel(
                                            id: product.id,
                                            name: product.name,
                                            images: [product.image],
                                            categoryId: product.categoryId,
                                            price:
                                                selectedProvider.selectedPrice,
                                            quantity: selectedProvider.quantity,
                                            takeAwayPrice: selectedChild?.takeAwayPrice,
                                            subCategoryId: selectedChild?.subCategoryId ?? 0,
                                            childCategoryId: selectedChild?.id.toString(),      // 👈 pass child id if selected
                                            childCategoryName: selectedChild?.name,  // 👈 pass child name if selected
                                            isCombo: null,
                                          );
                                          cartProvider.addToCart(cartItem);
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.whiteColor,
                                          foregroundColor: AppColor.whiteColor,
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


  Widget buildCategoryList({
    required List<CategoryModel> categories,
  }) {


    final allCategories = [
      CategoryModel(id: -1, name: 'All', image: ''), // empty image for placeholder
      ...categories,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        if (screenWidth < 600) {
          return SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allCategories.length,
              itemBuilder: (context, index) {
                return _buildCategoryItem(
                  context,
                  allCategories[index],
                );
              },
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: allCategories
                  .map((cat) => _buildCategoryItem(
                context,
                cat,
                fixedSize: 90,
              ))
                  .toList(),
            ),
          );
        }
      },
    );
  }



  Widget _buildCategoryItem(
      BuildContext context,
      CategoryModel cat, {
        double? fixedSize,
      }) {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    final isSelected = provider.selectedCategoryId == cat.id;
    return GestureDetector(

      onTap: () async {
        provider.selectCategory(cat.id);
        await provider.getCategoryBasedItems(
          context,
           cat.id == -1 ? null : cat.id, // null for "All"
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: fixedSize ?? 70,
              height: fixedSize ?? 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: isSelected
                    ? LinearGradient(
                  colors: [
                    AppColor.secondary.withOpacity(0.7),
                    AppColor.primaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.6],
                )
                    : null,
                color: isSelected ? null : Colors.grey.shade200,
              ),
              padding: const EdgeInsets.all(8),
              child: ClipOval(
                child: Image.network(
                  "${ApiEndpoints.imageBaseUrl}${cat.image}", // ✅ prepend baseUrl
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              cat.name,
              style: AppStyle.textStyleReemKufi.copyWith(
                color: isSelected ? AppColor.primaryColor : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }


// Widget buildCategoryList({
  //   required List<CategoryModel> categories,
  //
  // }) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       double screenWidth = constraints.maxWidth;
  //
  //       // Use horizontal scroll on small screens
  //       if (screenWidth < 600) {
  //         return SizedBox(
  //           height: 120,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: categories.length,
  //             itemBuilder: (context, index) {
  //               return _buildCategoryItem(
  //                 context,
  //                 categories[index],
  //                 selectedCategoryId,
  //                 onCategorySelected,
  //               );
  //             },
  //           ),
  //         );
  //       } else {
  //         // Use Wrap/Grid on wider screens
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 8),
  //           child: Wrap(
  //             spacing: 16,
  //             runSpacing: 16,
  //             children: categories
  //                 .map((cat) => _buildCategoryItem(
  //                       context,
  //                       cat,
  //                       selectedCategoryId,
  //                       onCategorySelected,
  //                       fixedSize: 90,
  //                     ))
  //                 .toList(),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  // Widget _buildCategoryItem(
  //   BuildContext context,
  //   CategoryModel cat,
  //   int selectedCategoryId,
  //   Function(int) onCategorySelected, {
  //   double? fixedSize,
  // }) {
  //   final isSelected = cat.id == selectedCategoryId;
  //
  //   return GestureDetector(
  //     onTap: () => onCategorySelected(cat.id),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             width: fixedSize ?? 70,
  //             height: fixedSize ?? 70,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(15),
  //               gradient: isSelected
  //                   ? LinearGradient(
  //                       colors: [
  //                         AppColor.secondary.withOpacity(0.7),
  //                         AppColor.primaryColor,
  //                       ],
  //                       begin: Alignment.topLeft,
  //                       end: Alignment.bottomRight,
  //                       stops: [0.1, 0.60],
  //                     )
  //                   : null,
  //               color: isSelected ? null : Colors.grey.shade200,
  //             ),
  //             padding: const EdgeInsets.all(8),
  //             child: ClipOval(
  //               child: Image.network(
  //                 cat.image,
  //                 fit: BoxFit.cover,
  //                 errorBuilder: (context, error, stackTrace) =>
  //                     const Icon(Icons.image_not_supported),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 6),
  //           Text(
  //             cat.name,
  //             style: AppStyle.textStyleReemKufi.copyWith(
  //               color: isSelected ? AppColor.primaryColor : Colors.black87,
  //               fontWeight: FontWeight.w500,
  //               fontSize: 13,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class SearchCartRow extends StatelessWidget {
  final int cartItemCount;

  const SearchCartRow({super.key, this.cartItemCount = 4});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search Box
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search your favourite here..',
              hintStyle: const TextStyle(
                fontFamily: 'Reem Kufi',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.grey,
              ),
              prefixIcon:
                  const Icon(Icons.search, color: AppColor.primaryColor),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.lightGreyColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: AppColor.lightGreyColor, width: 1.5),
              ),
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

Future<bool> showExitDialog(BuildContext context) async {
  final shouldExit = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Exit App",
        style: AppStyle.textStyleReemKufi.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColor.primaryColor,
          fontSize: 18,
          height: 1.0,
        ),
      ),
      content: Text(
        "Are you sure you want to exit?",
        style: AppStyle.textStyleReemKufi.copyWith(
          fontWeight: FontWeight.w300,
          color: AppColor.blackColor,
          fontSize: 18,
          height: 1.0,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            "Cancel",
            style: AppStyle.textStyleReemKufi.copyWith(
              fontWeight: FontWeight.w300,
              color: AppColor.blackColor,
              fontSize: 14,
              height: 1.0,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Call clearCart from provider
            context.read<CartProvider>().clearCart();

            // Then close the dialog
            Navigator.of(context).pop(true);
          },
          child: Text(
            "Exit",
            style: AppStyle.textStyleReemKufi.copyWith(
              fontWeight: FontWeight.w300,
              color: AppColor.primaryColor,
              fontSize: 14,
              height: 1.0,
            ),
          ),
        ),
      ],
    ),
  );

  return shouldExit ?? false;
}
