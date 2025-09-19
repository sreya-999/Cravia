import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/views/home_screen.dart';
import 'package:ravathi_store/views/view_order_screen.dart';
import '../models/add_on.dart';
import '../models/items_model.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import '../providers/dashboard_provider.dart';
import '../urls/api_endpoints.dart';
import '../utlis/App_color.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../utlis/App_style.dart';
import '../utlis/share_preference_helper/sharereference_helper.dart';
import '../utlis/widgets/app_text_style.dart';
import '../utlis/widgets/custom_appbar.dart';
import '../utlis/widgets/shimmer_loading.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuyOneGetOne extends StatefulWidget {
  const BuyOneGetOne({super.key});

  @override
  State<BuyOneGetOne> createState() => _BuyOneGetOneState();
}

class _BuyOneGetOneState extends State<BuyOneGetOne> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  void initState() {
    super.initState();
    print("sreya");

    WidgetsBinding.instance.addPostFrameCallback((_) {

      final categoryProvider =
      Provider.of<DashboardProvider>(context, listen: false);

      categoryProvider.getBuyOneOffer(context, null,"");
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<CategoryProvider>(context);

    final cartProvider = Provider.of<CartProvider>(context);
    double subTotal = cartProvider.subTotal;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Buy one Get one',
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {

          final double screenWidth = MediaQuery.of(context).size.width;
          final bool isDesktop = screenWidth >= 1024;
          final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
          final bool isMobile = screenWidth < 600;

          // Dynamic sizes based on device type
          final double barHeight = isDesktop ? 110 : isTablet ? 90 : 80;
          final double paddingHorizontal = isDesktop ? 40 : isTablet ? 24 : 16;
          final double paddingVertical = isDesktop ? 16 : isTablet ? 12 : 10;
          final double titleFontSize = isDesktop ? 18 : isTablet ? 16 : 15;
          final double priceFontSize = isDesktop ? 20 : isTablet ? 18 : 18;
          final double buttonFontSize = isDesktop ? 22 : isTablet ? 17 : 17;
          final double buttonPaddingH = isDesktop ? 36 : isTablet ? 32 : 28;
          final double buttonPaddingV = isDesktop ? 18 : isTablet ? 16 : 14;

          return Container(
            height: barHeight,
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: paddingVertical,
            ),
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColor.secondary, // Top color
                  AppColor.primaryColor // Fade out below
                ],
                begin: Alignment.topCenter,    // Start at the very top
                end: Alignment.bottomCenter,   // End at the bottom
                stops: [0.0, 0.5],             // 0.0 = start, 0.4 = 40% height
                tileMode: TileMode.clamp,
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
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [

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
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controller,
                          focusNode: _searchFocusNode,
                          style: const TextStyle(
                            fontFamily: 'Reem Kufi',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black, // ✅ Ensures typed text is visible
                          ),
                          decoration:  InputDecoration(
                            hintText: 'Looking for BOGO? Type here...',
                            hintStyle: AppTextStyles.nunitoRegular(
                              14,
                              color: AppColor.lightGreyColor,
                            ),

                            prefixIcon: Icon(Icons.search, color: AppColor.lightGreyColor),
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            print("Search value: $value");
                            // Provider.of<CategoryProvider>(context, listen: false)
                            //     .getBuyOneOffer(context, value);
                            Provider.of<DashboardProvider>(context, listen: false)
                                .bugOneGetOneOfferSearch(context,_controller.text);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),
                    Container(
                      height: 54,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.primaryColor),
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [AppColor.secondary, AppColor.primaryColor],
                          begin: AlignmentDirectional(0.0, -2.0), // top-center
                          end: AlignmentDirectional(0.0, 1.0), // bottom-center

                          stops: [0.0, 1.0], // smooth gradient
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: AppColor.whiteColor),
                        onPressed: () {
                          _searchFocusNode.unfocus();
                          _openSortDialog(context);
                        },
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Consumer<DashboardProvider>(
                  builder: (context, provider, child) {
                    final size = MediaQuery.of(context).size;
                    final products = provider.buyOneGetOne;
                    final badgeSize = size.width * 0.10;
                    /// 🔹 Show shimmer while loading

                    if (provider.isLoading) {

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
                          final placeholderCount = (products?.isNotEmpty ?? false)
                              ? products!.length
                              : 6;

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
                    if (products == null || products.isEmpty) {
                      return  SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(child: Text("No products found",style: AppStyle.textStyleReemKufi.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.greyColor,
                          fontSize: 18,
                        ),
                          textAlign: TextAlign.center,
                        )),
                      );
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
                         // aspectRatio = 0.74;
                          aspectRatio = 0.704;
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
                            final product = products[index];

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
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(30),
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
                                                    //  fit: BoxFit.fill,
                                                      errorBuilder: (context, error, stackTrace) =>
                                                      const Icon(Icons.image_not_supported),
                                                    )
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  (product.name.isNotEmpty)
                                                      ? product.name[0].toUpperCase() + product.name.substring(1).toLowerCase()
                                                      : '',
                                                  style: AppTextStyles.nunitoBold(17, color: Colors.black),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  product.description.toString() ?? '',
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.latoRegular(10, color: Colors.black),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const Spacer(),
                                                Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text(
                                                    '₹${double.parse(product.price ?? '0').toStringAsFixed(2)}',

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
                                        Positioned(
                                          top: screenWidth >= 1024
                                              ? -15 // desktop
                                              : screenWidth >= 600
                                              ? -15 // tablet
                                              : -7, // mobile
                                          left: screenWidth >= 1024
                                              ? 12 // desktop
                                              : screenWidth >= 600
                                              ? 8 // tablet
                                              : 5, // mobile
                                          child: Image.asset(
                                            AppImage.badge,
                                            width: screenWidth >= 1024
                                                ? 100 // desktop
                                                : screenWidth >= 600
                                                ? 70 // tablet
                                                : 50, // mobile
                                          ),
                                        ),
                                        // Add icon exactly in bottom-right corner
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              _searchFocusNode.unfocus();
                                              _controller.clear();
                                              showBurgerDialog(context, product);
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

  Future<String?> showSortByDialog(BuildContext context,String currentSort) {
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
                        padding: const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
                        child: Row(
                          children: [
                            // This ensures the "Sort By" text stays centered
                            Expanded(
                              child: Text(
                                'Sort By',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.nunitoBold(20, color:  AppColor.whiteColor,),
// Centers text within Expanded
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                AppImage.cross,height: 20,width: 20,),
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
                          color: isSelected
                              ? Colors.white
                              : Colors.transparent,
                          child: ListTile(
                            title: Text(
                              option,
                              style: AppTextStyles.nunitoMedium(15, color: isSelected
                                  ? AppColor.primaryColor
                                  : AppColor.whiteColor,),

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
                                  style: AppTextStyles.nunitoRegular(16,  color: AppColor.primaryColor,),

                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, selectedOption); // ✅ return
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
                                  style: AppTextStyles.nunitoBold(16,  color: AppColor.primaryColor,),
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
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim1),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void _openSortDialog(BuildContext context) async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);

    final selectedOption = await showSortByDialog(context, provider.offerSelectedSortLabel);

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
      provider.setOfferSortOption(apiSort, selectedOption);

      // Call API with API-friendly value
      provider.getBuyOneOffer(
        context,"",
        apiSort,
      );
    }
  }

  // void _openSortDialog(BuildContext context) async {
  //   final provider = Provider.of<DashboardProvider>(context, listen: false);
  //   final selectedOption = await showSortByDialog(context, provider.selectedSort);
  //
  //   if (selectedOption != null && selectedOption.isNotEmpty) {
  //     provider.setSortOption(selectedOption,"");
  //
  //
  //     switch (selectedOption) {
  //       case 'Popular':
  //         provider.getBuyOneOffer(context,"",'popular');
  //         break;
  //       case 'Newest':
  //         provider.getBuyOneOffer(context,"",'newest');
  //         break;
  //       case 'Price: Lowest to high':
  //         provider.getBuyOneOffer(context, "", 'low-high');
  //         break;
  //       case 'Price: Highest to low':
  //         provider.getBuyOneOffer(context, "", 'high-low');
  //         break;
  //     }
  //   }
  // }

  void showBurgerDialog(BuildContext context,Item product) {
    final selectedProvider =
    Provider.of<CategoryProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double buttonFontSize = isDesktop ? 25 : isTablet ? 17 : 16;
    final double priceSize = isDesktop ? 27 : isTablet ? 20 : 20;
    final double description = isDesktop ? 20 : isTablet ? 15 : 15;
    final size = MediaQuery.of(context).size;
    final badgeSize = size.width * 0.15;
    bool isExpanded = false;
    // Set base price
    if (product.childCategory == null || product.childCategory.isEmpty) {
      selectedProvider.clearSelectedChildCategory();
    }
    final prefHelper = getIt<SharedPreferenceHelper>();
    final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
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
    //   double.tryParse(product.price ?? '0') ?? 0.0,
    // );
    // selectedProvider.setBasePriceWithTakeAway(product);
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

                    return GestureDetector(
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
                          decoration:  const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.primaryColor,
                                AppColor.whiteColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.6, 0.25],
                            ),

                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          child: Stack(
                            children: [
                              Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Container(
                                  height: screenHeight * 0.29,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(AppImage.bgImg),
                                      fit: BoxFit.cover, // Cover the entire container

                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColor.primaryColor,
                                        AppColor.secondary,
                                      ],
                                      end: Alignment.bottomRight,
                                      begin: Alignment.topCenter,
                                      stops: [0.3, 0.8],
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
                                            padding: const EdgeInsets.all(25.0),
                                            child: Image.network(
                                              "${ApiEndpoints.imageBaseUrl}${product.image}", // prepend baseUrl
                                         //     fit: BoxFit.fill,
                                              errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.image_not_supported),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                                // 🟡 BODY (Scrollable)
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
                                          SizedBox(height: 25,),// Title + Price
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            /// Product name and 1+1 together
                                            Flexible( // ✅ Use Flexible to handle long product names
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  /// Product Name
                                                  Flexible(
                                                    child: Text(
                                                      (product.name.isNotEmpty)
                                                          ? product.name[0].toUpperCase() +
                                                          product.name.substring(1).toLowerCase()
                                                          : '',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: AppTextStyles.nunitoBold(
                                                        priceSize,
                                                        color: AppColor.blackColor,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6), // spacing between name and 1+1

                                                  /// 1+1 Text
                                                  Text(
                                                    "(1+1)",
                                                    style: AppTextStyles.nunitoMedium(15, color:  AppColor.primaryColor),

                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(width: 6),

                                            /// Price on the right
                                            Text(
                                              "₹${(double.tryParse(product.price ?? '0') ?? 0.0).toStringAsFixed(2)}",
                                              style: AppTextStyles.nunitoBold(
                                                priceSize,
                                                color: AppColor.blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),




                                      SizedBox(height: 4,),

//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 12.0),
//                                             child: LayoutBuilder(
//                                               builder: (context, constraints) {
//                                                 return StatefulBuilder(
//                                                   builder: (context, setState) {
//                                                   // Track toggle state
//                                                     // Determine if description is considered long
//                                                     final bool isDescriptionLong = product.description.length > 250;
//
//                                                     // Prepare text for display
//                                                     final String displayDescription = isExpanded || product.description.length <= 40
//                                                         ? product.description
//                                                         : '${product.description.substring(0, 40)}...';
//
//                                                     if (isDescriptionLong) {
//                                                       // Long description -> show in two rows
//                                                       return Column(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           /// Description
//                                                           Text(
//                                                             displayDescription,
//                                                             style: AppStyle.textStyleReemKufi.copyWith(
//                                                               color: AppColor.greyColor,
//                                                               fontSize: description,
//                                                             ),
//                                                           ),
//
//                                                           // "See More / See Less" button
//                                                           GestureDetector(
//                                                             onTap: () {
//                                                               setState(() {
//                                                                 isExpanded = !isExpanded;
//                                                               });
//                                                             },
//                                                             child: Text(
//                                                               isExpanded ? "See Less" : "See More",
//                                                               style: const TextStyle(
//                                                                 color: AppColor.primaryColor,
//                                                                 fontWeight: FontWeight.bold,
//                                                                 fontSize: 14,
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                           const SizedBox(height: 6),
//
//                                                           /// Prep Time
//                                                           if (product.time != null && product.time!.trim().isNotEmpty)
//                                                             Row(
//                                                               children: [
//                                                                 const Icon(
//                                                                   Icons.access_time_outlined,
//                                                                   color: AppColor.primaryColor,
//                                                                 ),
//                                                                 Text(
//                                                                   product.time!.toLowerCase().contains("mins")
//                                                                       ? product.time!
//                                                                       : "${product.time} mins",
//                                                                   style: AppStyle.textStyleReemKufi.copyWith(
//                                                                     color: AppColor.darkGreyColor,
//                                                                     fontSize: 15,
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                         ],
//                                                       );
//                                                     } else {
//                                                       // Short description -> show in the same row
//                                                       return Row(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           /// Flexible Description
//                                                           Flexible(
//                                                             child: Text(
//                                                               product.description,
//                                                               style: AppStyle.textStyleReemKufi.copyWith(
//                                                                 color: AppColor.darkGreyColor,
//                                                                 fontSize: description,
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                           const SizedBox(width: 20),
//
//                                                           /// Prep Time
//                                                           if (product.time != null && product.time!.trim().isNotEmpty)
//                                                             Row(
//                                                               mainAxisSize: MainAxisSize.min,
//                                                               children: [
//                                                                 const Icon(
//                                                                   Icons.access_time_outlined,
//                                                                   color: AppColor.primaryColor,
//                                                                 ),
//                                                                 const SizedBox(width: 6),
//
//                                                                 Text(
//                                                                   product.time!.toLowerCase().contains("mins")
//                                                                       ? product.time!
//                                                                       : "${product.time} mins",
//                                                                   style: AppStyle.textStyleReemKufi.copyWith(
//                                                                     color: AppColor.darkGreyColor,
//                                                                     fontSize: 15,
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                         ],
//                                                       );
//                                                     }
//                                                   },
//                                                 );
//                                               },
//                                             ),
//                                           ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 0),
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    final bool isDescriptionLong = product.description.length > 350;
                                                    final String displayDescription = isExpanded || !isDescriptionLong
                                                        ? product.description
                                                        : '${product.description.substring(0, 350)}...';

                                                    if (isDescriptionLong) {
                                                      // Long description -> show in column
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            displayDescription,
                                                            maxLines: isExpanded ? null : 4,
                                                            overflow: TextOverflow.visible,
                                                            textAlign: TextAlign.justify,
                                                            style: AppTextStyles.latoRegular(description, color:  AppColor.lightGreyColor),
                                                          ),
                                                          if (isDescriptionLong)
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
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      );
                                                    } else {
                                                      // Short description -> show in row with prep time first, then takeaway price
                                                      return Row(

                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          /// Description
                                                          Flexible(
                                                            child: Text(
                                                              product.description,
                                                              // maxLines: 4,
                                                              // overflow: TextOverflow.ellipsis,
                                                                style: AppTextStyles.latoRegular(description, color:  AppColor.lightGreyColor)
                                                            ),
                                                          ),
                                                          const SizedBox(width: 10),
                                                        ],
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          if (product.time != null || product.takeAwayPrice != null) ...[
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],

                                          if (product.time !=
                                              null &&
                                              product.time!
                                                  .trim()
                                                  .isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(left:12.0,top: 8),
                                              child: Row(
                                                children: [
                                                  SvgPicture
                                                      .asset(
                                                    AppImage.time,
                                                    height: 20,
                                                  ),
                                                  const SizedBox(
                                                      width: 6),
                                                  Text(
                                                    product.time!
                                                        .toLowerCase()
                                                        .contains(
                                                        "mins")
                                                        ? product
                                                        .time!
                                                        : "${product.time} mins",
                                                    style: AppTextStyles.latoRegular(15, color:  AppColor.darkGreyColor),
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
                                                            final double? chargeValue = packingCharge is String
                                                                ? double.tryParse(packingCharge)
                                                                : (packingCharge is double ? packingCharge : null);

                                                            return Text(
                                                              chargeValue != null
                                                                  ? "Wrap & Pack Fee Rs  ${chargeValue.toStringAsFixed(2)}"
                                                                  : "Rs 0.00",
                                                              style: AppTextStyles.latoRegular(12, color:  AppColor.darkGreyColor),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),

                                        // if (product.time != null && product.time!.trim().isNotEmpty)
                                          //   Padding(
                                          //     padding: const EdgeInsets.only(left: 12.0),
                                          //     child: Consumer<CategoryProvider>(
                                          //       builder: (context, provider, child) {
                                          //         // Extract the numeric value from the product time
                                          //         int baseTime = int.tryParse(
                                          //           product.time!.toLowerCase().replaceAll("mins", "").trim(),
                                          //         ) ?? 0;
                                          //
                                          //         // Calculate total time based on quantity
                                          //         int totalTime = baseTime * provider.quantity;
                                          //         WidgetsBinding.instance.addPostFrameCallback((_) {
                                          //           provider.setTotalTime(totalTime);
                                          //         });
                                          //         return RichText(
                                          //           text: TextSpan(
                                          //             children: [
                                          //               TextSpan(
                                          //                 text: "Total Preparation Time : ", // Label text
                                          //                 style: AppStyle.textStyleReemKufi.copyWith(
                                          //                   color: AppColor.blackColor, // Grey for label
                                          //                   fontSize: 15,
                                          //                   fontWeight: FontWeight.w500,
                                          //                 ),
                                          //               ),
                                          //               TextSpan(
                                          //                 text: "$totalTime ${totalTime == 1 ? "min" : "mins"}", // Time text
                                          //                 style: AppStyle.textStyleReemKufi.copyWith(
                                          //                   color: AppColor.primaryColor, // Highlight time with primary color
                                          //                   fontSize: 15,
                                          //                   fontWeight: FontWeight.w600,
                                          //                 ),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         );
                                          //       },
                                          //     ),
                                          //   ),
                                          // if ((product.childCategory != null &&
                                          //     product.childCategory.isNotEmpty &&
                                          //     product.childCategory.first.takeAwayPrice != null) ||
                                          //     (product.takeAwayPrice != null))
                                          //   Visibility(
                                          //     visible: isTakeAway,
                                          //     child: Padding(
                                          //       padding: const EdgeInsets.only(left: 12.0),
                                          //       child: Row(
                                          //         children: [
                                          //           /// Label
                                          //           Text(
                                          //             "Packing Charge : ",
                                          //             style: AppStyle.textStyleReemKufi.copyWith(
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
                                          //               final dynamic packingCharge = (product.childCategory != null &&
                                          //                   product.childCategory.isNotEmpty &&
                                          //                   product.childCategory.first.takeAwayPrice != null)
                                          //                   ? product.childCategory.first.takeAwayPrice
                                          //                   : product.takeAwayPrice;
                                          //
                                          //               // ✅ Convert to double safely
                                          //               final double? chargeValue = packingCharge is String
                                          //                   ? double.tryParse(packingCharge)
                                          //                   : (packingCharge is double ? packingCharge : null);
                                          //
                                          //               return Text(
                                          //                 chargeValue != null
                                          //                     ? chargeValue.toStringAsFixed(2) // formatted to 2 decimals
                                          //                     : "0.00", // Fallback if null
                                          //                 style: AppStyle.textStyleReemKufi.copyWith(
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

                                          if (product.childCategory != null && product.childCategory.isNotEmpty) ...[
                                            SizedBox(height: screenHeight * 0.025),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal, // 👈 Enable horizontal scrolling
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: product.childCategory.map((child) {
                                                  final provider = context.watch<CategoryProvider>();
                                                  var selectedChild = provider.selectedChildCategory;

                                                  if (selectedChild == null && product.childCategory!.isNotEmpty) {
                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                      context.read<CategoryProvider>().setSelectedChildCategory(selectedChild);
                                                    });
                                                  }

                                                  return _buildOptionBox(
                                                    child.name,
                                                    "₹${(child.price ?? 0).toStringAsFixed(0)}",
                                                    isSelected: selectedChild?.id == child.id,
                                                    onTap: () {
                                                      context.read<CategoryProvider>().setSelectedChildCategory(child);
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            )
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
                                                            style: AppTextStyles.nunitoMedium(buttonFontSize, color:  AppColor.blackColor)
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
                                                          style: AppTextStyles.nunitoMedium(buttonFontSize, color:  AppColor.blackColor),
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
                                                            Consumer<CategoryProvider>(
                                                              builder: (context, provider, child) {
                                                                return Text(
                                                                  "${provider.quantity}",
                                                                  style: AppStyle.textStyleReemKufi.copyWith(
                                                                    fontWeight: FontWeight.w600,
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
                                                        SizedBox(height: 25,)
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9EFE9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              AppImage.addOn,
                                              height: 20
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children:  [
                                              Text(
                                                "Add Add-Ons",
                                                  style: AppTextStyles.latoBold(15,
                                                      color:  AppColor.blackColor)
                                              ),
                                              Text(
                                                "Make It Special — Choose Your Add-Ons Now!",
                                                  style: AppTextStyles.latoMedium(12, color:  AppColor.lightGreyColor)
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
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.015,
                                  ),
                                  decoration: const BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.secondary, // Top color
                                        AppColor.primaryColor // Fade out below
                                      ],
                                      begin: Alignment.topCenter,    // Start at the very top
                                      end: Alignment.bottomCenter,   // End at the bottom
                                      stops: [0.0, 0.5],             // 0.0 = start, 0.4 = 40% height
                                      tileMode: TileMode.clamp,
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
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ),
                                            Selector<CategoryProvider, double>(
                                              selector: (_, provider) => provider.totalPrice,
                                              builder: (context, totalPrice, child) {
                                                return ShaderMask(
                                                  shaderCallback: (bounds) =>
                                                      const LinearGradient(colors: [
                                                        AppColor.primaryColor,
                                                        AppColor.primaryColor
                                                      ]).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                                  child: Text(
                                                    '₹${totalPrice.toStringAsFixed(2)}',
                                                    style: AppStyle.textStyleReemKufi.copyWith(
                                                      color: Colors.white,
                                                      fontSize: isDesktop ? 17 : 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            // ShaderMask(
                                            //   shaderCallback: (bounds) =>
                                            //       const LinearGradient(colors: [
                                            //         AppColor.primaryColor,
                                            //         AppColor.primaryColor
                                            //       ]).createShader(Rect.fromLTWH(0, 0,
                                            //           bounds.width, bounds.height)),
                                            //   child: Text(
                                            //       '₹${selectedProvider.totalPrice.toStringAsFixed(2)}',
                                            //       style: AppStyle.textStyleReemKufi
                                            //           .copyWith(
                                            //         color: Colors.white,
                                            //         fontSize: 16,
                                            //         fontWeight: FontWeight.bold,
                                            //       )),
                                            // )
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
                                              final dynamic packingCharge = product.takeAwayPrice;

                                                  // Convert to double safely
                                              final double? packingChargeValue = packingCharge is String
                                                  ? double.tryParse(packingCharge)
                                                  : (packingCharge is double ? packingCharge : null);

                                              final selectedChild = context.read<CategoryProvider>().selectedChildCategory; // ✅ use read
                                              final totalTime = context.read<CategoryProvider>().totalTime;
                                              final cartProvider =
                                              Provider.of<CartProvider>(context,
                                                  listen: false);
                                              final cartItem = CartItemModel(
                                                  id: product.id,
                                                  name: product.name,
                                                  images: [product.image],
                                                  categoryId: product.categoryId,
                                                  price: isTakeAway
                                                      ? (selectedProvider.selectedPrices ?? 0.0)
                                                      : (selectedProvider.selectedPrices ?? 0.0),
                                                  quantity: selectedProvider.quantity,
                                                  isCombo: false,
                                                  takeAwayPrice: packingChargeValue,
                                                  // takeAwayPrice: selectedChild?.takeAwayPrice,
                                                  subCategoryId: selectedChild?.subCategoryId ?? 0,
                                                  childCategoryId: selectedChild?.id.toString(),      // 👈 pass child id if selected
                                                  childCategoryName: selectedChild?.name,
                                                  totalDeliveryTime:totalTime,
                                                childCategory: product.childCategory,
                                                description: product.description,
                                                spicy: product.spicy,
                                                prepareTime: product.time,

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
                                                  fontSize: isDesktop ? 22 : 17,
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
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 20), // spacing from status bar
                                  height: 5,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2.5),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -15,
                                left: 10,
                                child: Image.asset(
                                  AppImage.badge,
                                  height: 70,
                                  width: badgeSize,
                                  // width: badgeSize,
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

  void showAddOnDialog(BuildContext context, Item product) {
    final selectedProvider = Provider.of<CategoryProvider>(context, listen: false);

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
                    AppColor.primaryColor,
                    AppColor.whiteColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 0.25],
                ),


                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0,top:18,bottom: 0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                          AppImage.backArrow,
                          height: 25
                      ),
                    ),
                  ),
                  // Replace the current image + name section with this:
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            "${ApiEndpoints.imageBaseUrl}${product.image}",
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
                                (product.name != null && product.name!.isNotEmpty)
                                    ? product.name![0].toUpperCase() +
                                    product.name!.substring(1).toLowerCase()
                                    : '',
                                style: AppTextStyles.nunitoBold(20, color:  AppColor.whiteColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // Optional: show price here
                              Text(
                                "₹${(double.tryParse(product.price ?? '0') ?? 0.0).toStringAsFixed(2)}",
                                style: AppTextStyles.nunitoBold(20, color:  AppColor.whiteColor),
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


                 // const SizedBox(height: 10),

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
                          SizedBox(height: 20,),
                          // Title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                            child: Text(
                              "Choose Your Add-ons",
                              style: AppTextStyles.latoBold(18, color:  AppColor.blackColor),
                            ),
                          ),
                          Divider(),
                          // Add-ons List
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: sampleAddOnJson.length, // Use sample data length
                              itemBuilder: (context, index) {
                                // Create the AddOnModel list from sample JSON
                                final addOns = sampleAddOnJson
                                    .map((json) => AddOnModel.fromJson(json))
                                    .toList();

                                final addOn = addOns[index]; // <-- Fix: reference the specific addOn
                                final isSelected = selectedAddOns.contains(addOn.name);

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
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                                            color: isSelected ? AppColor.primaryColor : Colors.white,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: AppColor.primaryColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: isSelected
                                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                                              : null,
                                        ),
                                        const SizedBox(width: 12),

                                        // Add-on Name
                                        Expanded(
                                          child: Text(
                                            addOn.name,
                                            style: AppTextStyles.latoMedium(15, color:  AppColor.blackColor),
                                          ),
                                        ),

                                        // Price
                                        Text(
                                          "₹${addOn.price.toStringAsFixed(2)}",
                                          style: AppTextStyles.nunitoBold(15, color:  AppColor.blackColor),
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
                      gradient: const LinearGradient(
                        colors: [
                          AppColor.secondary, // Top color
                          AppColor.primaryColor // Fade out below
                        ],
                        begin: Alignment.topCenter,    // Start at the very top
                        end: Alignment.bottomCenter,   // End at the bottom
                        stops: [0.0, 0.5],             // 0.0 = start, 0.4 = 40% height
                        tileMode: TileMode.clamp,
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
                                      fontSize: 18,
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
                              final prefHelper = getIt<SharedPreferenceHelper>();
                              final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
                              final cartProvider =
                              Provider.of<CartProvider>(context, listen: false);
                              final dynamic packingCharge = product.takeAwayPrice;
                              final totalTime = context.read<CategoryProvider>().totalTime;
                              // Convert to double safely
                              final double? packingChargeValue = packingCharge is String
                                  ? double.tryParse(packingCharge)
                                  : (packingCharge is double ? packingCharge : null);

                              final selectedChild = context.read<CategoryProvider>().selectedChildCategory;

                              final cartItem = CartItemModel(
                                  id: product.id,
                                  name: product.name,
                                  images: [product.image],
                                  categoryId: product.categoryId,
                                  price: isTakeAway
                                      ? (selectedProvider.selectedPrices ?? 0.0)
                                      : (selectedProvider.selectedPrices ?? 0.0),
                                  quantity: selectedProvider.quantity,
                                  isCombo: false,
                                  takeAwayPrice: packingChargeValue,
                                  // takeAwayPrice: selectedChild?.takeAwayPrice,
                                  subCategoryId: selectedChild?.subCategoryId ?? 0,
                                  childCategoryId: selectedChild?.id.toString(),      // 👈 pass child id if selected
                                  childCategoryName: selectedChild?.name,
                                  totalDeliveryTime:totalTime
                              );
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
                                fontSize: 17,
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
              Colors.grey,
              valueIndicatorColor: AppColor.primaryColor,
// Hide default inactive track color

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


  void showSortByDialog(BuildContext context) {
    String selectedOption = 'Popular';
    List<String> options = [
      'Popular',
      'Newest',
      'Price: Lowest to high',
      'Price: Highest to low',
    ];

    showGeneralDialog(
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
                  padding: const EdgeInsets.only(top: 16,bottom: 16),
                  decoration: const BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColor.secondary, AppColor.primaryColor],
                      begin: AlignmentDirectional(0.0, -2.0), // top-center
                      end: AlignmentDirectional(0.0, 1.0), // bottom-center

                      stops: [0.0, 1.0], // smooth gradient
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20), bottom: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
                        child: Row(
                          children: [
                            // This ensures the "Sort By" text stays centered
                            Expanded(
                              child: Text(
                                'Sort By',
                                textAlign: TextAlign.center, // Centers text within Expanded
                                style: AppStyle.textStyleReemKufi.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.whiteColor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                AppImage.cross,height: 20,width: 20,),
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
                          color: isSelected ? Colors.white : Colors.transparent, // selected background
                          child: ListTile(
                            title: Text(
                              option,
                              style: AppStyle.textStyleReemKufi.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isSelected ? AppColor.primaryColor : AppColor.whiteColor, // text color
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4, // 40% of screen width
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedOption = '';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
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
                              width: MediaQuery.of(context).size.width * 0.4, // 40% of screen width
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, selectedOption);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
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
}


