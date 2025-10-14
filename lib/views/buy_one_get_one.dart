import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/utlis/widgets/floating_message.dart';
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
import '../utlis/widgets/listening_waves.dart';
import '../utlis/widgets/responsiveness.dart';
import '../utlis/widgets/shimmer_loading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../utlis/widgets/snack_bar.dart';

class BuyOneGetOne extends StatefulWidget {
  const BuyOneGetOne({super.key});

  @override
  State<BuyOneGetOne> createState() => _BuyOneGetOneState();
}

class _BuyOneGetOneState extends State<BuyOneGetOne> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late DashboardProvider _dashboardProvider;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  void initState() {
    super.initState();
    _speech = stt.SpeechToText();


    WidgetsBinding.instance.addPostFrameCallback((_) {

      final categoryProvider =
      Provider.of<DashboardProvider>(context, listen: false);

      categoryProvider.getBuyOneOffer(context, null,"");
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get provider once and store it
    _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchFocusNode.dispose();
    _dashboardProvider.clearComboSort(notify: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<CategoryProvider>(context);
    final responsive = Responsiveness(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final cartProvider = Provider.of<CartProvider>(context);
    double subTotal = cartProvider.subTotal;
    double horizontalPadding = screenWidth * 0.010;
    double fontSize = screenWidth * 0.018;
    double searchHeight = screenWidth * 0.05;
    double iconSize = screenWidth * 0.025;
    double filterIconSize = screenWidth * 0.025;
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
          double priceWidth = screenWidth * 0.2;
          // Dynamic sizes based on device type
          final double barHeight = isDesktop ? 110 : isTablet ? 90 : 80;
          final double paddingHorizontal = isDesktop ? 40 : isTablet ? 24 : 16;
          final double paddingVertical = isDesktop ? 16 : isTablet ? 12 : 10;
          final double titleFontSize = isDesktop ? 18 : isTablet ? 16 : 15;
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
                  width: isTablet
                      ? priceWidth        // If device is a tablet → use calculated priceWidth
                      : null,
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
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColor.primaryColor, AppColor.primaryColor],
                        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                        child: Text(
                          'Price',
                          style: AppStyle.textStyleReemKufi.copyWith(
                            color: Colors.white,
                            fontSize: responsive.priceTitle,
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
                            fontSize: responsive.priceTotal,
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
                    height:isTablet?70:60,
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
                          'View Order',
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
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 5,),
                            Icon(
                              Icons.search,
                              size: iconSize.clamp(18, 28),
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        // Hint + waves overlay
                                        if (_controller.text.isEmpty)
                                          AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 300),
                                            child: _isListening
                                                ? Row(
                                              key: const ValueKey('listening'),
                                              children: [
                                                Text(
                                                  'Listening...',
                                                  style: AppTextStyles.nunitoRegular(
                                                    responsive.hintTextSize,
                                                    color: AppColor.primaryColor,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                 ListeningWave(
                                                   color: AppColor.primaryColor,
                                                  size: 10,
                                                ),
                                              ],
                                            )
                                                : Text(
                                              'Looking for BOGO? Type here...',
                                              key: const ValueKey('default'),
                                              style: AppTextStyles.nunitoRegular(
                                                responsive.hintTextSize,
                                                color: AppColor.lightGreyColor,
                                              ),
                                            ),
                                          ),
                                        // The actual TextField
                                        TextField(
                                          controller: _controller,
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
                                            hintText: '', // handled manually by AnimatedSwitcher
                                          ),
                                          onChanged: (value) {
                                            final provider =
                                            Provider.of<DashboardProvider>(context, listen: false);
                                            provider.bugOneGetOneOfferSearch(context, _controller.text);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  IconButton(
                                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                                        color: _isListening ? AppColor.primaryColor : Colors.grey),
                                    onPressed: () {
                                      if (_isListening) {
                                        _stopListening();
                                      } else {
                                        _startListening();
                                      }
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
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
                          aspectRatio = 0.75;
                          imageHeight = 180;
                        } else if (screenWidth >= 700) {
                          crossAxisCount = 3;
                          aspectRatio = 0.75;
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
                                        GestureDetector(
                                          onTap: () {
                                            _searchFocusNode.unfocus();
                                            _controller.clear();
                                            showBurgerDialog(context, product);
                                          },
                                          child: Container(
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
                                                    aspectRatio: 1.4,
                                                    child: LayoutBuilder(
                                                      builder: (context, constraints) {
                                                        final screenWidth = MediaQuery.of(context).size.width;
                                                        final screenHeight = MediaQuery.of(context).size.height;

                                                        // Example logic: Adjust size based on screen width
                                                        double imageWidth;
                                                        double imageHeight;

                                                        if (screenWidth > 1000) {
                                                          // Large screens (like tablets or desktops)
                                                          imageWidth = screenWidth * 0.25;
                                                          imageHeight = screenHeight * 0.25;
                                                        } else if (screenWidth > 600) {
                                                          // Medium screens
                                                          imageWidth = screenWidth * 0.35;
                                                          imageHeight = screenHeight * 0.20;
                                                        } else {
                                                          // Small screens (like phones)
                                                          imageWidth = screenWidth * 0.45;
                                                          imageHeight = screenHeight * 0.18;
                                                        }

                                                        return SizedBox(
                                                          width: imageWidth,
                                                          height: imageHeight,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(12),
                                                            // child: Image.network(
                                                            //   "${ApiEndpoints.imageBaseUrl}${product.image}",
                                                            //   //fit: BoxFit.fill, // Keep image proportional
                                                            //   errorBuilder: (context, error, stackTrace) =>
                                                            //   const Icon(Icons.image_not_supported),
                                                            // ),
                                                           child: CachedNetworkImage(
                                                              imageUrl: "${ApiEndpoints.imageBaseUrl}${product.image}",
                                                             // fit: BoxFit.cover, // or BoxFit.fill / contain as you prefer
                                                              placeholder: (context, url) => const Center(
                                                                child: Icon(
                                                                  Icons.image, // You can use any food icon here
                                                                  color: Colors.grey,
                                                                  size: 40,
                                                                ),
                                                              ),
                                                              errorWidget: (context, url, error) => const Icon(
                                                                Icons.image_not_supported,
                                                                color: Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    (product.name.isNotEmpty)
                                                        ? product.name[0].toUpperCase() + product.name.substring(1).toLowerCase()
                                                        : '',
                                                    style: AppTextStyles.nunitoBold(responsive.adOn, color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    product.description.toString() ?? '',
                                                    textAlign: TextAlign.center,
                                                    style: AppTextStyles.latoRegular(responsive.des, color: Colors.black),
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
                                                        fontSize: responsive.adOn,
                                                        color: AppColor.blackColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: screenWidth >= 1024
                                              ? -15 // desktop
                                              : screenWidth >= 600
                                              ? -15 // tablet
                                              : -11, // mobile
                                          left: screenWidth >= 1024
                                              ? 12 // desktop
                                              : screenWidth >= 600
                                              ? 8 // tablet
                                              : 10, // mobile
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
                                          bottom:1,
                                          right: 1,
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

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _controller.text = val.recognizedWords;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });

          // Trigger your search function
          final provider = Provider.of<DashboardProvider>(
            context,
            listen: false,
          );
          provider.bugOneGetOneOfferSearch(context, _controller.text);
          _stopListening();
        },
      );
    }
  }
  Future<String?> showSortByDialog(BuildContext context,String currentSort) {
    String selectedOption = currentSort;
    final responsive = Responsiveness(context);
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    List<String> options = [
      'Popular',
      'Newest',
      'Price: Lowest to high',
      'Price: Highest to low',
    ];
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
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
                        padding: const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
                        child: Row(
                          children: [
                            // This ensures the "Sort By" text stays centered
                            Expanded(
                              child: Text(
                                'Sort By',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.nunitoBold(
                                  responsive.mainTitleSize,
                                  color: AppColor.whiteColor,
                                ),
// Centers text within Expanded
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
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
                          color: isSelected
                              ? Colors.white
                              : Colors.transparent,
                          child: ListTile(
                            title: Text(
                              option,
                              style: AppTextStyles.nunitoMedium( responsive.subtitleSize, color: isSelected
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
                          mainAxisAlignment: isTablet
                              ? MainAxisAlignment.spaceEvenly
                              : MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: responsive.isMobile
                                  ? MediaQuery.of(context).size.width * 0.40// wider on mobile
                                  : MediaQuery.of(context).size.width * 0.3,  // normal on tablet/desktop
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
                            SizedBox(
                              width: responsive.isMobile
                                  ? MediaQuery.of(context).size.width * 0.40// wider on mobile
                                  : MediaQuery.of(context).size.width * 0.3,  // normal on tablet/desktop
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


  /// how to clear model
  void showBurgerDialog(BuildContext context,Item product) {
    final selectedProvider =
    Provider.of<CategoryProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    double imageHeight = 120;
    double imageWidth = double.infinity;
    final screenHeight = MediaQuery.of(context).size.height;
    final double priceBoxHeight = isTablet ? screenHeight * 0.050 :screenHeight * 0.070; // 8% of screen height
    final double addToCartHeight =  isTablet ? screenHeight * 0.050 :screenHeight * 0.070;
// Adjust based on screen type
    if (screenWidth >= 1000) {
      // Desktop
      imageHeight = 220;
      imageWidth = 220;
    } else if (screenWidth >= 700) {
      // Tablet
      imageHeight = 180;
      imageWidth = 180;
    } else {
      // Mobile
      imageHeight = 120;
      imageWidth = 120;
    }
    final size = MediaQuery.of(context).size;
    final badgeSize = size.width * 0.15;
    bool isExpanded = false;
    double priceWidth = screenWidth * 0.2;
    final responsive = Responsiveness(context);
    // Set base price
    // if (product.childCategory == null || product.childCategory.isEmpty) {
    //   selectedProvider.clearSelectedChildCategory();
    // }
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
    final cartItem = cartProvider.getCartItemById(product.id,sourcePage: 'bugOne');
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
      // // Optional: restore last selected per product
      // final lastSelected =
      //     categoryProvider.getLastSelectedChildCategoryForProduct(product.id);
      // if (lastSelected != null) {
      //   categoryProvider.setSelectedChildCategorys(lastSelected,
      //       productId: product.id);
      // } else {
      // Default
      categoryProvider.setHeatLevel(0);
      categoryProvider.setSelectedChildCategorys(null, productId: product.id);
      categoryProvider.setQuantity(1);
      //}
    }
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
                              //  end: Alignment.bottomRight,
                              end: Alignment.bottomCenter,
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
                                    //     margin: const EdgeInsets.only(top:16.0),
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
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(80),
                                            ),
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                // Dynamically set image size based on container height
                                                final double imageSize = constraints.maxHeight * 0.6;

                                                return Center(
                                                  child: CachedNetworkImage(
                                                    imageUrl: "${ApiEndpoints.imageBaseUrl}${product.image}", // prepend baseUrl
                                                    height: imageSize,
                                                    width: imageSize,
                                                    fit: BoxFit.contain,
                                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) =>
                                                    const Icon(Icons.image_not_supported, size: 50),
                                                  ),
                                                );
                                              },
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
                                                              responsive.productName,
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
                                                      responsive.productName,
                                                      color: AppColor.blackColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: 4,),
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
                                                              style: AppTextStyles.latoRegular(responsive.des, color:  AppColor.lightGreyColor),
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
                                                                  style: AppTextStyles.latoRegular(responsive.hintTextSize, color:  AppColor.lightGreyColor)
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
                                                      style: AppTextStyles.latoRegular(responsive.time, color:  AppColor.darkGreyColor),
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
                                                                style: AppTextStyles.latoRegular(responsive.time, color:  AppColor.darkGreyColor),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),


                                            if (product.childCategory != null && product.childCategory.isNotEmpty) ...[
                                              SizedBox(height: screenHeight * 0.025),

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
                                                            categoryProvider.setHeatLevel(cartItem?.heatLevel ?? 0);
                                                            print("❌ Deselected child category: ${child.name}");

                                                            // Reset quantity when deselected
                                                            categoryProvider.setQuantity(cartItem?.quantity ?? 1);
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
                                              // SingleChildScrollView(
                                              //   scrollDirection: Axis.horizontal, // 👈 Enable horizontal scrolling
                                              //   child: Row(
                                              //     mainAxisAlignment: MainAxisAlignment.start,
                                              //     children: product.childCategory.map((child) {
                                              //       final provider = context.watch<CategoryProvider>();
                                              //       var selectedChild = provider.selectedChildCategory;
                                              //
                                              //       if (selectedChild == null && product.childCategory!.isNotEmpty) {
                                              //         WidgetsBinding.instance.addPostFrameCallback((_) {
                                              //           context.read<CategoryProvider>().setSelectedChildCategory(selectedChild);
                                              //         });
                                              //       }
                                              //
                                              //       return _buildOptionBox(
                                              //         _capitalizeFirstLetter(child.name),
                                              //         "₹${(child.price ?? 0).toStringAsFixed(0)}",
                                              //         isSelected: selectedChild?.id == child.id,
                                              //         onTap: () {
                                              //           context.read<CategoryProvider>().setSelectedChildCategory(child);
                                              //         },
                                              //       );
                                              //     }).toList(),
                                              //   ),
                                              // )
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
                                                              "Spicy Level",
                                                              style: AppTextStyles.nunitoMedium(responsive.subtitleSize, color:  AppColor.blackColor)
                                                          ),
                                                        ),
                                                        const SizedBox(height: 5),
                                                        HeatLevelSelector(
                                                            context),
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
                                                                  fontSize: responsive.hintTextSize,
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
                                                                  fontSize: responsive.hintTextSize,
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
                                                                  fontSize: responsive.hintTextSize,
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
                                                            style: AppTextStyles.nunitoMedium(responsive.subtitleSize, color:  AppColor.blackColor),
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
                                                height: isTablet ? 35 :20
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children:  [
                                                Text(
                                                    "Add Add-Ons",
                                                    style: AppTextStyles.latoBold(responsive.hintTextSize,
                                                        color:  AppColor.blackColor)
                                                ),
                                                Text(
                                                    "Make It Special — Choose Your Add-Ons Now!",
                                                    style: AppTextStyles.latoMedium(responsive.time, color:  AppColor.lightGreyColor)
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
                                      vertical: screenHeight * 0.0100,
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
                                          width: isTablet
                                              ? priceWidth        // If device is a tablet → use calculated priceWidth
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
                                                      fontSize:  responsive.priceTitle,
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
                                            key:buttonKey,
                                            height: addToCartHeight,
                                            ///  height:isTablet?65:60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                final snackBar = ShowSnackBar();
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
                                                      ? (selectedProvider.selectedPrice ?? 0.0)
                                                      : (selectedProvider.selectedPrices ?? 0.0),
                                                  quantity: selectedProvider.quantity,
                                                  isCombo: false,
                                                  takeAwayPrice: isTakeAway
                                                      ? packingChargeValue
                                                      : null,
                                                  // takeAwayPrice: selectedChild?.takeAwayPrice,
                                                  subCategoryId: selectedChild?.subCategoryId ?? 0,
                                                  childCategoryId: selectedChild?.id.toString(),      // 👈 pass child id if selected
                                                  childCategoryName: selectedChild?.name,
                                                  totalDeliveryTime:totalTime,
                                                  childCategory: product.childCategory,
                                                  description: product.description,
                                                  spicy: product.spicy,
                                                  prepareTime: product.time,
                                                  heatLevel: selectedProvider.selectedHeatLevel,

                                                );
                                                final wasAdded = cartProvider.isDuplicate(cartItem,sourcePage: "bugOne");

                                                if (!wasAdded) {
                                                  cartProvider.addToCart(context, cartItem,sourcePage: "bugOne"); // Add only if not duplicate
                                                  Navigator.of(context).pop();
                                                  snackBar.customSnackBar(
                                                    context: context,
                                                    type: "1",
                                                    strMessage: 'Item(s) Added',
                                                  );
                                                } else {
                                                  FloatingMessage.show(
                                                    context: context,
                                                    key: buttonKey,
                                                    message: 'Product already added with same quantity!',
                                                  );
                                                  // Optional: showAboveButton(context, buttonKey, 'Product already added with same quantity!');
                                                }

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
                                                  'Add To Order',
                                                  style: AppStyle.textStyleReemKufi
                                                      .copyWith(
                                                    color: Colors.white,
                                                    fontSize:   responsive.priceTotal,
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
                                  width:isTablet ?100 :50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2.5),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: isTablet ?-16:-15,
                                left: 10,
                                child: Image.asset(
                                  AppImage.badge,
                                  height:isTablet ?100 :70,

                                  width: badgeSize,
                                  // width: badgeSize,
                                ),
                              ),
                              Positioned(
                                right: 16,
                                top: 16,
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: SvgPicture.asset(AppImage.cross,height:isTablet ? 30 :20),
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
  void showAboveButton(BuildContext context, GlobalKey key, String message) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final overlay = Overlay.of(context);
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final screenWidth = MediaQuery.of(context).size.width;

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy - 50, // above the button
        left: (screenWidth - size.width) / 2, // center horizontally
        width: size.width, // match button width
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }



  void showAddOnDialog(BuildContext context, Item product) {
    final selectedProvider = Provider.of<CategoryProvider>(context, listen: false);
    final responsive = Responsiveness(context);
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final imageSize = screenWidth * 0.15;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double priceBoxHeight = isTablet ? screenHeight * 0.050 :screenHeight * 0.070; // 8% of screen height
    final double addToCartHeight =  isTablet ? screenHeight * 0.050 :screenHeight * 0.070;

    final List<String> selectedAddOns = [];
    double priceWidth = screenWidth * 0.2;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierLabel: 'Add-ons',
      isDismissible: false,
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
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                              height:isTablet ? 35 :25,

                            ),
                          ),
                        ),

                        // Product image + title + price
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
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  "${ApiEndpoints.imageBaseUrl}${product.image}",
                                  height: imageSize,
                                  width: imageSize,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported, size: 70),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product.name != null && product.name!.isNotEmpty
                                          ? product.name![0].toUpperCase() +
                                          product.name!.substring(1).toLowerCase()
                                          : '',
                                      style: AppTextStyles.nunitoBold(responsive.productName, color: AppColor.whiteColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "₹${(double.tryParse(product.price ?? '0') ?? 0.0).toStringAsFixed(2)}",
                                      style: AppTextStyles.nunitoBold(responsive.productName, color: AppColor.whiteColor),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                                  child: Text(
                                    "Choose Your Add-ons",
                                    style: AppTextStyles.latoBold(responsive.adOn, color: AppColor.blackColor),
                                  ),
                                ),
                                const Divider(),
                                Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    itemCount: sampleAddOnJson.length,
                                    itemBuilder: (context, index) {
                                      final addOns = sampleAddOnJson
                                          .map((json) => AddOnModel.fromJson(json))
                                          .toList();
                                      final addOn = addOns[index];
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
                                          child: Row(
                                            children: [
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
                                              Expanded(
                                                child: Text(
                                                  addOn.name,
                                                  style: AppTextStyles.latoMedium(responsive.hintTextSize, color: AppColor.blackColor),
                                                ),
                                              ),
                                              Text(
                                                "₹${addOn.price.toStringAsFixed(2)}",
                                                style: AppTextStyles.nunitoBold(responsive.hintTextSize, color: AppColor.blackColor),
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
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.0100),
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
                                    ? priceWidth        // If device is a tablet → use calculated priceWidth
                                    : null,
                                height: priceBoxHeight,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                        fontSize:   responsive.priceTitle,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Selector<CategoryProvider, double>(
                                      selector: (_, provider) => provider.totalPriceWithTakeWay,
                                      builder: (context, totalPrice, child) {
                                        return Text(
                                          '₹${totalPrice.toStringAsFixed(2)}',
                                          style: AppStyle.textStyleReemKufi.copyWith(
                                            color: AppColor.primaryColor,
                                            fontSize:responsive.priceTotal,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Container(
                                height: addToCartHeight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final prefHelper = getIt<SharedPreferenceHelper>();
                                      final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
                                      final cartProvider =
                                      Provider.of<CartProvider>(context, listen: false);
                                      final dynamic packingCharge = product.takeAwayPrice;
                                      final totalTime = context.read<CategoryProvider>().totalTime;
                                      final double? packingChargeValue = packingCharge is String
                                          ? double.tryParse(packingCharge)
                                          : (packingCharge is double ? packingCharge : null);

                                      final selectedChild = context.read<CategoryProvider>().selectedChildCategory;

                                      // final cartItem = CartItemModel(
                                      //   id: product.id,
                                      //   name: product.name,
                                      //   images: [product.image],
                                      //   categoryId: product.categoryId,
                                      //   price: isTakeAway
                                      //       ? (selectedProvider.selectedPrice ?? 0.0)
                                      //       : (selectedProvider.selectedPrices ?? 0.0),
                                      //   quantity: selectedProvider.quantity,
                                      //   isCombo: false,
                                      //   takeAwayPrice: packingChargeValue,
                                      //   subCategoryId: selectedChild?.subCategoryId ?? 0,
                                      //   childCategoryId: selectedChild?.id.toString(),
                                      //   childCategoryName: selectedChild?.name,
                                      //   totalDeliveryTime: totalTime,
                                      // );

                                      //cartProvider.addToCart(context,cartItem);
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
                                      'Add Add-on',
                                      style: AppStyle.textStyleReemKufi.copyWith(
                                        fontSize:responsive.priceTotal,
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
}



