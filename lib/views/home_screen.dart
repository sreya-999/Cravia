import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ravathi_store/models/product_model.dart';
import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/views/selection_screen.dart';
import 'package:ravathi_store/views/view_order_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/category_models.dart';
import '../models/items_model.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/dashboard_provider.dart';
import '../urls/api_endpoints.dart';
import '../utlis/App_style.dart';
import '../utlis/share_preference_helper/sharereference_helper.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String orderText = "Dine In"; // default
  String orderImage = AppImage.dinein; // default

  //@override
  // void initState() {
  //   super.initState();
  //   print("sreya");
  //   final provider = Provider.of<DashboardProvider>(context, listen: false);
  //   provider.selectCategory(-1); // preselect All
  //   provider.getCategoryBasedItems(context, null,null); // load all items initially
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<DashboardProvider>(context, listen: false)
  //         .getBannerImage(context);
  //
  //     Provider.of<DashboardProvider>(context, listen: false)
  //         .getCategoryBasedItems(context,null,null);
  //
  //     Provider.of<DashboardProvider>(context, listen: false)
  //         .getCategorys(context);
  //   // FocusScope.of(context).requestFocus(_searchFocusNode);
  //   });
  // }
  @override
  void initState() {
    super.initState();
    print("sreya");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DashboardProvider>(context, listen: false);

      provider.selectCategory(-1); // preselect All
      provider.getCategoryBasedItems(
          context, null, null); // load all items initially
      provider.getBannerImage(context);
      provider.getCategorys(context);
      final prefHelper = getIt<SharedPreferenceHelper>();
      final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;

      setState(() {
        orderText = isTakeAway ? "Takeaway confirmed — we’ll pack it fresh for you!" : "You’ve chosen Dine-In. We’ll serve you shortly!";
        orderImage = isTakeAway ? AppImage.takeaway : AppImage.dinein;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = context.watch<DashboardProvider>().homeBanner;

    final provider = Provider.of<CategoryProvider>(context);

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
              backgroundColor: Colors.grey.shade50,
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
                        AppImage.logo2,
                        height: isDesktop
                            ? 150
                            : isTablet
                                ? 150
                                : 100,
                      ),
                    ),
                    SizedBox(width: horizontalPadding),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // optional inner padding
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor, // set your background color here
                      borderRadius: BorderRadius.circular(8), // optional rounded corners
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: isDesktop
                              ? 36
                              : isTablet
                                  ? 32
                                  : 28,
                          height: isDesktop
                              ? 36
                              : isTablet
                                  ? 32
                                  : 28,
                          child: SvgPicture.asset(
                            orderImage,
                            fit: BoxFit.fill,
                            color: AppColor.whiteColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          orderText,
                          style: AppStyle.textStyleReemKufi.copyWith(
                            fontSize: isDesktop
                                ? 20
                                : isTablet
                                    ? 18
                                    : 10,
                            fontWeight: FontWeight.bold,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                if (cartProvider.items.isEmpty) {
                  return const SizedBox.shrink(); // empty widget
                }

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
                          height: 60,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        // Search Bar
                        Expanded(
                          child: Container(
                            height: searchHeight.clamp(50, 60),
                            margin: EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey
                                    .withOpacity(0.3), // subtle border color
                                width: 1.0, // border thickness
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // light shadow
                                  blurRadius: 6, // spread of shadow
                                  spreadRadius: 1, // how far the shadow spreads
                                  offset: const Offset(
                                      0, 3), // shadow position (x, y)
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                    controller: _searchController,
                                    focusNode: _searchFocusNode,
                                    textAlign: TextAlign.start,
                                    style: AppStyle.textStyleReemKufi.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontSize.clamp(14, 20),
                                      color: AppColor.blackColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Craving something? Find it here',
                                      hintStyle:
                                          AppStyle.textStyleReemKufi.copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: hintFontSize.clamp(14, 20),
                                        color: AppColor.blackColor
                                            .withOpacity(0.6),
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets
                                          .zero, // removes extra padding
                                    ),
                                    onChanged: (value) {
                                      final provider =
                                          Provider.of<DashboardProvider>(
                                        context,
                                        listen: false,
                                      );
                                      provider.getSearchProduct(
                                        context,
                                        _searchController.text,
                                        provider.selectedCategoryId,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        // Filter Button
                        Container(
                          margin: EdgeInsets.only(right: horizontalPadding),
                          height: searchHeight.clamp(47, 47),
                          width: searchHeight.clamp(47, 47), // Make it a square
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.primaryColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // light shadow
                                blurRadius: 6, // spread of shadow
                                spreadRadius: 1, // how far the shadow spreads
                                offset: const Offset(
                                    0, 3), // shadow position (x, y)
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [
                                AppColor.secondary,
                                AppColor.primaryColor
                              ],
                              begin:
                                  AlignmentDirectional(0.0, -2.0), // top-center
                              end: AlignmentDirectional(
                                  0.0, 1.0), // bottom-center
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.tune,
                              size: filterIconSize.clamp(18, 28),
                              color: AppColor.whiteColor,
                            ),
                            onPressed: () {
                              _searchFocusNode.unfocus();
                              _openSortDialog(context);
                              // Filter action here
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  banners == null
                      ? const Center(child: CircularProgressIndicator())
                      : banners.isEmpty
                          ? const Center(
                              child: Text(
                                "No banners available",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            )
                          : SizedBox(
                              height: 180, // let the card control height
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                itemCount: banners.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final banner = banners[index];
                                  return _buildPromoCard(
                                    imagePath: banner.image,
                                    context: context,
                                    onTap: () {
                                      if (index == 0) {
                                        _searchFocusNode.unfocus();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => BuyOneGetOne()),
                                        );
                                      } else {
                                        _searchFocusNode.unfocus();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ComboOfferScreen()),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Selector<DashboardProvider,
                        MapEntry<List<CategoryModel>?, int?>>(
                      selector: (_, provider) => MapEntry(
                          provider.categoryList, provider.selectedCategoryId),
                      builder: (context, entry, child) {
                        final categories = entry.key ?? [];
                        final selectedCategoryId = entry.value;

                        if (categories.isEmpty) {
                          return buildCategoryShimmer();
                        }

                        return buildCategoryList(
                          categories: categories,
                          selectedCategoryId: selectedCategoryId,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Product Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child:
                        Selector<DashboardProvider, MapEntry<List<Item>, bool>>(
                      selector: (_, provider) =>
                          MapEntry(provider.items ?? [], provider.isLoading),
                      builder: (context, entry, child) {
                        final products = entry.key;
                        final isLoading = entry.value;
                        // final products = provider.items ?? [];
                        if (isLoading) {
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

                              final placeholderCount =
                                  products.isNotEmpty ? products.length : 6;

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: placeholderCount,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
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
                          return Center(
                              child: Text(
                            "No products found",
                            style: AppStyle.textStyleReemKufi.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.greyColor,
                              fontSize: 15,
                              height: 1.0, // remove extra line height
                            ),
                          ));
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
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: aspectRatio * 0.9,
                              ),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final quantity =
                                    cartProvider.getQuantity(product.id);

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
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1.5,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.35),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  AspectRatio(
                                                    aspectRatio: 1.2,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        "${ApiEndpoints.imageBaseUrl}${product.image}", // prepend baseUrl
                                                        //fit: BoxFit.fill,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            const Icon(Icons
                                                                .image_not_supported),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    (product.name.isNotEmpty)
                                                        ? product.name[0]
                                                                .toUpperCase() +
                                                            product.name
                                                                .substring(1)
                                                                .toLowerCase()
                                                        : '',
                                                    style: AppStyle
                                                        .textStyleReemKufi
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    product.description ??
                                                        "", // show description
                                                    textAlign: TextAlign.center,
                                                    style: AppStyle
                                                        .textStyleReemKufi
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12,
                                                      color:
                                                          AppColor.blackColor,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const Spacer(),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      product.price != null
                                                          ? '₹${product.price}'
                                                          : "0",
                                                      style: AppStyle
                                                          .textStyleReemKufi
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        color:
                                                            AppColor.blackColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                _searchFocusNode.unfocus();
                                                _searchController.clear();
                                                showBurgerDialog(
                                                    context, product);
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(14),
                                                    bottomRight:
                                                        Radius.circular(16),
                                                  ),
                                                ),
                                                child: const Icon(Icons.add,
                                                    color: Colors.white,
                                                    size: 22),
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
    required String imagePath,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (screenWidth - 36) / 2; // 12 (left) + 12 (between) + 12 (right)
    final cardHeight = cardWidth * 0.56; // maintain proper ratio
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        // clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "${ApiEndpoints.imageBaseUrl}$imagePath",
                  fit: BoxFit.fill, // fills without gaps
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return ShimmerWidget.rectangular(
                      width: cardWidth,
                      height: double.infinity,
                      borderRadius: BorderRadius.circular(16),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                        child: Icon(Icons.broken_image, size: 40));
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 12, // distance from bottom
              left: 12, // distance from left
              child: ElevatedButton(
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
                            : 15,
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
                            : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPromoCard({
  //   required String badgeText,
  //   required String title,
  //   required String subtitle,
  //   required String imagePath,
  //   required BuildContext context,
  //   required VoidCallback onTap,
  // }) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final cardWidth =
  //       (screenWidth - 36) / 2; // 12 (left) + 12 (between) + 12 (right)
  //   final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
  //   final bool isDesktop = screenWidth >= 1024;
  //   return InkWell(
  //     onTap: onTap,
  //     child: Container(
  //       width: cardWidth,
  //       decoration: BoxDecoration(
  //         gradient: const LinearGradient(
  //           colors: [AppColor.secondary, AppColor.primaryColor],
  //           begin: AlignmentDirectional(0.0, -2.0), // top-center
  //           end: AlignmentDirectional(0.0, 1.0), // bottom-center
  //           stops: [0.0, 1.0], // smooth gradient
  //           tileMode: TileMode.clamp,
  //         ),
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: const [
  //           BoxShadow(
  //             color: Colors.black12,
  //             blurRadius: 4,
  //             offset: Offset(0, 3),
  //           ),
  //         ],
  //       ),
  //       child: Stack(
  //         children: [
  //           Positioned(
  //             top: isDesktop
  //                 ? -14
  //                 : isTablet
  //                 ?-14
  //                 : -8, // different top offset
  //             left: isDesktop
  //                 ? 16
  //                 : isTablet
  //                 ? 8
  //                 : 0, // different left offset
  //             child: Image.asset(
  //               badgeText,
  //               height: isDesktop
  //                   ? 80
  //                   : isTablet
  //                   ? 65
  //                   : 50,
  //               fit: BoxFit.contain,
  //             ),
  //           ),
  //
  //           Padding(
  //             padding: const EdgeInsets.only(left: 12, top: 22),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   title,
  //                   textAlign: TextAlign.center,
  //                   style: AppStyle.textStyleLobster.copyWith(
  //                     color: AppColor.whiteColor,
  //                     fontSize: isDesktop
  //                         ? 22
  //                         : isTablet
  //                             ? 18 // Tablet font size
  //                             : 15,
  //                     fontWeight: isTablet
  //                         ? FontWeight.w600 // Slightly bolder on tablet
  //                         : FontWeight.normal,
  //                   ),
  //                 ),
  //
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Expanded(
  //                       child: Text(
  //                         subtitle,
  //                         style: AppStyle.textStyleReemKufi.copyWith(
  //                           color: Colors.white,
  //                           fontSize: isDesktop
  //                               ? 22
  //                               : isTablet
  //                                   ? 16 // Tablet font size
  //                                   : 12,
  //                           fontWeight:
  //                               isTablet ? FontWeight.w500 : FontWeight.normal,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 8),
  //                     Image.network(
  //                       imagePath,
  //                       height: 100,
  //                       width: 100,
  //                     ),
  //                   ],
  //                 ),
  //                 //const SizedBox(height: 12),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     ElevatedButton(
  //                       onPressed: onTap,
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.white,
  //                         elevation: 6,
  //                         shadowColor: Colors.black54,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(20),
  //                           side: const BorderSide(
  //                             color: AppColor.primaryColor,
  //                             width: 2,
  //                           ),
  //                         ),
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: isDesktop
  //                               ? 32
  //                               : isTablet
  //                                   ? 24
  //                                   : 15, // Wider on large screens
  //                           vertical: isDesktop
  //                               ? 14
  //                               : isTablet
  //                                   ? 12
  //                                   : 8,
  //                         ),
  //                       ),
  //                       child: Text(
  //                         "Buy Now",
  //                         style: AppStyle.textStyleReemKufi.copyWith(
  //                           color: AppColor.primaryColor,
  //                           fontSize: isDesktop
  //                               ? 20
  //                               : isTablet
  //                                   ? 18
  //                                   : 16, // Bigger font for bigger screens
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 12),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                        color: Colors.black.withOpacity(0.1), // subtle shadow color
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

  void showBurgerDialog(BuildContext context, Item product) {
    final prefHelper = getIt<SharedPreferenceHelper>();
    final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
    bool isExpanded = false;
    final selectedProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    // selectedProvider.setBasePrice(product.price);
    selectedProvider.setQuantity(1);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (isTakeAway) {
      selectedProvider.setBasePriceWithTakeAway(product);
    } else {
      selectedProvider.setBasePrice(
        (product.price != null && product.price!.isNotEmpty)
            ? double.tryParse(product.price!) ?? 0.0
            : 0.0,
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

                    return  GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.primaryDelta! > 15) { // drag down with some threshold
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
                                        borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(80)),
                                        child: Container(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Image.network(
                                            "${ApiEndpoints.imageBaseUrl}${product.image}", // prepend baseUrl
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
                                        onTap: () => Navigator.of(context).pop(),
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
                                                  overflow: TextOverflow.ellipsis,
                                                  style: AppStyle.textStyle400.copyWith(
                                                    color: AppColor.blackColor,
                                                    fontSize: priceSize,
                                                   // fontWeight: FontWeight.bold,
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
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12.0),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  // Track toggle state

                                                  // Determine if description is considered long
                                                  final bool isDescriptionLong = product.description.length > 40;

                                                  // Prepare text for display
                                                  final String displayDescription = isExpanded || product.description.length <= 40
                                                      ? product.description
                                                      : '${product.description.substring(0, 40)}...';

                                                  if (isDescriptionLong) {
                                                    // Long description -> show in two rows
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        /// Description
                                                        Text(
                                                          displayDescription,
                                                          style: AppStyle.textStyleReemKufi.copyWith(
                                                            color: AppColor.greyColor,
                                                            fontSize: description,
                                                          ),
                                                        ),

                                                        // "See More / See Less" button
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              isExpanded = !isExpanded;
                                                            });
                                                          },
                                                          child: Text(
                                                            isExpanded ? "See Less" : "See More",
                                                            style: const TextStyle(
                                                              color: AppColor.primaryColor,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(height: 6),

                                                        /// Prep Time
                                                        if (product.time != null && product.time!.trim().isNotEmpty)
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.access_time_outlined,
                                                                color: AppColor.primaryColor,
                                                              ),
                                                              const SizedBox(width: 6),
                                                              Text(
                                                                "Prep time : ",
                                                                style: AppStyle.textStyleReemKufi.copyWith(
                                                                  color: AppColor.darkGreyColor,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              Text(
                                                                product.time!.toLowerCase().contains("mins")
                                                                    ? product.time!
                                                                    : "${product.time} mins",
                                                                style: AppStyle.textStyleReemKufi.copyWith(
                                                                  color: AppColor.darkGreyColor,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    );
                                                  } else {
                                                    // Short description -> show in the same row
                                                    return Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        /// Flexible Description
                                                        Flexible(
                                                          child: Text(
                                                            product.description,
                                                            style: AppStyle.textStyleReemKufi.copyWith(
                                                              color: AppColor.darkGreyColor,
                                                              fontSize: description,
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(width: 20),

                                                        /// Prep Time
                                                        if (product.time != null && product.time!.trim().isNotEmpty)
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              const Icon(
                                                                Icons.access_time_outlined,
                                                                color: AppColor.primaryColor,
                                                              ),
                                                              const SizedBox(width: 6),
                                                              Text(
                                                                "Prep time : ",
                                                                style: AppStyle.textStyleReemKufi.copyWith(
                                                                  color: AppColor.darkGreyColor,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              Text(
                                                                product.time!.toLowerCase().contains("mins")
                                                                    ? product.time!
                                                                    : "${product.time} mins",
                                                                style: AppStyle.textStyleReemKufi.copyWith(
                                                                  color: AppColor.darkGreyColor,
                                                                  fontSize: 15,
                                                                ),
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
                      
                                        // if (product.time != null &&
                                        //     product.time!.trim().isNotEmpty)
                                        //   Padding(
                                        //     padding:
                                        //         const EdgeInsets.only(left: 12.0),
                                        //     child: Consumer<CategoryProvider>(
                                        //       builder:
                                        //           (context, provider, child) {
                                        //         // Extract the numeric value from the product's time (e.g., "30 mins")
                                        //         int baseTime = int.tryParse(
                                        //               product.time!
                                        //                   .toLowerCase()
                                        //                   .replaceAll("mins", "")
                                        //                   .replaceAll("min", "")
                                        //                   .trim(),
                                        //             ) ??
                                        //             0;
                                        //
                                        //         // Calculate total time based on quantity
                                        //         int totalTime =
                                        //             baseTime * provider.quantity;
                                        //
                                        //         // Update provider with total time
                                        //         WidgetsBinding.instance
                                        //             .addPostFrameCallback((_) {
                                        //           provider
                                        //               .setTotalTime(totalTime);
                                        //         });
                                        //
                                        //         return RichText(
                                        //           text: TextSpan(
                                        //             children: [
                                        //               TextSpan(
                                        //                 text:
                                        //                     "Total Preparation Time : ", // Label text
                                        //                 style: AppStyle
                                        //                     .textStyleReemKufi
                                        //                     .copyWith(
                                        //                   color: AppColor
                                        //                       .blackColor, // Grey for label
                                        //                   fontSize: 15,
                                        //                   fontWeight:
                                        //                       FontWeight.w500,
                                        //                 ),
                                        //               ),
                                        //               TextSpan(
                                        //                 text:
                                        //                     "$totalTime ${totalTime == 1 ? "min" : "mins"}", // Time text
                                        //                 style: AppStyle
                                        //                     .textStyleReemKufi
                                        //                     .copyWith(
                                        //                   color: AppColor
                                        //                       .primaryColor, // Highlight time with primary color
                                        //                   fontSize: 15,
                                        //                   fontWeight:
                                        //                       FontWeight.w600,
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         );
                                        //       },
                                        //     ),
                                        //   ),
                                        // if ((product.childCategory != null &&
                                        //         product
                                        //             .childCategory.isNotEmpty &&
                                        //         product.childCategory.first
                                        //                 .takeAwayPrice !=
                                        //             null) ||
                                        //     (product.takeAwayPrice != null))
                                        //   Visibility(
                                        //     visible: isTakeAway,
                                        //     child: Padding(
                                        //       padding:
                                        //           const EdgeInsets.only(left: 12.0),
                                        //       child: Row(
                                        //         children: [
                                        //           /// Label
                                        //           Text(
                                        //             "Packing Charge : ",
                                        //             style: AppStyle
                                        //                 .textStyleReemKufi
                                        //                 .copyWith(
                                        //               color: AppColor.blackColor,
                                        //               fontSize: 15,
                                        //               fontWeight: FontWeight.w500,
                                        //             ),
                                        //           ),
                                        //
                                        //           /// Value
                                        //           Builder(
                                        //             builder: (context) {
                                        //               // ✅ Priority Logic
                                        //               // 1. Use child category takeAwayPrice if available
                                        //               // 2. Otherwise, use product-level takeAwayPrice
                                        //               final dynamic packingCharge = (product
                                        //                               .childCategory !=
                                        //                           null &&
                                        //                       product.childCategory
                                        //                           .isNotEmpty &&
                                        //                       product
                                        //                               .childCategory
                                        //                               .first
                                        //                               .takeAwayPrice !=
                                        //                           null)
                                        //                   ? product.childCategory
                                        //                       .first.takeAwayPrice
                                        //                   : product.takeAwayPrice;
                                        //
                                        //               // ✅ Convert to double safely
                                        //               final double? chargeValue =
                                        //                   packingCharge is String
                                        //                       ? double.tryParse(
                                        //                           packingCharge)
                                        //                       : (packingCharge
                                        //                               is double
                                        //                           ? packingCharge
                                        //                           : null);
                                        //
                                        //               return Text(
                                        //                 chargeValue != null
                                        //                     ? chargeValue
                                        //                         .toStringAsFixed(
                                        //                             2) // formatted to 2 decimals
                                        //                     : "0.00", // Fallback if null
                                        //                 style: AppStyle
                                        //                     .textStyleReemKufi
                                        //                     .copyWith(
                                        //                   color: AppColor.greyColor,
                                        //                   fontSize: 15,
                                        //                 ),
                                        //               );
                                        //             },
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ),
                                        if (product.takeAwayPrice != null)
                                          Visibility(
                                            visible: isTakeAway,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0),
                                              child: Row(
                                                children: [
                                                  /// Label
                                                  Text(
                                                    "Packing Charge : ",
                                                    style: AppStyle
                                                        .textStyleReemKufi
                                                        .copyWith(
                                                      color: AppColor.blackColor,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                      
                                                  /// Value
                                                  Builder(
                                                    builder: (context) {
                                                      // ✅ Only product-level takeAwayPrice is considered
                                                      final dynamic
                                                          packingCharge =
                                                          product.takeAwayPrice;
                      
                                                      // ✅ Convert safely to double
                                                      final double? chargeValue =
                                                          packingCharge is String
                                                              ? double.tryParse(
                                                                  packingCharge)
                                                              : (packingCharge
                                                                      is double
                                                                  ? packingCharge
                                                                  : null);
                      
                                                      return Text(
                                                        chargeValue != null
                                                            ? chargeValue
                                                                .toStringAsFixed(
                                                                    2) // formatted to 2 decimals
                                                            : "0.00", // fallback
                                                        style: AppStyle
                                                            .textStyleReemKufi
                                                            .copyWith(
                                                          color:
                                                              AppColor.greyColor,
                                                          fontSize: 15,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                      
                                        if (product.childCategory != null &&
                                            product.childCategory.isNotEmpty) ...[
                                          SizedBox(height: screenHeight * 0.025),
                      
                                          // 🟡 Size options
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: product.childCategory
                                                .map((child) {
                                              final provider = context
                                                  .watch<CategoryProvider>();
                                              var selectedChild =
                                                  provider.selectedChildCategory;
                      
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
                                                child.name,
                                                "₹${(child.price ?? 0).toStringAsFixed(0)}",
                                                isSelected:
                                                    selectedChild?.id == child.id,
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
                                                                  FontWeight.w600,
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
                                                                  FontWeight.w600,
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
                                                                  FontWeight.w600,
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
                                                        CrossAxisAlignment.start,
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
                                                                provider, child) {
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
                                          Selector<CategoryProvider, double>(
                                            selector: (context, provider) {
                                              final prefHelper =
                                                  getIt<SharedPreferenceHelper>();
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
                                                    fontSize: isDesktop ? 17 : 16,
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
                                          borderRadius: BorderRadius.circular(12),
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
                                            final selectedProvider =
                                                context.read<CategoryProvider>();
                      
                                            final cartItem = CartItemModel(
                                                id: product.id,
                                                name: product.name,
                                                description: product.description,
                                                images: [product.image],
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
                      
                                                // takeAwayPrice:
                                                //     selectedChild?.takeAwayPrice,
                                                // subCategoryId: selectedChild
                                                //         ?.subCategoryId ??
                                                //     0,
                                                subCategoryId: product.id,
                                                childCategoryId:
                                                    selectedChild?.id.toString(),
                                                childCategoryName:
                                                    selectedChild?.name,
                                                isCombo: null,
                                                heatLevel: selectedProvider
                                                    .selectedHeatLabel,
                                                totalDeliveryTime: totalTime,
                                                type: "normal",
                                                prepareTime: product.time);
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

  Widget buildCategoryShimmer({int itemCount = 7}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 600;

        if (isMobile) {
          return SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // rounded square with circular image placeholder
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            // inner circular placeholder to mimic ClipOval Image
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // short text bar
                        Container(
                          width: 60,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          // Larger screen: show wrap of placeholders
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(itemCount, (index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 70,
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        }
      },
    );
  }

  Widget buildCategoryList({
    required List<CategoryModel> categories,
    required int? selectedCategoryId,
  }) {
    final allCategories = [
      CategoryModel(
        id: -1,
        name: 'All',
        image:
            'https://img.pikbest.com/png-images/20250218/delicious-cheese-burger-_11536406.png!w700wp',
      ),
      ...categories,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        if (screenWidth < 600) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  /// Grey divider (background line)
                  /// Horizontal category list
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: allCategories.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryItem(
                          context,
                          allCategories[index],
                          selectedCategoryId: selectedCategoryId,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          /// Tablet / Web layout
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
                        selectedCategoryId: selectedCategoryId,
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
        required int? selectedCategoryId,
      }) {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    final isSelected = selectedCategoryId == cat.id;

    return GestureDetector(
      onTap: () async {
        provider.selectCategory(cat.id);
        await provider.getCategoryBasedItems(
          context,
          cat.id == -1 ? null : cat.id,
          provider.selectedSort,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Category Image with **Bottom Shadow**
            Container(
              width: fixedSize ?? 60,
              height: fixedSize ?? 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.25), // Shadow color
                //     blurRadius: 4, // Soft, natural shadow
                //     spreadRadius: 0, // No extra spread
                //     offset: const Offset(0, 1),
                //     // Shadow goes **4px downwards** only
                //   ),
                // ],
              ),
              child: ClipOval(
                child: Image.network(
                  cat.image.startsWith("https")
                      ? cat.image
                      : "${ApiEndpoints.imageBaseUrl}${cat.image}",
                  //fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 30),
                ),
              ),
            ),

            const SizedBox(height: 6),

            /// Category Name
            Text(
              cat.name.isNotEmpty
                  ? cat.name[0].toUpperCase() +
                  cat.name.substring(1).toLowerCase()
                  : '',
              style: AppStyle.textStyleReemKufi.copyWith(
                color: isSelected ? Colors.black : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            /// Orange Underline if selected
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: isSelected ? 60 : 0,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }


// when click on the ctagoey that item scroingthe list  then set the first  item
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

class HeatLevelSelector extends StatefulWidget {
  @override
  _HeatLevelSelectorState createState() => _HeatLevelSelectorState();
}

class _HeatLevelSelectorState extends State<HeatLevelSelector> {
  int _selectedHeat = 0; // 0 - Mild, 1 - Medium, 2 - Hot

  final List<String> heatLabels = ['Mild', 'Medium', 'Hot'];

  @override
  Widget build(BuildContext context) {
    final heatProvider = context.watch<CategoryProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              activeTrackColor:
                  AppColor.primaryColor, // Hide default active track color
              inactiveTrackColor: Colors.grey,
              valueIndicatorColor:
                  AppColor.primaryColor, // Hide default inactive track color

              thumbColor: AppColor.primaryColor),
          child: Slider(
            value: heatProvider.selectedHeatLevel.toDouble(),
            //value: _selectedHeat.toDouble(),
            min: 0,
            max: 2,
            divisions: 2,
            label: heatLabels[heatProvider.selectedHeatLevel],
            // label: heatLabels[_selectedHeat],
            onChanged: (double value) {
              heatProvider.setHeatLevel(value.round());
              // setState(() {
              //   _selectedHeat = value.round();
              // });
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

Future<String?> showSortByDialog(BuildContext context, String currentSort) {
  String selectedOption = currentSort;
  final provider = Provider.of<DashboardProvider>(context, listen: false);
  List<String> options = [
    'Popular',
    'Newest',
    'Price: Lowest to high',
    'Price: Highest to low',
  ];

  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Sort By",
    pageBuilder: (context, anim1, anim2) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.only(top: 16, bottom: 16),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 16, left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sort By',
                            style: AppStyle.textStyleReemKufi.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColor.whiteColor,
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white54),
                    const SizedBox(height: 10),
                    ...options.map((option) {
                      bool isSelected = selectedOption == option;
                      return Container(
                        width: double.infinity,
                        color: isSelected ? Colors.white : Colors.transparent,
                        child: ListTile(
                          title: Text(
                            option,
                            style: AppStyle.textStyleReemKufi.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColor.primaryColor
                                  : AppColor.whiteColor,
                              fontSize: 15,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedOption = option;
                            });
                          },
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedOption = '';
                                });
                                provider.clearOfferSort();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Clear',
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                    context, selectedOption); // ✅ return
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Done',
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primaryColor,
                                  fontSize: 16,
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
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position:
            Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim1),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

void _openSortDialog(BuildContext context) async {
  final provider = Provider.of<DashboardProvider>(context, listen: false);

  // Pass current selected sort (label) to dialog
  final selectedOption =
      await showSortByDialog(context, provider.selectedSortLabel);

  if (selectedOption != null && selectedOption.isNotEmpty) {
    // Map UI label to API value
    String apiSort = '';
    switch (selectedOption) {
      case 'Popular':
        apiSort = 'popular';
        break;
      case 'Newest':
        apiSort = 'newest';
        break;
      case 'Price: Lowest to high':
        apiSort = 'low-high';
        break;
      case 'Price: Highest to low':
        apiSort = 'high-low';
        break;
    }

    // Save both: API value for backend, label for UI
    provider.setSortOption(apiSort, selectedOption);

    // Call API with API-friendly value
    provider.getCategoryBasedItems(
      context,
      provider.selectedCategoryId,
      apiSort,
    );
  }
}

// void _openSortDialog(BuildContext context) async {
//   final provider = Provider.of<DashboardProvider>(context, listen: false);
//   final selectedOption = await showSortByDialog(context, provider.selectedSort);
//
//   if (selectedOption != null && selectedOption.isNotEmpty) {
//     provider.setSortOption(selectedOption);
//
//
//     switch (selectedOption) {
//       case 'Popular':
//         provider.getCategoryBasedItems(context, provider.selectedCategoryId,'popular');
//         break;
//       case 'Newest':
//         provider.getCategoryBasedItems(context, provider.selectedCategoryId,'newest');
//         break;
//       case 'Price: Lowest to high':
//         provider.getCategoryBasedItems(context, provider.selectedCategoryId, 'low-high');
//         break;
//       case 'Price: Highest to low':
//         provider.getCategoryBasedItems(context, provider.selectedCategoryId, 'high-low');
//         break;
//     }
//   }
// }
