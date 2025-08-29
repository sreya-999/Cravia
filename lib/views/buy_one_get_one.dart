import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ravathi_store/utlis/App_image.dart';
import 'package:ravathi_store/views/home_screen.dart';
import 'package:ravathi_store/views/view_order_screen.dart';
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
import '../utlis/widgets/custom_appbar.dart';
import '../utlis/widgets/shimmer_loading.dart';

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

      categoryProvider.getBuyOneOffer(context, null,"");
    });
  }


  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
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
                          style: const TextStyle(
                            fontFamily: 'Reem Kufi',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black, // ✅ Ensures typed text is visible
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              fontFamily: 'Reem Kufi',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.grey, // ✅ Make hint different from typed text
                            ),
                            prefixIcon: Icon(Icons.search, color: AppColor.primaryColor),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            print("Search value: $value");
                            // Provider.of<CategoryProvider>(context, listen: false)
                            //     .getBuyOneOffer(context, value);
                            Provider.of<DashboardProvider>(context, listen: false)
                                .getBuyOneOffer(context,_controller.text,null);
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
                          _openSortDialog(context);
                        },
                      ),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Consumer<CategoryProvider>(
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
                    if (products== null) {
                      return  Center(child: Text("No products available",style: AppStyle.textStyleReemKufi.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.greyColor,
                        fontSize: 18,
                      ),
                        textAlign: TextAlign.center,
                      ));
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
                                          (product.name.isNotEmpty)
                                              ? product.name[0].toUpperCase() + product.name.substring(1).toLowerCase()
                                              : '',
                                          style: AppStyle.textStyleReemKufi.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                        product.description.toString() ?? '',
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
                                  top: -10,
                                  left: 5,
                                  child: Image.asset(
                                    AppImage.badge,
                                    width: badgeSize,
                                  ),
                                ),
                                // Add icon exactly in bottom-right corner
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
    String selectedOption = 'Popular';
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
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 16, left: 16),
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
                          color: isSelected
                              ? Colors.white
                              : Colors.transparent,
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
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim1),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }


  void _openSortDialog(BuildContext context) async {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    final selectedOption = await showSortByDialog(context, provider.selectedSort);

    if (selectedOption != null && selectedOption.isNotEmpty) {
      provider.setSortOption(selectedOption);


      switch (selectedOption) {
        case 'Popular':
          provider.getBuyOneOffer(context,"",'popular');
          break;
        case 'Newest':
          provider.getBuyOneOffer(context,"",'newest');
          break;
        case 'Price: Lowest to high':
          provider.getBuyOneOffer(context, "", 'price_asc');
          break;
        case 'Price: Highest to low':
          provider.getBuyOneOffer(context, "", 'pce_desc');
          break;
      }
    }
  }

  void showBurgerDialog(BuildContext context,Item product) {
    final selectedProvider =
    Provider.of<CategoryProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final double buttonFontSize = isDesktop ? 25 : isTablet ? 17 : 16;
    final double priceSize = isDesktop ? 27 : isTablet ? 17 : 17;
    final double description = isDesktop ? 20 : isTablet ? 15 : 15;
    // Set base price
    selectedProvider.setBasePrice(
      double.tryParse(product.price ?? '0') ?? 0.0,
    );

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
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.primaryColor,
                              AppColor.whiteColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.3, 0.25], // 👈 transition from primary → secondary at 70% height
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
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
                                      SizedBox(height: 20,),// Title + Price
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              (product.name.isNotEmpty)
                                                  ? product.name[0].toUpperCase() + product.name.substring(1).toLowerCase()
                                                  : '',
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
                                      SizedBox(height: 4,),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              product.description,
                                              style: AppStyle.textStyleReemKufi
                                                  .copyWith(
                                                  color: AppColor.lightGreyColor,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(
                                            product.time != null ? '${product.time} mins' : '',
                                            style: AppStyle.textStyleReemKufi.copyWith(
                                              color: AppColor.greyColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (product.childCategory != null && product.childCategory.isNotEmpty) ...[
                                        SizedBox(height: screenHeight * 0.025),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: product.childCategory.map((child) {
                                            final selectedChild = context.watch<CategoryProvider>().selectedChildCategory;
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
                                      ],
                                      SizedBox(height: screenHeight * 0.025),

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
                                    padding:const EdgeInsets.symmetric(horizontal: 12,vertical:6),
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryColor,
                                     borderRadius: BorderRadius.circular(2)
                                    ),
                                  ),
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
                                                  fontSize: isDesktop ? 17 : 16,
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
                                          final selectedChild = context.read<CategoryProvider>().selectedChildCategory; // ✅ use read

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
                                            isCombo: false,
                                            takeAwayPrice: selectedChild?.takeAwayPrice,
                                            subCategoryId: selectedChild?.subCategoryId ?? 0,
                                            childCategoryId: selectedChild?.id.toString(),      // 👈 pass child id if selected
                                            childCategoryName: selectedChild?.name,
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
                        padding: const EdgeInsets.only(top: 8,bottom: 16,left: 16),
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
                              icon: const Icon(Icons.close,color: Colors.white,),
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


