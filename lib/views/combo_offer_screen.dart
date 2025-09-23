import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ravathi_store/providers/dashboard_provider.dart';
import 'package:ravathi_store/urls/api_endpoints.dart';
import 'package:ravathi_store/views/home_screen.dart';
import 'package:ravathi_store/views/view_order_screen.dart';
import '../models/add_on.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/category_provider.dart';
import '../utlis/App_color.dart';
import '../utlis/App_image.dart';
import '../utlis/App_style.dart';
import '../utlis/share_preference_helper/sharereference_helper.dart';
import '../utlis/widgets/app_text_style.dart';
import '../utlis/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utlis/widgets/shimmer_loading.dart';
import 'package:lottie/lottie.dart';

class ComboOfferScreen extends StatefulWidget {
  const ComboOfferScreen({super.key});

  @override
  State<ComboOfferScreen> createState() => _ComboOfferScreenState();
}

class _ComboOfferScreenState extends State<ComboOfferScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DashboardProvider>(context, listen: false)
          .getComboProduct(context, null, "");
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
        title: 'Combo Offers',
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
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
              : 18;
          final double buttonFont = isDesktop
              ? 18
              : isTablet
              ? 17
              : 17;
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
            child: Consumer<DashboardProvider>(
              builder: (context, provider, child) {
                final products = provider.comboProduct;
                final size = MediaQuery.of(context).size;
                final imageSize = size.width * 0.15;
                final badgeSize = size.width * 0.15;
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
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                        child: Text(
                          "No products found",
                          style: AppStyle.textStyleReemKufi.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.greyColor,
                            fontSize: 15,
                            height: 1.0, // remove extra line height
                          ),
                        )),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  key: ValueKey(provider.selectedCategoryId),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

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
                                  color: Colors.grey.shade200,
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
                                          // Text(
                                          //   "Combo offers",
                                          //   style: AppStyle.textStyleLobster
                                          //       .copyWith(
                                          //     fontWeight: FontWeight.bold,
                                          //     fontSize: 18,
                                          //     color: Colors.black,
                                          //   ),
                                          // ),
                                          Text(
                                            (product.name != null &&
                                                product.name!
                                                    .isNotEmpty)
                                                ? product.name![0]
                                                .toUpperCase() +
                                                product.name!
                                                    .substring(1)
                                                    .toLowerCase()
                                                : '',
                                            style: AppTextStyles.nunitoBold(18, color:  AppColor.blackColor),

                                          ),
                                          if (product.disountPercent != null &&
                                              product.disountPercent
                                                  .toString()
                                                  .isNotEmpty)
                                            Text(
                                              "SAVE ${product.disountPercent}%",
                                              style: AppStyle.textStyleLobster
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                foreground: Paint()
                                                  ..shader =
                                                  const LinearGradient(
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
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: List.generate(
                                        product.images.length * 2 - 1,
                                            (i) {
                                          if (i.isEven) {
                                            final img = product.images[i ~/ 2];
                                            return Container(
                                              height: imageSize,
                                              width:
                                              imageSize, // inner padding inside the container
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .shade50, // background color around image
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                  width: 1.5,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(
                                                        0.15), // Shadow color
                                                    blurRadius: 6, // Softness
                                                    spreadRadius: 2, // Spread
                                                    offset: const Offset(
                                                        0, 3), // Position
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(16),
                                                child: Image.network(
                                                  '${ApiEndpoints.imageBaseUrl}$img',
                                                  height: imageSize,
                                                  width: imageSize,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            );
                                          } else {
                                            // The "+" icon between images
                                            return Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 6.0),
                                              child: ShaderMask(
                                                shaderCallback: (bounds) =>
                                                    const LinearGradient(
                                                      colors: [
                                                        AppColor.secondary,
                                                        AppColor.primaryColor,
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ).createShader(
                                                      Rect.fromLTWH(
                                                          0,
                                                          0,
                                                          bounds.width,
                                                          bounds.height),
                                                    ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 35,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    // Row(
                                    //   children: [
                                    //     // Text(
                                    //     //   (product.name.isNotEmpty)
                                    //     //       ? product.name[0].toUpperCase() +
                                    //     //           product.name
                                    //     //               .substring(1)
                                    //     //               .toLowerCase()
                                    //     //       : '',
                                    //     //   overflow: TextOverflow.ellipsis,
                                    //     //   style: AppStyle.textStyleReemKufi
                                    //     //       .copyWith(
                                    //     //     color: AppColor.blackColor,
                                    //     //     fontSize: 17,
                                    //     //     fontWeight: FontWeight.bold,
                                    //     //   ),
                                    //     // ),
                                    //   ],
                                    // ),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 4, // space between items horizontally
                                      runSpacing: 4, // space between rows
                                      children: [
                                        for (int i = 0; i < (product.categoryName?.length ?? 0); i++) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(left:12.0),
                                            child: Text(
                                              product.categoryName![i],
                                              style: AppTextStyles.latoMedium(14, color:  AppColor.blackColor),


                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          // Add "+" icon between items, but not after the last one
                                          if (i < product.categoryName!.length - 1)
                                            const Icon(
                                              Icons.add,
                                              size: 18,
                                              color: AppColor.blackColor,
                                            ),
                                        ]
                                      ],
                                    ),
                                    SizedBox(height:5),
                                    Padding(
                                      padding: const EdgeInsets.only(left:12.0),
                                      child: Row(
                                        children: [
                                          if (product.discountPrice != null &&
                                              product.discountPrice!.isNotEmpty &&
                                              double.tryParse(
                                                  product.discountPrice!) !=
                                                  null &&
                                              double.parse(
                                                  product.discountPrice!) >
                                                  0) ...[
                                            // Discounted Price
                                            Text(
                                              '₹${(double.tryParse(product.discountPrice ?? '0')?.toStringAsFixed(2) ?? '0.00')}',
                                              style: AppTextStyles.nunitoBold(18, color:  AppColor.blackColor),

                                            ),
                                            const SizedBox(
                                                width: 8), // space between prices

                                            // Original Price with Strikethrough
                                            Text(
                                              '₹${product.price.toStringAsFixed(2)}',
                                              style: AppStyle.textStyleReemKufi
                                                  .copyWith(
                                                fontSize: 15,
                                                color: AppColor.greyColor,
                                                decoration:
                                                TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ] else ...[
                                            Text(
                                              '₹${product.price.toStringAsFixed(2)}',
                                              style: AppStyle.textStyleReemKufi
                                                  .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: AppColor.blackColor,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -20,
                                left: 10,
                                child: Image.asset(
                                  AppImage.badge1,
                                  height: 90,
                                  width: badgeSize,
                                  // width: badgeSize,
                                ),
                              ),
                              // Positioned Add Button
                              Positioned(
                                bottom: 18,
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
    final prefHelper = getIt<SharedPreferenceHelper>();
    final isTakeAway = prefHelper.getBool(StorageKey.isTakeAway) ?? false;
    //selectedProvider.setBasePrice(product.price.toDouble());
// Safely set base price
//     selectedProvider.setBasePrice(
//       product.discountPrice != null && product.discountPrice!.isNotEmpty
//           ? double.tryParse(product.discountPrice!) ?? product.price.toDouble()
//           : product.price.toDouble(),
//     );
    if (isTakeAway) {
      selectedProvider.setBasePriceWithTakeAwayCombo(product);
    } else {
      selectedProvider.setBasePrice(
        product.discountPrice != null && product.discountPrice!.isNotEmpty
            ? double.tryParse(product.discountPrice!) ??
            product.price.toDouble()
            : product.price.toDouble(),
      );
    }
    // selectedProvider.setBasePriceWithTakeAwayCombo(product);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
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
        ? 20
        : 20;
    final double description = isDesktop
        ? 20
        : isTablet
        ? 15
        : 15;
    final size = MediaQuery.of(context).size;
    final badgeSize = size.width * 0.15;

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
                          height: screenHeight * 0.95,
                          // constraints: BoxConstraints(
                          //   maxHeight: screenHeight * 0.95,
                          // ),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.primaryColor,
                                AppColor.whiteColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.3, 0.25],
                            ),
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [

                                    Container(
                                      height: screenHeight * 0.16,
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

                                          final totalItems =
                                              product.images.length * 2 - 1;
                                          final spacing = 8.0;

                                          final imageSize = (screenWidth -
                                              (spacing * (totalItems - 1))) /
                                              totalItems;

                                          return Container(
                                            height: imageSize +
                                                70, // Increased height to fit price
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(AppImage.bgImg),
                                                fit: BoxFit.cover, // Cover the entire container

                                              ),
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColor.primaryColor,
                                                  AppColor.primaryColor,
                                                ],
                                                end: Alignment.bottomRight,
                                                begin: Alignment.topCenter,
                                                stops: [0.3, 0.9],
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                /// Product Name and Price
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 15.0,top: 25),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [

                                                        /// Product Name
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              (product.name != null &&
                                                                  product.name!
                                                                      .isNotEmpty)
                                                                  ? product.name![0]
                                                                  .toUpperCase() +
                                                                  product.name!
                                                                      .substring(1)
                                                                      .toLowerCase()
                                                                  : '',
                                                              style: AppTextStyles.nunitoBold(priceSize, color:  AppColor.whiteColor),
                                                            ),
                                                            Text(
                                                              "₹${(product.discountPrice != null && product.discountPrice!.isNotEmpty ? num.tryParse(product.discountPrice!) : product.price.toDouble())?.toStringAsFixed(2) ?? '0.00'}",
                                                              style: AppTextStyles.nunitoBold(priceSize, color:  AppColor.whiteColor),
                                                            ),
                                                          ],
                                                        ),

                                                        const SizedBox(height: 5),

                                                        /// Product Price
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            // Left Side: Prep Time (Shown only if available)
                                                            if (product.time !=
                                                                null &&
                                                                product.time!
                                                                    .trim()
                                                                    .isNotEmpty)
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .access_time_outlined,
                                                                    color: Colors
                                                                        .white70,
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
                                                                    style: AppStyle
                                                                        .textStyleReemKufi
                                                                        .copyWith(
                                                                      color: Colors
                                                                          .white70,
                                                                      fontSize: 15,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                            // Right Side: Price
                                                            if (product.takeAwayPrice != null && isTakeAway)
                                                              Row(
                                                                children: [
                                                                  SvgPicture.asset(
                                                                    AppImage.take,
                                                                    height: 20,
                                                                    color: AppColor.whiteColor,

                                                                  ),
                                                                  const SizedBox(width: 4),
                                                                  Builder(
                                                                    builder: (context) {
                                                                      final dynamic packingCharge = product.takeAwayPrice;
                                                                      final double? chargeValue = packingCharge is String
                                                                          ? double.tryParse(packingCharge)
                                                                          : (packingCharge is double ? packingCharge : null);

                                                                      return Text(
                                                                        chargeValue != null
                                                                            ? "Wrap & Pack Fee Rs  ${chargeValue.toStringAsFixed(2)}"
                                                                            : "Rs 0.00", style: AppStyle.textStyleReemKufi.copyWith(
                                                                        color: AppColor.whiteColor,
                                                                        fontSize: 12,
                                                                      ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                /// Badge

                                              ],
                                            ),
                                          );
                                        },
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
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Quantity",
                                                    style: AppTextStyles.nunitoMedium(buttonFontSize, color:  AppColor.blackColor),

                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      _buildIconButton(Icons.remove,
                                                              () {
                                                            selectedProvider
                                                                .decreaseQuantity();
                                                          }),
                                                      const SizedBox(width: 12),
                                                      Consumer<CategoryProvider>(
                                                        builder: (context, provider,
                                                            child) {
                                                          return Text(
                                                            "${provider.quantity}",
                                                            style: AppStyle
                                                                .textStyleReemKufi
                                                                .copyWith(
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 20,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(width: 12),
                                                      _buildIconButton(Icons.add, () {
                                                        selectedProvider
                                                            .increaseQuantity();
                                                      }),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 25,
                                              ),
                                              Column(
                                                children: List.generate(
                                                    product.images.length, (index) {
                                                  final imageUrl =
                                                      '${ApiEndpoints.imageBaseUrl}${product.images[index]}';

                                                  return Padding(
                                                    padding: const EdgeInsets.only(
                                                        bottom: 12.0),
                                                    child: IntrinsicHeight(
                                                      // 👈 ensures Row takes full height of card
                                                      child: Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          /// Circle + Line
                                                          Column(
                                                            children: [
                                                              // Circle
                                                              CircleAvatar(
                                                                radius: 12,
                                                                backgroundColor:
                                                                AppColor.primaryColor,
                                                                child: Text(
                                                                  '${index + 1}',
                                                                  style:
                                                                  const TextStyle(
                                                                      color:
                                                                      Colors.white,
                                                                      fontSize: 10
                                                                  ),
                                                                ),
                                                              ),

                                                              // Vertical Line (only if not last item)
                                                              if (index <
                                                                  product.images
                                                                      .length -
                                                                      1)
                                                                Expanded(
                                                                  // 👈 this makes line auto-match card height
                                                                  child: Container(
                                                                    width: 2,
                                                                    color: Colors.grey
                                                                        .shade200,
                                                                  ),
                                                                ),
                                                            ],
                                                          ),

                                                          const SizedBox(width: 5),

                                                          /// Card
                                                          Expanded(
                                                            child: Container(
                                                              padding: const EdgeInsets.all(12),
                                                              decoration: BoxDecoration(
                                                                color: Colors.orange.shade50,
                                                                borderRadius: BorderRadius.circular(12),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.black.withOpacity(0.1),
                                                                    blurRadius: 6,
                                                                    offset: const Offset(0, 3),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  /// Product Image
                                                                  ClipRRect(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    child: Image.network(
                                                                      imageUrl,
                                                                      height: 80,
                                                                      width: 80,
                                                                      //fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                  /// Details Section
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        /// Product Name
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 13.0),
                                                                          child: Text(
                                                                            product.categoryName[index],
                                                                            style: AppTextStyles.nunitoMedium(
                                                                              18,
                                                                              color: AppColor.blackColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 4),

                                                                        /// Description with See More
                                                                        if (product.description.isNotEmpty)
                                                                          Builder(
                                                                            builder: (context) {
                                                                              bool isExpanded = false;
                                                                              return StatefulBuilder(
                                                                                builder: (context, setState) {
                                                                                  final String descriptionText =
                                                                                  product.description.join(' ');

                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.only(left: 13.0),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          isExpanded || descriptionText.length <= 80
                                                                                              ? descriptionText
                                                                                              : '${descriptionText.substring(0, 80)}...',
                                                                                          textAlign: TextAlign
                                                                                              .justify,
                                                                                          style: AppTextStyles.latoRegular(
                                                                                            14,
                                                                                            color: AppColor.lightGreyColor,
                                                                                          ),
                                                                                        ),
                                                                                        if (descriptionText.length > 80)
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              setState(() {
                                                                                                isExpanded = !isExpanded;
                                                                                              });
                                                                                            },
                                                                                            child: Text(
                                                                                              isExpanded ? 'See Less' : 'See More',
                                                                                              style: const TextStyle(
                                                                                                color: AppColor.primaryColor,
                                                                                                fontSize: 13,
                                                                                                fontWeight: FontWeight.bold,
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

                                                                        const SizedBox(height: 10),

                                                                        /// Spicy Label
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 17.0),
                                                                          child: Text(
                                                                            "Spicy",
                                                                            style: AppTextStyles.nunitoMedium(
                                                                              buttonFontSize,
                                                                              color: AppColor.blackColor,
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        /// Heat Level Selector
                                                                        HeatLevelSelector(),

                                                                        /// Mild, Medium, Hot Labels
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 15.0,right:10),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              _buildSpicyLabel("Mild"),
                                                                              _buildSpicyLabel("Medium"),
                                                                              _buildSpicyLabel("Hot"),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                              SizedBox(height: screenHeight * 0.02),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Spacer(),
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
                                                        fontSize: 16,
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
                                                        ? provider.totalPriceWithTakeWay
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
                                                          isDesktop ? 20 : 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                // Selector<CategoryProvider, double>(
                                                //   selector: (_, provider) =>
                                                //       provider.totalPrice,
                                                //   builder:
                                                //       (context, totalPrice, child) {
                                                //     return ShaderMask(
                                                //       shaderCallback: (bounds) =>
                                                //           const LinearGradient(
                                                //               colors: [
                                                //             AppColor.primaryColor,
                                                //             AppColor.primaryColor
                                                //           ]).createShader(
                                                //               Rect.fromLTWH(
                                                //                   0,
                                                //                   0,
                                                //                   bounds.width,
                                                //                   bounds.height)),
                                                //       child: Text(
                                                //         '₹${totalPrice.toStringAsFixed(2)}',
                                                //         style: AppStyle
                                                //             .textStyleReemKufi
                                                //             .copyWith(
                                                //           color: Colors.white,
                                                //           fontSize:
                                                //               isDesktop ? 18 : 18,
                                                //           fontWeight: FontWeight.bold,
                                                //         ),
                                                //       ),
                                                //     );
                                                //   },
                                                // ),
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
                                                  print(product.price);
                                                  final dynamic packingCharge = product.takeAwayPrice;

                                                  // Convert to double safely
                                                  final double? packingChargeValue = packingCharge is String
                                                      ? double.tryParse(packingCharge)
                                                      : (packingCharge is double ? packingCharge : null);

                                                  final selectedChild = context.read<CategoryProvider>().selectedChildCategory;
                                                  print(
                                                      "Images in product: ${product.images}");
                                                  final totalTime = context
                                                      .read<CategoryProvider>()
                                                      .totalTime;
                                                  final cartProvider =
                                                  Provider.of<CartProvider>(
                                                      context,
                                                      listen: false);
                                                  final cartItem = CartItemModel(
                                                      id: product.id,
                                                      name: product.name,
                                                      categoryName:
                                                      product.categoryName,
                                                      discountPrice: product.discountPrice,
                                                      // name: product.name,
                                                      images: product.images,
                                                      descriptions: product.description,
                                                      categoryId: product.categoryId,
                                                      price: isTakeAway
                                                          ? (selectedProvider.selectedPrices ?? 0.0)
                                                          : (selectedProvider.selectedPrices ?? 0.0),

                                                      quantity:
                                                      selectedProvider.quantity,
                                                      isCombo: true,
                                                      type: "combo",
                                                      comboId: product.id,
                                                      childCategory: product.childCategory,
                                                      disountPercent: product.disountPercent,
                                                      takeAwayPrice: packingChargeValue,
                                                      totalDeliveryTime: totalTime);
                                                  cartProvider.addToCart(cartItem);
                                                  Navigator.of(context).pop();
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((_) {
                                                    if (context.mounted) {
                                                      PopupDialog.show(context,
                                                          product.disountPercent);
                                                    }
                                                  });
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
                                                      fontSize: 17,
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
                                  top: -13,
                                  left: 10,
                                  child: Image.asset(
                                    AppImage.badge1,
                                    height: 70,
                                    width: badgeSize,
                                  ),
                                ),
                                /// Close Icon
                                Positioned(
                                  right: 16,
                                  top: 16,
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.of(context).pop(),
                                    child: SvgPicture.asset(
                                        AppImage.cross),
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
  Widget _buildSpicyLabel(String text) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double description = isDesktop
        ? 20
        : isTablet
        ? 15
        : 15;
    return Text(
      text,
      style: AppStyle.textStyleReemKufi.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: description,
        color: AppColor.primaryColor,
      ),
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
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
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
                            Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
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
                          color: isSelected
                              ? Colors.white
                              : Colors.transparent, // selected background
                          child: ListTile(
                            title: Text(
                              option,
                              style: AppStyle.textStyleReemKufi.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? AppColor.primaryColor
                                    : AppColor.whiteColor, // text color
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
                              width: MediaQuery.of(context).size.width *
                                  0.4, // 40% of screen width
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedOption = '';
                                  });
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
                              width: MediaQuery.of(context).size.width *
                                  0.4, // 40% of screen width
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, selectedOption);
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

                                    /// when open showburgerdiaog i wan to add add to feature set the end of the diaog bxox when cikc on it oen the chose add on diaog box same ike ui
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

  void showAddOnDialog(BuildContext context, ComboProductModel product) {
    final selectedProvider = Provider.of<CategoryProvider>(context, listen: false);

    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

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
                  stops: [0.6, 0.25],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// in flutter app my printing things that app connecct in another device this code is no in that device and when user open the app open that app printed text all arw display in another device console why?how to solve it
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
                  // ===== Product Header =====
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColor.primaryColor,

                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24), // Only top-left corner rounded
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 90,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: product.images.length * 2 - 1, // Include slots for plus icons
                              itemBuilder: (context, index) {
                                final screenWidth = MediaQuery.of(context).size.width;
                                final size = MediaQuery.of(context).size;
                                final imageSize = size.width * 0.20;
                                // Set image size based on screen width
                                // double imageSize;
                                // if (screenWidth >= 1024) {
                                //   // Desktop
                                //   imageSize = 100;
                                // } else if (screenWidth >= 600) {
                                //   // Tablet
                                //   imageSize = 70;
                                // } else {
                                //   // Mobile
                                //   imageSize = 50;
                                // }
                                if (index.isOdd) {
                                  // Add plus icon between images
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Icon(Icons.add, size: 24, color: Colors.white),
                                  );
                                }

                                final imageIndex = index ~/ 2;
                                final imageUrl = '${ApiEndpoints.imageBaseUrl}${product.images[imageIndex]}';
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: imageSize,
                                      height: imageSize,
                                      //  fit: BoxFit.fill,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.broken_image, size: 60, color: Colors.grey);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),



                        //const SizedBox(height: 12),

                        // Product name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Product Name
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  (product.name != null && product.name!.isNotEmpty)
                                      ? product.name![0].toUpperCase() +
                                      product.name!.substring(1).toLowerCase()
                                      : '',
                                  style: AppTextStyles.nunitoBold(20, color:  AppColor.whiteColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Price
                            Text(
                              '₹${(double.tryParse(product.discountPrice ?? '0')?.toStringAsFixed(2) ?? '0.00')}',
                              style: AppTextStyles.nunitoBold(20, color:  AppColor.whiteColor),
                            ),
                          ],
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
                                          "₹${addOn.price.toStringAsFixed(0)}",
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
                                selector: (_, provider) => provider.totalPriceWithTakeWay,
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
                              final cartProvider =
                              Provider.of<CartProvider>(context, listen: false);

                              final cartItem = CartItemModel(
                                  id: product.id,
                                  name: product.name,
                                  categoryName: product.categoryName,
                                  images: product.images,
                                  categoryId: product.categoryId,
                                  price: double.tryParse(product.discountPrice ?? '0') ?? 0.0,
                                  quantity: selectedProvider.quantity,
                                  isCombo: true,
                                  type: "combo",
                                  comboId: product.id,
                                  totalDeliveryTime:
                                  context.read<CategoryProvider>().totalTime, descriptions: product.description
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
              Colors.white, // Hide default inactive track color
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



class SearchCartRow extends StatelessWidget {
  final int cartItemCount;

  SearchCartRow({super.key, this.cartItemCount = 4});
  final TextEditingController _controller = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

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
            child: TextField(
              controller: _controller,
              focusNode: _searchFocusNode,
              decoration: const InputDecoration(
                hintText: 'Looking for a combo? Type here...',
                hintStyle: TextStyle(
                  fontFamily: 'Reem Kufi',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(Icons.search, color: AppColor.lightGreyColor),
                contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                Provider.of<DashboardProvider>(context, listen: false)
                    .getComboProduct(context, _controller.text, "");
              },
            ),
          ),
        ),

        const SizedBox(width: 8),

        Container(
          height: 55,
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
            onPressed: () {
              _searchFocusNode.unfocus();
              _openSortDialog(context);
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
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
                        padding: const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
                        child: Row(
                          children: [
                            // This ensures the "Sort By" text stays centered
                            Expanded(
                              child: Text(
                                'Sort By',
                                textAlign: TextAlign.center, // Centers text within Expanded
                                style: AppTextStyles.nunitoBold(20, color:  AppColor.whiteColor,),
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
                          color: isSelected ? Colors.white : Colors.transparent,
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
                                  provider.clearComboSort();
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
    await showSortByDialog(context, provider.comboSelectedSortLabel);

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
      provider.setComboSortOption(apiSort, selectedOption);

      // Call API with API-friendly value
      provider.getComboProduct(
        context,
        "",
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
//         provider.getComboProduct(context,"" ,'popular');
//         break;
//       case 'Newest':
//         provider.getComboProduct(context, "",'newest');
//         break;
//       case 'Price: Lowest to high':
//         provider.getComboProduct(context, "", 'price_asc');
//         break;
//       case 'Price: Highest to low':
//         provider.getComboProduct(context, "", 'pce_desc');
//         break;
//     }
//   }
// }
}



// class PopupDialog {
//   static Future<void> show(BuildContext context, String? discount,
//       {Duration duration = const Duration(seconds: 5)}) async {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         final screenSize = MediaQuery.of(context).size;
//
//         // Dialog dimensions
//         final dialogWidth = screenSize.width * 0.8; // 80% of screen width
//         final dialogHeight = screenSize.height * 0.45; // 45% of screen height
//
//         // Auto dismiss after duration
//         Future.delayed(duration, () {
//           if (Navigator.canPop(context)) {
//             Navigator.of(context).pop();
//           }
//         });
//
//         return Center(
//           child: Material(
//             color: Colors.transparent,
//             child: Stack(
//               alignment: Alignment.center,
//               clipBehavior: Clip.none, // Allows overflow outside Stack
//               children: [
//                 /// 🌟 **Top Floating Lottie Animation**
//                 Positioned(
//                   top: -dialogHeight * 0.30, // Float above dialog
//                   child: Lottie.asset(
//                     'assets/icons/lottie1.json',
//                     height: dialogHeight * 0.35,
//                     repeat: true,
//                   ),
//                 ),
//
//                 /// 🌟 **Bottom Floating Lottie Animation**
//                 Positioned(
//                   bottom: -dialogHeight * 0.25, // Float below dialog
//                   child: Lottie.asset(
//                     'assets/icons/lottie1.json',
//                     height: dialogHeight * 0.35,
//                     repeat: true,
//                   ),
//                 ),
//
//                 /// 🌟 **Left Floating Lottie Animation**
//                 Positioned(
//                   left: -dialogWidth * 0.25, // ✅ Move outside dialog for visibility
//                   top: dialogHeight * 0.15,
//                   child: Lottie.asset(
//                     'assets/icons/lottie1.json',
//                     height: dialogHeight * 0.6,
//                     repeat: true,
//                   ),
//                 ),
//                 Positioned(
//                   right: -dialogWidth * 0.25, // Push slightly outside dialog
//                   top: dialogHeight * 0.15,
//                   child: Lottie.asset(
//                     'assets/icons/lottie1.json',
//                     height: dialogHeight * 0.6,
//                     repeat: true,
//                   ),
//                 ),
//                 /// 🌟 **Main Dialog Container**
//                 Container(
//                   width: dialogWidth,
//                   height: dialogHeight,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const SizedBox(height: 10),
//
//                       /// 🏆 Center Animated Discount Icon
//                       Lottie.asset(
//                         'assets/icons/lottie2.json',
//                         height: dialogHeight * 0.35,
//                         repeat: false,
//                       ),
//
//                       const SizedBox(height: 20),
//
//                      Text(
//                         "Woo hoo!!",
//                         style: AppTextStyles.nunitoBold(30, color:  AppColor.blackColor),
//
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       /// Discount Text
//                       Expanded(
//                         child: Center(
//                           child: RichText(
//                             textAlign: TextAlign.center,
//                             text: TextSpan(
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                               ),
//                               children: [
//                                 TextSpan(
//                                   text: "Smart choice! ",
//                                   style: AppStyle.textStyleReemKufi.copyWith(
//                                     color: AppColor.greyColor,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: " ${discount}% off applied\n",
//                                   style: AppStyle.textStyleReemKufi.copyWith(
//                                     color: AppColor.primaryColor,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: "successfully!",
//                                   style: AppStyle.textStyleReemKufi.copyWith(
//                                     color: AppColor.greyColor,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       /// ✅ Success Check Animation
//                       Lottie.asset(
//                         'assets/icons/lottie3.json',
//                         height: dialogHeight * 0.2,
//                         repeat: false,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class PopupDialog {
  static Future<void> show(
      BuildContext context,
      String? discount, {
        Duration duration = const Duration(seconds: 2),
      }) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Popup",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return _PopupDialogContent(
          discount: discount,
          autoCloseDuration: duration,
        );
      },
    );
  }
}

class _PopupDialogContent extends StatefulWidget {
  final String? discount;
  final Duration autoCloseDuration;

  const _PopupDialogContent({
    Key? key,
    this.discount,
    required this.autoCloseDuration,
  }) : super(key: key);

  @override
  State<_PopupDialogContent> createState() => _PopupDialogContentState();
}

class _PopupDialogContentState extends State<_PopupDialogContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    /// Create Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    /// Play opening animation
    _controller.forward();

    /// Auto close after [autoCloseDuration]
    Future.delayed(widget.autoCloseDuration, () {
      closeDialog();
    });
  }

  /// Handles closing with reverse animation
  void closeDialog() async {
    await _controller.reverse(); // Play close animation
    if (mounted && Navigator.canPop(context)) {
      Navigator.of(context).pop(); // Close dialog
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final dialogWidth = screenSize.width * 0.8;
    final dialogHeight = screenSize.height * 0.45;

    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              /// 🌟 Top Floating Lottie
              Positioned(
                top: -dialogHeight * 0.25,
                child: Lottie.asset(
                  'assets/icons/lottie1.json',
                  height: dialogHeight * 0.35,
                  repeat: true,
                ),
              ),

              /// 🌟 Bottom Floating Lottie
              Positioned(
                bottom: -dialogHeight * 0.25,
                child: Lottie.asset(
                  'assets/icons/lottie1.json',
                  height: dialogHeight * 0.35,
                  repeat: true,
                ),
              ),

              /// 🌟 Left Floating Lottie
              Positioned(
                left: -dialogWidth * 0.25,
                top: dialogHeight * 0.15,
                child: Lottie.asset(
                  'assets/icons/lottie1.json',
                  height: dialogHeight * 0.6,
                  repeat: true,
                ),
              ),

              /// 🌟 Right Floating Lottie
              Positioned(
                right: -dialogWidth * 0.25,
                top: dialogHeight * 0.15,
                child: Lottie.asset(
                  'assets/icons/lottie1.json',
                  height: dialogHeight * 0.6,
                  repeat: true,
                ),
              ),

              /// 🌟 Main Dialog
              Container(
                width: dialogWidth,
                height: dialogHeight,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),

                    /// 🏆 Center Animated Discount Icon
                    Lottie.asset(
                      'assets/icons/lottie2.json',
                      height: dialogHeight * 0.35,
                      repeat: false,
                    ),

                    const SizedBox(height: 20),

                     Text(
                      "Woo hoo!!",
                      style: AppTextStyles.nunitoBold(30, color:  AppColor.blackColor),


                    ),

                    const SizedBox(height: 10),

                    /// Discount Text
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: "Smart choice! ",
                          style: AppTextStyles.nunitoRegular(16, color:  AppColor.blackColor),
                        ),
                        TextSpan(
                          text:
                          "  ${widget.discount}% off applied\n", // add newline before "successfully!"
                          style: AppTextStyles.nunitoRegular(16, color:  AppColor.primaryColor),
                        ),
                        TextSpan(
                          text: "successfully!",
                          style: AppTextStyles.nunitoRegular(16, color:  AppColor.blackColor),
                        ),
                      ],
                    ),
                  ),

                    /// ✅ Success Check Animation
                    // Lottie.asset(
                    //   'assets/icons/lottie3.json',
                    //   height: dialogHeight * 0.2,
                    //   repeat: false,
                    // ),


                    /// Close Button

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// class PopupDialog {
//   static Future<void> show(BuildContext context, String? discount,
//       {Duration duration = const Duration(seconds: 2)}) async {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         // Auto dismiss after duration
//         Future.delayed(duration, () {
//           if (Navigator.canPop(context)) {
//             Navigator.of(context).pop();
//           }
//         });
//
//         return Center(
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   SvgPicture.asset(
//                     AppImage.emoji,
//                     height: 100,
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "Woo hoo!!",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.black87,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: "Smart choice! ",
//                           style: AppStyle.textStyleReemKufi.copyWith(
//                             // fontWeight: FontWeight.w600,
//                             color: AppColor.greyColor,
//                             fontSize: 16,
//                           ),
//                         ),
//                         TextSpan(
//                           text:
//                           "  ${discount}% off applied\n", // add newline before "successfully!"
//                           style: AppStyle.textStyleReemKufi.copyWith(
//                             // fontWeight: FontWeight.w600,
//                             color: AppColor.primaryColor,
//                             fontSize: 16,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "successfully!",
//                           style: AppStyle.textStyleReemKufi.copyWith(
//                             // fontWeight: FontWeight.w600,
//                             color: AppColor.greyColor,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
