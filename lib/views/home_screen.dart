import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ravathi_store/models/product_model.dart';
import 'package:ravathi_store/utlis/App_color.dart';
import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/utlis/widgets/loading_circle.dart';
import 'package:ravathi_store/views/selection_screen.dart';
import 'package:ravathi_store/views/view_order_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/add_on.dart';
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
import '../utlis/widgets/app_text_style.dart';
import '../utlis/widgets/custom_exit_dialog.dart';
import '../utlis/widgets/floating_message.dart';
import '../utlis/widgets/responsiveness.dart';
import '../utlis/widgets/shimmer_loading.dart';
import '../utlis/widgets/snack_bar.dart';
import 'bucket_page.dart';
import 'buy_one_get_one.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'combo.dart';
import 'combo_offer_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  Timer? _debounce;
  int _hintIndex = 0;
  Timer? _hintTimer;
  Timer? _hintDebounce;
  bool _isTakeAway = false;

  final List<String> _hints = [
    "Craving something? Find it here 🍔",
    "Search your favorite meal 🍕",
    "What’s for dinner tonight? 🍱",
    "Find delicious combos 🌮",
  ];
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
          context, null, null, null); // load all items initially
      provider.getBannerImage(context);
      provider.getCategorys(context);
      final prefHelper = getIt<SharedPreferenceHelper>();
      final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
      _isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
      orderImage = _isTakeAway ? AppImage.takeaway : AppImage.dinein;
      setState(() {
        orderText = isTakeAway ? "Takeaway" : "Dine-In";
        orderImage = isTakeAway ? AppImage.takeaway : AppImage.dinein;
      });
    });
    _hintTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _hintIndex = (_hintIndex + 1) % _hints.length;
      });
    });
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _hintDebounce?.cancel();
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = context.watch<DashboardProvider>().homeBanner;
    final cartProvider = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    double subTotal = cartProvider.subTotal;

    double searchHeight = screenWidth * 0.05;
    double fontSize = screenWidth * 0.018; // 1.8% of width
    double iconSize = screenWidth * 0.025;
    double filterIconSize = screenWidth * 0.025;
    double horizontalPadding = screenWidth * 0.010;

    final responsive = Responsiveness(context);

// Horizontal padding: left + right + spacing
    final horizontalPaddings = 12 * 3;
    final cardWidth = (screenWidth - horizontalPaddings) / 2;

// Dynamic height proportional to width
    final cardHeight = cardWidth * 0.99;
    return SafeArea(
      child: PopScope(
        canPop: false, // prevent direct pop
        onPopInvoked: (didPop) async {
          if (didPop) return;

          /// Show custom exit dialog and wait for result
          final shouldExit = await showExitDialog(context);

          if (shouldExit == true) {
            final categoryProvider =
            Provider.of<CategoryProvider>(context, listen: false);
            categoryProvider.setQuantity(1);
            cartProvider.clearCart();
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
                            final categoryProvider =
                            Provider.of<CategoryProvider>(context,
                                listen: false);
                            categoryProvider.setQuantity(1);
                            cartProvider.clearCart();
                            Navigator.of(context).pop();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SelectionScreen()),
                            );
                          }
                        } else {
                          final categoryProvider =
                          Provider.of<CategoryProvider>(context,
                              listen: false);
                          categoryProvider.setQuantity(1);
                          cartProvider.clearCart();
                          Navigator.of(context).pop();

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
                            ? 190
                            : 100,
                      ),
                    ),
                    SizedBox(width: horizontalPadding),
                  ],
                ),
              ),
              actions: [
            Padding(
            padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTapDown: (TapDownDetails details) async {
              // Decide the opposite option for the popup
              String alternativeOption = _isTakeAway ? "Dine In" : "Takeaway";

              final selected = await showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                ),
                color: AppColor.whiteColor,
                items: [
                  PopupMenuItem(
                    value: alternativeOption,
                    child: Text(
                      alternativeOption,
                      style: AppTextStyles.latoBold(
                        isDesktop ? 18 : 14,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                ],
              );

              if (selected != null) {
                setState(() {
                  orderText = selected;
                  _isTakeAway = selected == "Takeaway";
                  orderImage = _isTakeAway ? AppImage.takeaway : AppImage.dinein;
                });
                final categoryProvider =
                Provider.of<CategoryProvider>(context, listen: false);
                categoryProvider.setQuantity(1);
                cartProvider.clearCart();
                await getIt<SharedPreferenceHelper>().storeBoolData(
                  key: StorageKey.isTakeAway,
                  value: _isTakeAway,
                );
               // pr
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColor.secondary, AppColor.primaryColor],
                  begin: AlignmentDirectional(0.0, -2.0),
                  end: AlignmentDirectional(0.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: isDesktop ? 36 : isTablet ? 32 : 28,
                    height: isDesktop ? 36 : isTablet ? 32 : 25,
                    child: SvgPicture.asset(
                      orderImage,
                      fit: BoxFit.fill,
                      color: AppColor.whiteColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    orderText,
                    style: AppTextStyles.nunitoBold(
                      isDesktop ? 20 : isTablet ? 18 : 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
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
                    ? 22
                    : 18;
                final double buttonFontSize = isDesktop
                    ? 22
                    : isTablet
                    ? 22
                    : 17;
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

                // return Container(
                //   height: barHeight,
                //   padding: EdgeInsets.symmetric(
                //     horizontal: paddingHorizontal,
                //     vertical: paddingVertical,
                //   ),
                //   decoration: const BoxDecoration(
                //     gradient: const LinearGradient(
                //       colors: [
                //         AppColor.secondary, // Top color
                //         AppColor.primaryColor // Fade out below
                //       ],
                //       begin: Alignment.topCenter, // Start at the very top
                //       end: Alignment.bottomCenter, // End at the bottom
                //       stops: [0.0, 0.5], // 0.0 = start, 0.4 = 40% height
                //       tileMode: TileMode.clamp,
                //     ),
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(20),
                //       topRight: Radius.circular(20),
                //     ),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black12,
                //         blurRadius: 6,
                //         offset: Offset(0, -2),
                //       ),
                //     ],
                //   ),
                //   child: Row(
                //     children: [
                //       // Price Box
                //       Container(
                //         padding: EdgeInsets.symmetric(
                //           horizontal: isDesktop ? 16 : 12,
                //           vertical: isDesktop ? 10 : 4,
                //         ),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             ShaderMask(
                //               shaderCallback: (bounds) => const LinearGradient(
                //                 colors: [
                //                   AppColor.primaryColor,
                //                   AppColor.primaryColor
                //                 ],
                //               ).createShader(Rect.fromLTWH(
                //                   0, 0, bounds.width, bounds.height)),
                //               child: Text(
                //                 'Price',
                //                 style: AppStyle.textStyleReemKufi.copyWith(
                //                   color: Colors.white,
                //                   fontSize: titleFontSize,
                //                   fontWeight: FontWeight.w700,
                //                 ),
                //               ),
                //             ),
                //             ShaderMask(
                //               shaderCallback: (bounds) => const LinearGradient(
                //                 colors: [
                //                   AppColor.primaryColor,
                //                   AppColor.primaryColor
                //                 ],
                //                 stops: [0.10, 0],
                //               ).createShader(Rect.fromLTWH(
                //                   0, 0, bounds.width, bounds.height)),
                //               child: Text(
                //                 '₹${subTotal.toStringAsFixed(2)}',
                //                 style: AppStyle.textStyleReemKufi.copyWith(
                //                   color: Colors.white,
                //                   fontSize: priceFontSize,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //
                //       const SizedBox(width: 15),
                //
                //       // Cart Button
                //       Expanded(
                //         child: Container(
                //           height: 60,
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //           child: ElevatedButton(
                //             onPressed: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (_) => const ViewOrderScreen()),
                //               );
                //             },
                //             style: ElevatedButton.styleFrom(
                //               backgroundColor: AppColor.whiteColor,
                //               foregroundColor: AppColor.whiteColor,
                //               elevation: 0,
                //               padding: EdgeInsets.symmetric(
                //                 horizontal: buttonPaddingH,
                //                 vertical: buttonPaddingV,
                //               ),
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(12),
                //               ),
                //             ),
                //             child: ShaderMask(
                //               shaderCallback: (bounds) => const LinearGradient(
                //                 colors: [
                //                   AppColor.primaryColor,
                //                   AppColor.primaryColor
                //                 ],
                //                 stops: [0.60, 0],
                //                 begin: Alignment.topCenter,
                //                 end: Alignment.bottomRight,
                //               ).createShader(Rect.fromLTWH(
                //                   0, 0, bounds.width, bounds.height)),
                //               child: Text(
                //                 'Go To Cart',
                //                 style: AppStyle.textStyleReemKufi.copyWith(
                //                   color: Colors.white,
                //                   fontSize: buttonFontSize,
                //                   fontWeight: FontWeight.w600,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // );
                return LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;

                    // 30% for Price container
                    double priceWidth = screenWidth * 0.2;

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
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.5],
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
                          // Price Box - 30% of width
                          SizedBox(
                            width: isTablet
                                ? priceWidth // If device is a tablet → use calculated priceWidth
                                : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 16 : 12,
                                vertical: isDesktop ? 10 : 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                          colors: [
                                            AppColor.primaryColor,
                                            AppColor.primaryColor
                                          ],
                                        ).createShader(Rect.fromLTWH(
                                            0, 0, bounds.width, bounds.height)),
                                    child: Text(
                                      'Price',
                                      style:
                                      AppStyle.textStyleReemKufi.copyWith(
                                        color: Colors.white,
                                        fontSize: responsive.priceTitle,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                          colors: [
                                            AppColor.primaryColor,
                                            AppColor.primaryColor
                                          ],
                                          stops: [0.10, 0],
                                        ).createShader(Rect.fromLTWH(
                                            0, 0, bounds.width, bounds.height)),
                                    child: Text(
                                      '₹${subTotal.toStringAsFixed(2)}',
                                      style:
                                      AppStyle.textStyleReemKufi.copyWith(
                                        color: Colors.white,
                                        fontSize: responsive.priceTotal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          // Cart Button - Remaining width
                          Expanded(
                            child: Container(
                              height: isTablet ? 65 : 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                        const ViewOrderScreen()),
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
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
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
                                      fontSize: responsive.priceTotal,
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
                                const SizedBox(width: 10),/// when user search the serch filed cse not set the firsr catgeotyid
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      // 🔹 Animated hint text
                                      IgnorePointer(
                                        child: AnimatedTextKit(
                                          key: ValueKey('hintText'),
                                          animatedTexts: _hints.map((hint) {
                                            return FadeAnimatedText(
                                              hint,
                                              textStyle: AppTextStyles.nunitoRegular(
                                                responsive.hintTextSize,
                                                color: AppColor.lightGreyColor,
                                              ),
                                              duration: const Duration(seconds: 2),
                                            );
                                          }).toList(),
                                          repeatForever: true,
                                          pause: const Duration(seconds: 1),
                                          isRepeatingAnimation: true,
                                          displayFullTextOnTap: false,
                                          stopPauseOnTap: false,
                                        ),
                                      ),

                                      // 🔹 Actual TextField
                                      TextField(
                                        controller: _searchController,
                                        focusNode: _searchFocusNode,
                                        textAlign: TextAlign.start,
                                        style: AppStyle.textStyleReemKufi.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: fontSize.clamp(14, 20),
                                          color: AppColor.blackColor,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintText: '', // remove static hint
                                        ),
                                        onChanged: (value) {
                                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                                          _debounce = Timer(const Duration(milliseconds: 600), () {
                                            final provider = Provider.of<DashboardProvider>(
                                              context,
                                              listen: false,
                                            );
                                            provider.getSearchProduct(context, value, null);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                )


                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        // Filter Button
                        Container(
                          margin: EdgeInsets.only(right: horizontalPadding),
                          height: isTablet ? 47 : 47,
                          width: isTablet ? 47 : 47,
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
                      ?  Center(child: LoadingCircle())
                      : banners.isEmpty
                      ? const Center(
                    child: Text(
                      "No banners available",
                      style:
                      TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                      : SizedBox(
                    height: cardHeight, // let the card control height
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      // physics: const NeverScrollableScrollPhysics(),
                      padding:
                      const EdgeInsets.only(left: 12, right: 15),
                      itemCount: banners.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final banner = banners[index];
                        return _buildPromoCard(
                          imagePath: banner.image,
                          context: context,
                          onTap: () {
                            final provider = Provider.of<DashboardProvider>(context, listen: false);

// Common setup before navigation
                            _searchFocusNode.unfocus();
                            _searchController.clear();
                            provider.selectCategory(-1); // Preselect 'All'
                            provider.getCategoryBasedItems(context, null, null, null);

// Navigate based on index
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => BuyOneGetOne()),
                              );
                            } else if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ComboOfferScreen()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => BucketPage()), // Default page for other indexes
                              );
                            }

                            // if (index == 0) {
                            //   final provider = Provider.of<DashboardProvider>(context, listen: false);
                            //   _searchFocusNode.unfocus();
                            //   _searchController.clear();
                            //   provider.selectCategory(-1); // preselect All
                            //   provider.getCategoryBasedItems(
                            //       context, null, null, null); // load all items initially
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => BuyOneGetOne()),
                            //   );
                            // } else {
                            //   final provider = Provider.of<DashboardProvider>(context, listen: false);
                            //   _searchFocusNode.unfocus();
                            //   _searchController.clear();
                            //   provider.selectCategory(-1); // preselect All
                            //   provider.getCategoryBasedItems(
                            //       context, null, null, null);
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) =>
                            //             ComboOfferScreen()),
                            //   );
                            // }
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
                                aspectRatio = 0.75;
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
                              aspectRatio = 0.75;
                            } else {
                              crossAxisCount = 2;
                              aspectRatio = 0.704;
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
                                          GestureDetector(
                                            onTap:(){
                                              _searchFocusNode.unfocus();
                                              _searchController.clear();
                                              showBurgerDialog(
                                                  context, product);
                                    },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColor.whiteColor,
                                                borderRadius:
                                                BorderRadius.circular(30),
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
                                                      aspectRatio: 1.4,
                                                      child: LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          final screenWidth =
                                                              MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width;
                                                          final screenHeight =
                                                              MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height;

                                                          // Example logic: Adjust size based on screen width
                                                          double imageWidth;
                                                          double imageHeight;

                                                          if (screenWidth >
                                                              1000) {
                                                            // Large screens (like tablets or desktops)
                                                            imageWidth =
                                                                screenWidth *
                                                                    0.25;
                                                            imageHeight =
                                                                screenHeight *
                                                                    0.25;
                                                          } else if (screenWidth >
                                                              600) {
                                                            // Medium screens
                                                            imageWidth =
                                                                screenWidth *
                                                                    0.35;
                                                            imageHeight =
                                                                screenHeight *
                                                                    0.20;
                                                          } else {
                                                            // Small screens (like phones)
                                                            imageWidth =
                                                                screenWidth *
                                                                    0.45;
                                                            imageHeight =
                                                                screenHeight *
                                                                    0.18;
                                                          }

                                                          return  SizedBox(
                                                            width: imageWidth,
                                                            height: imageHeight,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12),
                                                              child:
                                                             CachedNetworkImage(
                                                                imageUrl: "${ApiEndpoints.imageBaseUrl}${product.image}",
                                                          placeholder: (context, url) => const Center(
                                                          child: Icon(
                                                          Icons.image, // or any icon you like
                                                          color: Colors.grey,
                                                          size: 40,
                                                          ),),
                                                                errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                                                                // Optional: fit the image
                                                                //fit: BoxFit.cover, // or BoxFit.fill if you want
                                                              )
                                                            ),
                                                          );
                                                        },
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
                                                      style: AppTextStyles
                                                          .nunitoBold(
                                                          responsive.adOn,
                                                          color:
                                                          Colors.black),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      product.description ??
                                                          "", // show description
                                                      textAlign: TextAlign.center,
                                                      style: AppTextStyles
                                                          .latoRegular(
                                                          responsive.des,
                                                          color:
                                                          Colors.black),

                                                      maxLines: 2,
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
                                                          fontSize:
                                                          responsive.adOn,
                                                          color:
                                                          AppColor.blackColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            bottom:1,
                                            right: 1,
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

    // Two cards per row, full width minus padding
    final horizontalPadding = 12 * 3; // left + right + space between
    final cardWidth = (screenWidth - horizontalPadding) / 2;

    // Height proportional to width
    final cardHeight = cardWidth * 0.56;

    // Detect tablet/desktop if needed for button/font size
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 4,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:

      CachedNetworkImage(
      imageUrl: "${ApiEndpoints.imageBaseUrl}$imagePath",
        fit: BoxFit.cover, // fills card exactly
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => ShimmerWidget.rectangular(
          width: cardWidth,
          height: cardHeight,
          borderRadius: BorderRadius.circular(16),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.broken_image, size: 40),
        ),
      ),

      // child: Image.network(
                //   "${ApiEndpoints.imageBaseUrl}$imagePath",
                //   fit: BoxFit.cover, // fills card exactly
                //   loadingBuilder: (context, child, progress) {
                //     if (progress == null) return child;
                //     return ShimmerWidget.rectangular(
                //       width: cardWidth,
                //       height: cardHeight,
                //       borderRadius: BorderRadius.circular(16),
                //     );
                //   },
                //   errorBuilder: (context, error, stackTrace) {
                //     return const Center(
                //         child: Icon(Icons.broken_image, size: 40));
                //   },
                // ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 25 : 20),
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
                        : 10,
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
                        : 14,
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
    final formattedTitle = (title ?? '').trim();
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
                (title.isNotEmpty)
                    ? title[0].toUpperCase() +
                    title.substring(1).toLowerCase()
                    : '',
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
                  blurRadius: 4, // how soft the shadow looks
                  spreadRadius: 1, // how wide the shadow spreads
                  offset: const Offset(0, 4), // position of shadow (x, y)
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (title.isNotEmpty)
                      ? title[0].toUpperCase() +
                      title.substring(1).toLowerCase()
                      : '',
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

    final cartItem = cartProvider.getCartItemById(product.id, sourcePage: 'home',);
    final categoryProvider = context.read<CategoryProvider>();
    if (cartItem != null) {
      categoryProvider.setHeatLevel(cartItem.heatLevel ?? 0);

      final matchedChild = product.childCategory
          .cast<ChildCategory?>() // allow nullable temporarily
          .firstWhere(
            (child) => child?.id.toString() == cartItem.childCategoryId.toString(),
        orElse: () => null,
      );
      categoryProvider.setSelectedChildCategorys(matchedChild,
          productId: product.id);

      // Restore quantity
      categoryProvider.setQuantity(cartItem.quantity);
    } else {
      categoryProvider.setHeatLevel(0);
      categoryProvider.setSelectedChildCategorys(null, productId: product.id);
      categoryProvider.setQuantity(1);
      //}
    }

    // Check if product is already in cart and get current quantity
    // final cartItem = cartProvider.getCartItemById(product.id);
    // if (cartItem != null) {
    //   // Set dialog quantity to existing cart quantity
    //   selectedProvider.setQuantity(cartItem.quantity);
    // } else {
    // } else {
    //   selectedProvider.setQuantity(1);
    // }

    final screenHeight = MediaQuery.of(context).size.height;

    final responsive = Responsiveness(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;

    final double priceBoxHeight = isTablet ? screenHeight * 0.050 :screenHeight * 0.070; // 8% of screen height
    final double addToCartHeight =  isTablet ? screenHeight * 0.050 :screenHeight * 0.070;
    final double buttonFontSize = isDesktop
        ? 25
        : isTablet
        ? 17
        : 16;
    final double priceSize = isDesktop
        ? 27
        : isTablet
        ? 20
        : 20;
    final double description = isDesktop
        ? 20
        : isTablet
        ? 15
        : 15;
    List<String> selectedAddOns = [];
    double addOnsTotal = 0.0;
    final buttonKey = GlobalKey();
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
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
                    double priceWidth = screenWidth * 0.2;
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
                              //  end: Alignment.bottomRight,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.6,
                                0.25
                              ], // 👈 transition from primary → secondary at 70% height
                            ),
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          child: Stack(children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  //     margin: const EdgeInsets.only(top:16.0),
                                  height: screenHeight * 0.29,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(AppImage.bgImg),
                                      fit: BoxFit
                                          .cover, // Cover the entire container
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
                                    borderRadius: BorderRadius.only(
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
                                            top: Radius.circular(80),
                                          ),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              // Dynamically set image size based on container height
                                              final double imageSize =
                                                  constraints.maxHeight * 0.6;


                                                  return Center(
                                              child: CachedNetworkImage(
                                              imageUrl: "${ApiEndpoints.imageBaseUrl}${product.image}",
                                              height: imageSize,
                                              width: imageSize,
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) => const Center(
                                                child: CircularProgressIndicator(),
                                              ),
                                              errorWidget: (context, url, error) => const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              ),
                                              ),
                                              );
                                            },
                                          ),
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
                                      padding:
                                      EdgeInsets.all(screenWidth * 0.04),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
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
                                                    style: AppTextStyles
                                                        .nunitoBold(
                                                        responsive
                                                            .mainTitleSize,
                                                        color: AppColor
                                                            .blackColor),
                                                  ),
                                                ),
                                                Text(
                                                  "₹${(double.tryParse(product.price ?? '0') ?? 0.0).toStringAsFixed(2)}",
                                                  style:
                                                  AppTextStyles.nunitoBold(
                                                      responsive
                                                          .mainTitleSize,
                                                      color: AppColor
                                                          .blackColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 0),
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    final bool
                                                    isDescriptionLong =
                                                        product.description
                                                            .length >
                                                            350;
                                                    final String
                                                    displayDescription =
                                                    isExpanded ||
                                                        !isDescriptionLong
                                                        ? product
                                                        .description
                                                        : '${product.description.substring(0, 350)}...';

                                                    if (isDescriptionLong) {
                                                      // Long description -> show in column
                                                      return Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(
                                                            displayDescription,
                                                            maxLines: isExpanded
                                                                ? null
                                                                : 4,
                                                            overflow:
                                                            TextOverflow
                                                                .visible,
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: AppTextStyles
                                                                .latoRegular(
                                                                responsive
                                                                    .des,
                                                                color: AppColor
                                                                    .lightGreyColor),
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
                                                                product
                                                                    .description,
                                                                // maxLines: 4,
                                                                // overflow: TextOverflow.ellipsis,
                                                                style: AppTextStyles
                                                                    .latoRegular(
                                                                    responsive
                                                                        .des,
                                                                    color: AppColor
                                                                        .lightGreyColor)),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),

                                                          /// Prep Time
                                                        ],
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          if (product.time != null ||
                                              product.takeAwayPrice !=
                                                  null) ...[
                                            const SizedBox(
                                              height: 4,
                                            ),
                                          ],

                                          if (product.time != null &&
                                              product.time!.trim().isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0, top: 8),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    AppImage.time,
                                                    height: 20,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    product.time!
                                                        .toLowerCase()
                                                        .contains("mins")
                                                        ? product.time!
                                                        : "${product.time} mins",
                                                    style: AppTextStyles
                                                        .latoRegular(
                                                        responsive.time,
                                                        color: AppColor
                                                            .darkGreyColor),
                                                  ),
                                                  const SizedBox(width: 9),
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
                                                          builder: (context) {
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
                                                              style: AppTextStyles
                                                                  .latoRegular(
                                                                  responsive
                                                                      .time,
                                                                  color: AppColor
                                                                      .darkGreyColor),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),

                                          if (product.childCategory != null &&
                                              product.childCategory
                                                  .isNotEmpty) ...[
                                            SizedBox(
                                                height: screenHeight * 0.025),

                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: product.childCategory.map((child) {
                                                    final provider = context.watch<CategoryProvider>();
                                                    var selectedChild = provider.selectedChildCategory;

                                                    return _buildOptionBox(
                                                      child.name,
                                                      "₹${(child.price ?? 0).toStringAsFixed(0)}",
                                                      isSelected: selectedChild?.id == child.id, // ✅ Shows selected state
                                                      onTap: () {
                                                        final categoryProvider = context.read<CategoryProvider>();

                                                        // 🟢 Toggle selection
                                                        if (selectedChild?.id == child.id) {
                                                          // If the same child is tapped again -> deselect it
                                                          categoryProvider.setSelectedChildCategory(null);
                                                          print("❌ Deselected child category: ${child.name}");

                                                          // Reset quantity when deselected
                                                          categoryProvider.setQuantity(cartItem?.quantity ?? 1);
                                                          categoryProvider.setHeatLevel(cartItem?.heatLevel ?? 0);
                                                        } else {
                                                          // If a different child is tapped -> select it
                                                          categoryProvider.setSelectedChildCategory(child);
                                                          print("✅ Selected child category: ${child.name}");
                                                          // Update quantity based on cart
                                                          final cartItem = cartProvider.getCartItemById(
                                                            product.id,
                                                            childCategoryId: child.id.toString(),
                                                          );

                                                          if (cartItem != null) {
                                                            categoryProvider.setHeatLevel(cartItem.heatLevel ?? 0);
                                                            categoryProvider.setQuantity(cartItem.quantity);
                                                            print("🛒 Cart quantity found: ${cartItem.quantity}");
                                                          } else {
                                                            categoryProvider.setQuantity(1);
                                                            categoryProvider.setHeatLevel(0);
                                                            print("➕ Default quantity set to 1");
                                                          }
                                                        }
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            )
                                          ],
                                          SizedBox(
                                              height: screenHeight * 0.025),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Row(
                                              children: [
                                                Visibility(
                                                  visible: product.spicy == "0",
                                                  child: Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        // Spicy Label with left padding
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 15.0),
                                                          child: Text("Spicy Level",
                                                              style: AppTextStyles
                                                                  .nunitoMedium(
                                                                  responsive
                                                                      .subtitleSize,
                                                                  color: AppColor
                                                                      .blackColor)),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        // HeatLevelSelector fills width but no left padding here
                                                        HeatLevelSelector(
                                                            context),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 17.0,
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
                                                                  responsive
                                                                      .hintTextSize,
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
                                                                  responsive
                                                                      .hintTextSize,
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
                                                                  responsive
                                                                      .hintTextSize,
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
                                                            style: AppTextStyles
                                                                .nunitoMedium(
                                                                responsive
                                                                    .subtitleSize,
                                                                color: AppColor
                                                                    .blackColor),
                                                          ),/// in home screen i have different product one roduct id is 1 and i have another age that age inclue may peouct thta product have same product id in this case when added product to cart time then add same productid add case first added product is override
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              _buildIconButton(
                                                                  Icons.remove,
                                                                      () {
                                                                    selectedProvider
                                                                        .decreaseQuantity();
                                                                  }),
                                                              const SizedBox(
                                                                  width: 12),
                                                              Consumer<
                                                                  CategoryProvider>(
                                                                builder:
                                                                    (context,
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
                                                                      fontSize:
                                                                      20,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                  width: 12),
                                                              _buildIconButton(
                                                                  Icons.add,
                                                                      () {
                                                                    selectedProvider
                                                                        .increaseQuantity();
                                                                  }),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 28,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final result = await showAddOnDialog(
                                      context,
                                      product,
                                      initialSelectedAddOns:
                                      cartItem?.addOnNames,
                                    );
                                    if (result != null) {
                                      setState(() {
                                        selectedAddOns =
                                        result['selectedAddOns']
                                        as List<String>;
                                        addOnsTotal =
                                        result['addOnsTotal'] as double;
                                        cartItem?.addOnNames = selectedAddOns;
                                      });
                                      print(
                                          "Selected Add-Ons: $selectedAddOns");
                                    }
                                  },
                                  // Navigate or open add-ons screen
                                  // Navigator.pop(context);
                                  // Future.delayed(
                                  //     const Duration(milliseconds: 200), () {
                                  //   showAddOnDialog(context,
                                  //       product); // Your add-on dialog
                                  // });

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
                                          SvgPicture.asset(AppImage.addOn,
                                              height: responsive.mainTitleSize),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text("Add Add-Ons",
                                                  style: AppTextStyles.latoBold(
                                                      responsive.hintTextSize,
                                                      color:
                                                      AppColor.blackColor)),
                                              Text(
                                                  "Make It Special — Choose Your Add-Ons Now!",
                                                  style:
                                                  AppTextStyles.latoMedium(
                                                      responsive.time,
                                                      color: AppColor
                                                          .lightGreyColor)),
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
                                    vertical: screenHeight * 0.0100,
                                  ),
                                  decoration: const BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.secondary, // Top color
                                        AppColor.primaryColor // Fade out below
                                      ],
                                      begin: Alignment
                                          .topCenter, // Start at the very topf
                                      end: Alignment
                                          .bottomCenter, // End at the bottom
                                      stops: [
                                        0.0,
                                        0.5
                                      ], // 0.0 = start, 0.4 = 40% height
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
                                        width: isTablet
                                            ? priceWidth // If device is a tablet → use calculated priceWidth
                                            : null,
                                        height: priceBoxHeight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                                    fontSize:responsive.priceTitle,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ),
                                            Selector<CategoryProvider, double>(
                                              selector: (context, provider) {
                                                final prefHelper = getIt<
                                                    SharedPreferenceHelper>();
                                                final isTakeAway = prefHelper
                                                    .getBool(StorageKey
                                                    .isTakeAway) ??
                                                    false;

                                                // If TakeAway is true, use totalPrice else use totalPrices
                                                return isTakeAway
                                                    ? provider
                                                    .totalPriceWithTakeWay
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
                                                      fontSize: responsive.priceTotal,
                                                      fontWeight:
                                                      FontWeight.bold,
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
                                          key: buttonKey,
                                          height: addToCartHeight,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              final snackBar = ShowSnackBar();
                                              print(
                                                  "Selected Add-Ons: $selectedAddOns");
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
                                                  images: [product.image],
                                                  categoryId:
                                                  product.categoryId,
                                                  price: isTakeAway
                                                      ? (selectedProvider
                                                      .selectedPrice ??
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

                                                  // takeAwayPrice:
                                                  //     selectedChild?.takeAwayPrice,
                                                  // subCategoryId: selectedChild
                                                  //         ?.subCategoryId ??
                                                  //     0,
                                                  subCategoryId: product.id,
                                                  childCategoryId: selectedChild?.id
                                                      .toString(),
                                                  childCategoryName:
                                                  selectedChild?.name,
                                                  isCombo: null,
                                                  heatLevel: selectedProvider.selectedHeatLevel,
                                                  totalDeliveryTime: totalTime,
                                                  type: "normal",
                                                  discountPrice: product.price,
                                                  addOnNames: selectedAddOns,
                                                  addOnPrices: selectedAddOns
                                                      .map((name) {
                                                    final addOn =
                                                    addOns.firstWhere((e) =>
                                                    e.name == name);
                                                    return addOn.price;
                                                  }).toList(),
                                                  prepareTime: product.time);
                                              final wasAdded = cartProvider
                                                  .isDuplicate(cartItem, sourcePage: "home");

                                              if (!wasAdded) {
                                                cartProvider.addToCart(context,
                                                    cartItem,sourcePage: "home"); // Add only if not duplicate
                                                Navigator.of(context)
                                                    .pop();
                                                snackBar.customSnackBar(
                                                  context: context,
                                                  type: "1",
                                                  strMessage: 'Item Added',
                                                );// Close the dialog
                                              } else {
                                                FloatingMessage.show(
                                                  context: context,
                                                  key: buttonKey,
                                                  message:
                                                  'Product already added with same quantity!',
                                                );
                                                // Optional: showAboveButton(context, buttonKey, 'Product already added with same quantity!');
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                              AppColor.whiteColor,
                                              foregroundColor:
                                              AppColor.whiteColor,
                                              elevation: 0,
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 28,
                                                  vertical: 14),
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
                                                style: AppStyle
                                                    .textStyleReemKufi
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontSize: responsive.priceTotal,
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
                                margin: const EdgeInsets.only(
                                    top: 20), // spacing from status bar
                                height: 5,
                                width: isTablet ? 100 : 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2.5),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              top: 16,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: SvgPicture.asset(
                                  AppImage.cross,
                                  height: isTablet ? 30 : 20,
                                ),
                              ),
                            ),
                          ]),
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
        image: AppImage.all,
      ),
      ...categories,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        // Adjust list height based on screen width
        double listHeight;
        if (screenWidth < 400) {
          listHeight = 130; // Small phone
        } else if (screenWidth < 600) {
          listHeight = 150; // Large phone / small tablet
        } else {
          listHeight = 170; // Tablet
        }

        // Adjust item width dynamically
        double itemWidth;
        if (screenWidth < 400) {
          itemWidth = 70;
        } else if (screenWidth < 600) {
          itemWidth = 90;
        } else {
          itemWidth = 110;
        }

        return SizedBox(
          height: listHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(context, allCategories[index],
                  selectedCategoryId: selectedCategoryId,
                  fixedSize: itemWidth,
                  searchController: _searchController);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(
      BuildContext context,
      CategoryModel cat, {
        double? fixedSize,
        required TextEditingController searchController,
        required int? selectedCategoryId,
      }) {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    final isSelected = selectedCategoryId == cat.id;
    final responsive = Responsiveness(context);
    return GestureDetector(
      onTap: () async {
        provider.selectCategory(cat.id);
        await provider.getCategoryBasedItems(
            context,
            cat.id == -1 ? null : cat.id,
            provider.selectedSort,
            searchController.text);
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

                // ],
              ),
              child: cat.id == -1
                  ? Image.asset(
                AppImage.all, // ✅ Asset image for "All" option
                //  fit: BoxFit.cover,
              )
              //     : Image.network(
              //   cat.image.startsWith("https")
              //       ? cat.image
              //       : "${ApiEndpoints.imageBaseUrl}${cat.image}",
              //   //  fit: BoxFit.cover,
              //   errorBuilder: (context, error, stackTrace) =>
              //   const Icon(Icons.image_not_supported, size: 30),
              // ),
              :CachedNetworkImage(
                imageUrl: cat.image.startsWith("https")
                    ? cat.image
                    : "${ApiEndpoints.imageBaseUrl}${cat.image}",
                // fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: Icon(
                    Icons.image, // or any icon you like
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported,
                  size: 30,
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
              style: AppTextStyles.nunitoMedium(responsive.category,
                  color:
                  isSelected ? AppColor.primaryColor : Colors.black87)
                  .copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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

  Widget HeatLevelSelector(BuildContext context) {
    final heatProvider = context.watch<CategoryProvider>(); // ✅ use Provider

    final List<String> heatLabels = ['Mild', 'Medium', 'Hot'];

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 8,
        activeTrackColor: AppColor.primaryColor,
        inactiveTrackColor: Colors.grey,
        valueIndicatorColor: AppColor.primaryColor,
        thumbColor: AppColor.primaryColor,
      ),
      child: Slider(
        value: heatProvider.selectedHeatLevel.toDouble(),
        min: 0,
        max: 2,
        divisions: 2,
        label: heatLabels[heatProvider.selectedHeatLevel],
        onChanged: (double value) {
          heatProvider.setHeatLevel(value.round());
        },
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
      crossAxisAlignment: CrossAxisAlignment.end,
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
  final shouldExit = await CustomActionDialog.show(
    context: context,
    title: "Leaving so soon? Do you want to exit the app?",
    iconColor: Colors.orange,
    cancelText: "No, Stay",
    confirmText: "Yes, Exit",
    imagePath: AppImage.logout,
  );

  return shouldExit ?? false; // Return false if null
}

Future<String?> showSortByDialog(BuildContext context, String currentSort) {
  final responsive = Responsiveness(context);
  String selectedOption = currentSort;
  final screenSize = MediaQuery.of(context).size;
  final screenWidth = screenSize.width;
  final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
  final provider = Provider.of<DashboardProvider>(context, listen: false);
  List<String> options = [
    'Popular',
    'Newest',
    'Price: Lowest to high',
    'Price: Highest to low',
  ];

  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Sort By",
    pageBuilder: (context, anim1, anim2) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: responsive.isMobile
                    ? double.infinity // Full width for mobile
                    : MediaQuery.of(context).size.width * 0.80,
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
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 16, left: 16, right: 16),
                      child: Row(
                        children: [
                          // This ensures the "Sort By" text stays centered
                          Expanded(
                            child: Text(
                              'Sort By',
                              textAlign: TextAlign
                                  .center, // Centers text within Expanded
                              style: AppTextStyles.nunitoBold(
                                responsive.mainTitleSize,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              AppImage.cross,
                              height: responsive.mainTitleSize,
                              width: responsive.mainTitleSize,
                            ),
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
                            style: AppTextStyles.nunitoMedium(
                              responsive.subtitleSize,
                              color: isSelected
                                  ? AppColor.primaryColor
                                  : AppColor.whiteColor,
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
                        mainAxisAlignment: isTablet
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: responsive.isMobile
                                ? MediaQuery.of(context).size.width *
                                0.40 // wider on mobile
                                : MediaQuery.of(context).size.width *
                                0.3, // normal on tablet/desktop
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
                                style: AppTextStyles.nunitoRegular(
                                  responsive.subtitleSize,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          // const Spacer(),
                          SizedBox(
                            width: responsive.isMobile
                                ? MediaQuery.of(context).size.width *
                                0.40 // wider on mobile
                                : MediaQuery.of(context).size.width *
                                0.3, // normal on tablet/desktop
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
                                style: AppTextStyles.nunitoBold(
                                  responsive.subtitleSize,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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

Future<Map<String, dynamic>?> showAddOnDialog(
    BuildContext context, Item product,
    {List<String>? initialSelectedAddOns}) {
  final selectedProvider =
  Provider.of<CategoryProvider>(context, listen: false);
  final responsive = Responsiveness(context);
  final screenSize = MediaQuery.of(context).size;
  final screenHeight = screenSize.height;
  final screenWidth = screenSize.width;
  final imageSize = screenWidth * 0.15;

  final bool isDesktop = screenWidth >= 1024;
  final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
  final List<String> selectedAddOns = [];
  double priceWidth = screenWidth * 0.2;
  final buttonKey = GlobalKey();
  double addOnsTotal = 0.0;
  final double priceBoxHeight = isTablet ? screenHeight * 0.050 :screenHeight * 0.070; // 8% of screen height
  final double addToCartHeight =  isTablet ? screenHeight * 0.050 :screenHeight * 0.070;
  // **Return the Future from showModalBottomSheet**
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width, // Full width
      maxHeight: MediaQuery.of(context).size.height * 0.95, // Height limit
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Material(
            color: Colors.black.withOpacity(0.5), // Semi-transparent background
            child: Center(
              child: SizedBox(
                width: screenWidth,
                height: screenHeight * 0.95,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryColor,
                        AppColor.whiteColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      stops: [0.3, 0.25],
                    ),
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      Padding(
                        padding: const EdgeInsets.only(left: 22.0, top: 18),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            AppImage.backArrow,
                            height: isTablet ? 35 : 25,
                          ),
                        ),
                      ),

                      // Product image + title + price
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
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                "${ApiEndpoints.imageBaseUrl}${product.image}",
                                height: imageSize,
                                width: imageSize,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported,
                                    size: 70),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.name != null &&
                                        product.name!.isNotEmpty
                                        ? product.name![0].toUpperCase() +
                                        product.name!
                                            .substring(1)
                                            .toLowerCase()
                                        : '',
                                    style: AppTextStyles.nunitoBold(
                                        responsive.productName,
                                        color: AppColor.whiteColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "₹${(double.tryParse(product.price ?? '0') ?? 0.0).toStringAsFixed(2)}",
                                    style: AppTextStyles.nunitoBold(
                                        responsive.productName,
                                        color: AppColor.whiteColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Add-ons section
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(70),
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
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                                child: Text(
                                  "Choose Your Add-ons",
                                  style: AppTextStyles.latoBold(responsive.adOn,
                                      color: AppColor.blackColor),
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  itemCount: sampleAddOnJson.length,
                                  itemBuilder: (context, index) {
                                    final addOns = sampleAddOnJson
                                        .map(
                                            (json) => AddOnModel.fromJson(json))
                                        .toList();
                                    final addOn = addOns[index];
                                    final isSelected =
                                    selectedAddOns.contains(addOn.name);

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            selectedAddOns.remove(addOn.name);
                                            addOnsTotal -= addOn.price;
                                          } else {
                                            selectedAddOns.add(addOn.name);
                                            addOnsTotal += addOn.price;
                                          }
                                          selectedProvider
                                              .setAddOnsTotal(addOnsTotal);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 8),
                                        child: Row(
                                          children: [
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
                                                  size: 16,
                                                  color: Colors.white)
                                                  : null,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                addOn.name,
                                                style: AppTextStyles.latoMedium(
                                                    responsive.hintTextSize,
                                                    color: AppColor.blackColor),
                                              ),
                                            ),
                                            Text(
                                              "₹${addOn.price.toStringAsFixed(2)}",
                                              style: AppTextStyles.nunitoBold(
                                                  responsive.hintTextSize,
                                                  color: AppColor.blackColor),
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

                      // Footer
                      Container(

                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.0100),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.secondary,
                              AppColor.primaryColor,
                            ],
                            begin: Alignment.topCenter,
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
                              width: isTablet
                                  ? priceWidth // If device is a tablet → use calculated priceWidth
                                  : null,
                              height: priceBoxHeight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Price',
                                    style: AppStyle.textStyleReemKufi.copyWith(
                                      color: AppColor.primaryColor,
                                      fontSize: responsive.priceTitle,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Selector<CategoryProvider, double>(
                                    selector: (context, provider) {
                                      final prefHelper =
                                      getIt<SharedPreferenceHelper>();
                                      final isTakeAway = prefHelper
                                          .getBool(StorageKey.isTakeAway) ??
                                          false;

                                      // If TakeAway is true, use totalPrice else use totalPrices
                                      return isTakeAway
                                          ? provider.totalPriceWithTakeWay
                                          : provider.totalPrices;
                                    },
                                    builder: (context, finalTotal, child) {
                                      return ShaderMask(
                                        shaderCallback: (bounds) =>
                                            const LinearGradient(
                                              colors: [
                                                AppColor.primaryColor,
                                                AppColor.primaryColor
                                              ],
                                            ).createShader(Rect.fromLTWH(0, 0,
                                                bounds.width, bounds.height)),
                                        child: Text(
                                          '₹${finalTotal.toStringAsFixed(2)}',
                                          style: AppStyle.textStyleReemKufi
                                              .copyWith(
                                            color: Colors.white,
                                            fontSize: responsive.priceTotal,
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
                            Expanded(
                              key: buttonKey,
                              child: Container(
                                  height:addToCartHeight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop({
                                      'selectedAddOns': selectedAddOns,
                                      'addOnsTotal': addOnsTotal,
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColor.primaryColor,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Add Add-on',
                                    style: AppStyle.textStyleReemKufi.copyWith(
                                      fontSize: responsive.priceTotal,
                                      fontWeight: FontWeight.w600,
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
            ),
          );
        },
      );
    },
  );
}

// void showAddOnDialog(BuildContext context, Item product) {
//   final selectedProvider =
//       Provider.of<CategoryProvider>(context, listen: false);
//
//   final screenSize = MediaQuery.of(context).size;
//   final screenHeight = screenSize.height;
//   final screenWidth = screenSize.width;
//   final size = MediaQuery.of(context).size;
//   final imageSize = size.width * 0.15;
//   // Keep selectedAddOns persistent during dialog lifecycle
//   final List<String> selectedAddOns = [];
//
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//     ),
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Container(
//             height: screenHeight * 0.95,
//             decoration: const BoxDecoration(
//               //  color: AppColor.primaryColor,
//               gradient: LinearGradient(
//                 colors: [
//                   AppColor.primaryColor,
//                   AppColor.whiteColor,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: [0.3, 0.25],
//               ),
//
//               borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(left: 22.0, top: 18, bottom: 5),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: SvgPicture.asset(AppImage.backArrow, height: 25),
//                   ),
//                 ),
//                 // Replace the current image + name section with this:
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: const BoxDecoration(
//                     color: AppColor.primaryColor,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(24),
//                       topRight: Radius.circular(24),
//                     ),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Product Image
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           "${ApiEndpoints.imageBaseUrl}${product.image}",
//                           height: imageSize,
//                           width: imageSize,
//                           //   fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Icon(Icons.image_not_supported, size: 70),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//
//                       // Product Name + Price (if needed)
//                       Expanded(
//                         child: Row(
//                           //crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               (product.name != null && product.name!.isNotEmpty)
//                                   ? product.name![0].toUpperCase() +
//                                       product.name!.substring(1).toLowerCase()
//                                   : '',
//                               style: AppTextStyles.nunitoBold(20,
//                                   color: AppColor.whiteColor),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 4),
//                             // Optional: show price here
//                             Text(
//                               "₹${(double.tryParse(product.price ?? '0') ?? 0.0).toStringAsFixed(2)}",
//                               style: AppTextStyles.nunitoBold(20,
//                                   color: AppColor.whiteColor),
//                             ),
//                             // Text(
//                             //   "₹${product.discountPrice ?? '0'}",
//                             //   style: AppStyle.textStyleReemKufi.copyWith(
//                             //     fontSize: 16,
//                             //     fontWeight: FontWeight.w600,
//                             //     color: Colors.white,
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // ===== Add-ons Section =====
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(70),
//                         // topRight: Radius.circular(24),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: 20,
//                         ),
//                         // Title
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 25, vertical: 12),
//                           child: Text(
//                             "Choose Your Add-ons",
//                             style: AppTextStyles.latoBold(18,
//                                 color: AppColor.blackColor),
//                           ),
//                         ),
//                         Divider(),
//                         // Add-ons List
//                         Expanded(
//                           child: ListView.builder(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             itemCount: sampleAddOnJson
//                                 .length, // Use sample data length
//                             itemBuilder: (context, index) {
//                               // Create the AddOnModel list from sample JSON
//                               final addOns = sampleAddOnJson
//                                   .map((json) => AddOnModel.fromJson(json))
//                                   .toList();
//
//                               final addOn = addOns[
//                                   index]; // <-- Fix: reference the specific addOn
//                               final isSelected =
//                                   selectedAddOns.contains(addOn.name);
//
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     if (isSelected) {
//                                       selectedAddOns.remove(addOn.name);
//                                     } else {
//                                       selectedAddOns.add(addOn.name);
//                                     }
//                                   });
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 12, horizontal: 8),
//                                   decoration: BoxDecoration(
//                                       // border: Border(
//                                       //   bottom: BorderSide(color: Colors.grey.shade300),
//                                       // ),
//                                       ),
//                                   child: Row(
//                                     children: [
//                                       // Custom Checkbox
//                                       Container(
//                                         height: 20,
//                                         width: 20,
//                                         decoration: BoxDecoration(
//                                           color: isSelected
//                                               ? AppColor.primaryColor
//                                               : Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(4),
//                                           border: Border.all(
//                                             color: AppColor.primaryColor,
//                                             width: 1.5,
//                                           ),
//                                         ),
//                                         child: isSelected
//                                             ? const Icon(Icons.check,
//                                                 size: 16, color: Colors.white)
//                                             : null,
//                                       ),
//                                       const SizedBox(width: 12),
//
//                                       // Add-on Name
//                                       Expanded(
//                                         child: Text(
//                                           addOn.name,
//                                           style: AppTextStyles.latoMedium(15,
//                                               color: AppColor.blackColor),
//                                         ),
//                                       ),
//
//                                       // Price
//                                       Text(
//                                         "₹${addOn.price.toStringAsFixed(2)}",
//                                         style: AppTextStyles.nunitoBold(15,
//                                             color: AppColor.blackColor),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 // ===== Footer Section =====
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: screenWidth * 0.04,
//                     vertical: screenHeight * 0.015,
//                   ),
//                   decoration: const BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [
//                         AppColor.secondary, // Top color
//                         AppColor.primaryColor // Fade out below
//                       ],
//                       begin: Alignment.topCenter, // Start at the very top
//                       end: Alignment.bottomCenter, // End at the bottom
//                       stops: [0.0, 0.5], // 0.0 = start, 0.4 = 40% height
//                       tileMode: TileMode.clamp,
//                     ),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       // Price Box
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Price',
//                               style: AppStyle.textStyleReemKufi.copyWith(
//                                 color: AppColor.primaryColor,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Selector<CategoryProvider, double>(
//                               selector: (_, provider) => provider.totalPrice,
//                               builder: (context, totalPrice, child) {
//                                 return Text(
//                                   '₹${totalPrice.toStringAsFixed(2)}',
//                                   style: AppStyle.textStyleReemKufi.copyWith(
//                                     color: AppColor.primaryColor,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//
//                       // Add to Cart Button
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             final prefHelper = getIt<SharedPreferenceHelper>();
//                             final isTakeAway =
//                                 prefHelper.getBool(StorageKey.isTakeAway) ??
//                                     false;
//                             final cartProvider = Provider.of<CartProvider>(
//                                 context,
//                                 listen: false);
//                             final dynamic packingCharge = product.takeAwayPrice;
//                             final totalTime =
//                                 context.read<CategoryProvider>().totalTime;
//                             // Convert to double safely
//                             final double? packingChargeValue =
//                                 packingCharge is String
//                                     ? double.tryParse(packingCharge)
//                                     : (packingCharge is double
//                                         ? packingCharge
//                                         : null);
//
//                             final selectedChild = context
//                                 .read<CategoryProvider>()
//                                 .selectedChildCategory;
//
//                             final cartItem = CartItemModel(
//                               id: product.id,
//                               name: product.name,
//                               images: [product.image],
//                               categoryId: product.categoryId,
//                               price: isTakeAway
//                                   ? (selectedProvider.selectedPrices ?? 0.0)
//                                   : (selectedProvider.selectedPrices ?? 0.0),
//                               quantity: selectedProvider.quantity,
//                               isCombo: false,
//                               takeAwayPrice: packingChargeValue,
//                               // takeAwayPrice: selectedChild?.takeAwayPrice,
//                               subCategoryId: selectedChild?.subCategoryId ?? 0,
//                               childCategoryId: selectedChild?.id
//                                   .toString(), // 👈 pass child id if selected
//                               childCategoryName: selectedChild?.name,
//                               totalDeliveryTime: totalTime,
//                               childCategory: product.childCategory,
//                             );
//                             cartProvider.addToCart(cartItem);
//                             Navigator.of(context).pop();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: AppColor.primaryColor,
//                             elevation: 0,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: Text(
//                             'Add To Cart',
//                             style: AppStyle.textStyleReemKufi.copyWith(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }

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
        context, provider.selectedCategoryId, apiSort, null);
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
