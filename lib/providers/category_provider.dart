import 'package:flutter/material.dart';

import '../models/category_models.dart';
import '../models/items_model.dart';
import '../models/product_model.dart';
import '../service/download_manager.dart';


class CategoryProvider with ChangeNotifier {
  int _selectedCategoryId = 1;

  int get selectedCategoryId => _selectedCategoryId;

  void selectCategory(int id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  int _selectedHeatLevel = 0; // 0 - Mild, 1 - Medium, 2 - Hot
  String _selectedHeatLabel = "Mild"; // default

  int get selectedHeatLevel => _selectedHeatLevel;
  String get selectedHeatLabel => _selectedHeatLabel;

  void setHeatLevel(int level) {
    _selectedHeatLevel = level;
    final heatLabels = ['Mild', 'Medium', 'Hot'];
    _selectedHeatLabel = heatLabels[level];

    notifyListeners();
  }

  Map<String, int> _spicyLevels = {};

  Map<String, int> get spicyLevels => _spicyLevels;

// Set spicy level for a category
  void setSpicyLevel(String categoryId, int level) {
    _spicyLevels[categoryId] = level;
    notifyListeners();
  }

// Get spicy level for a specific category
  int getSpicyLevel(String categoryId) {
    return _spicyLevels[categoryId] ?? 0;
  }

  void loadSpicyFromCart(CartItemModel cartItem) {
    _spicyLevels.clear();

    // Safely check for null or mismatched lengths
    if (cartItem.categoryIds == null || cartItem.spicyLevel == null) {
      print("⚠️ Missing categoryIds or spicyLevel in cartItem");
      return;
    }

    final int minLength =
    cartItem.categoryIds!.length < cartItem.spicyLevel!.length
        ? cartItem.categoryIds!.length
        : cartItem.spicyLevel!.length;

    for (int i = 0; i < minLength; i++) {
      final String categoryId = cartItem.categoryIds![i];
      final String spicyValue = cartItem.spicyLevel![i];

      if (categoryId.isNotEmpty && spicyValue.isNotEmpty) {
        _spicyLevels[categoryId] = int.tryParse(spicyValue) ?? 0;
        print("✅ Category ID: $categoryId | Selected Spicy Level: ${_spicyLevels[categoryId]}");
      }
    }

    notifyListeners();
  }




  String _selectedSize = 'Small';

  String get selectedSize => _selectedSize;

  String _selectedSort = 'Popular'; // default
  String get selectedSort => _selectedSort;

  void setSortOption(String sort) {
    _selectedSort = sort;
    notifyListeners();
  }

  void setSelectedSize(String size) {
    _selectedSize = size;
    _quantity = 1;
    notifyListeners();
  }

  bool _isDineIn = false;

  bool get isDineIn => _isDineIn;

  void setDineIn(bool value) {
    _isDineIn = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<ComboProductModel>? _comboProduct;
  List<ComboProductModel>? get comboProduct => _comboProduct;

  List<Item>? _buyOneGetOne;
  List<Item>? get buyOneGetOne => _buyOneGetOne;

  Future<void> getComboProduct(BuildContext context,String? searchText,String? sortBy) async {
    setLoading(true);
    _comboProduct = await DownloadManager().getComboOffer(context,searchText,sortBy);
    setLoading(false);
    notifyListeners();
  }



  double _basePrice = 0.0;
  int _quantity = 1;
  ChildCategory? _selectedChildCategory;

  ChildCategory? get selectedChildCategory => _selectedChildCategory;


  void clearSelectedChildCategory() {
    _selectedChildCategory = null;
    notifyListeners();
  }
  void setAddOnsTotal(double total) {
    _addOnsTotal = total;
    notifyListeners();
  }
  void setBasePrice(double price) {
    _basePrice = price;
    print('Base price set to: $_basePrice');
    notifyListeners();
  }


  /// include childCategoryTakeawayPrice
//   void setBasePriceWithTakeAway(Item product) {
//     double base = 0.0;
//
//     // 1️⃣ Always start with the main product price
//     if (product.price != null && product.price!.isNotEmpty) {
//       base = double.tryParse(product.price!) ?? 0.0;
//     }
//
//     // 2️⃣ If a child category is selected → use its takeAwayPrice (if available)
//     if (_selectedChildCategory != null) {
//       if (_selectedChildCategory!.takeAwayPrice != null) {
//         base += _selectedChildCategory!.takeAwayPrice!.toDouble();
//       }
//     }
//     // 3️⃣ If no child selected, but child categories exist → use the first child's takeAwayPrice (if available)
//     else if (product.childCategory.isNotEmpty) {
//       final firstChild = product.childCategory.first;
//       if (firstChild.takeAwayPrice != null) {
//         base += firstChild.takeAwayPrice!.toDouble();
//       }
//     }
//     // 4️⃣ If there are NO child categories → fallback to product-level takeAwayPrice
//     else if (product.takeAwayPrice != null && product.takeAwayPrice!.isNotEmpty) {
//       base += double.tryParse(product.takeAwayPrice!) ?? 0.0;
//     }
//
//     _basePrice = base;
//     notifyListeners();
//   }
  void setBasePriceWithTakeAway(Item product) {
    double base = 0.0;

    // 1️⃣ Always start with the main product price
    if (product.price != null && product.price!.isNotEmpty) {
      base = double.tryParse(product.price!) ?? 0.0;
    }

    // 2️⃣ Use only product-level takeAwayPrice (ignore child category)
    if (product.takeAwayPrice != null && product.takeAwayPrice!.isNotEmpty) {
      base += double.tryParse(product.takeAwayPrice!) ?? 0.0;
    }

    _basePrice = base;
    notifyListeners();
  }

  void setBasePriceWithTakeAwayS(CartItemModel product) {
    double base = 0.0;

    // 1️⃣ Always start with the main product price
    if (product.price != null) {
      base = product.price!;
    }

    // 2️⃣ Use only product-level takeAwayPrice (ignore child category)
    if (product.takeAwayPrice != null) {
      base += product.takeAwayPrice!;
    }

    _basePrice = base;
    notifyListeners();
  }


  void setBasePriceWithTakeAwayCombo(ComboProductModel product) {
    double base = 0.0;

    // 1️⃣ Always start with the main product price
    if (product.discountPrice != null && product.discountPrice!.isNotEmpty) {
      base = double.tryParse(product.discountPrice!) ?? product.price.toDouble();
    } else {
      base = product.price.toDouble();
    }

    // 2️⃣ If a child category is selected → use its takeAwayPrice (if available)
    if (_selectedChildCategory != null) {
      if (_selectedChildCategory!.takeAwayPrice != null) {
        base += _selectedChildCategory!.takeAwayPrice!.toDouble();
      }
    }
    // 3️⃣ If no child selected, but child categories exist → use the first child's takeAwayPrice (if available)
    else if (product.childCategory.isNotEmpty) {
      final firstChild = product.childCategory.first;
      if (firstChild.takeAwayPrice != null) {
        base += firstChild.takeAwayPrice!.toDouble();
      }
    }
    // 4️⃣ If there are NO child categories → fallback to product-level takeAwayPrice
    else if (product.takeAwayPrice != null && product.takeAwayPrice!.isNotEmpty) {
      base += double.tryParse(product.takeAwayPrice!) ?? 0.0;
    }

    _basePrice = base;
    notifyListeners();
  }

  void setBasePriceWithTakeAwayCombos(CartItemModel product) {
    double base = 0.0;

    // 1️⃣ Always start with the main product price
    if (product.price != null) {
      base = product.price!.toDouble();
    }

    // 2️⃣ If a child category is selected → use its takeAwayPrice (if available)
    if (_selectedChildCategory != null) {
      if (_selectedChildCategory!.takeAwayPrice != null) {
        base += _selectedChildCategory!.takeAwayPrice!.toDouble();
      }
    }
    // 3️⃣ If no child selected, but child categories exist → use the first child's takeAwayPrice (if available)
    else if (product.childCategory != null && product.childCategory!.isNotEmpty) {
      final firstChild = product.childCategory!.first;
      if (firstChild.takeAwayPrice != null) {
        base += firstChild.takeAwayPrice!.toDouble();
      }
    }
    // 4️⃣ If there are NO child categories → fallback to product-level takeAwayPrice
    else if (product.takeAwayPrice != null) {
      base += product.takeAwayPrice!.toDouble();
    }

    _basePrice = base;
    notifyListeners();
  }


  void setTakeAwayPrice(String price) {
    _comboTakeAwayPrice = double.tryParse(price) ?? 0.0; // Convert String to double
    print('Takeaway price set: $_comboTakeAwayPrice');   // ✅ Print for debugging
    notifyListeners();
  }




  int _totalTime = 0;

  int get totalTime => _totalTime;

  void setTotalTime(int time) {
    _totalTime = time;
    notifyListeners();
  }


  // Optional: If you want to update quantity and total time together

  void setQuantity(int qty) {
    _quantity = qty;
    notifyListeners();
  }

  void increaseQuantity() {
    _quantity++;
    print("Quantity increased: $_quantity");
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      print("Quantity decreased: $_quantity");
      notifyListeners();
    }
  }

  void setSelectedChildCategory(ChildCategory? child) {
    _selectedChildCategory = child;
    notifyListeners();
  }

  double get comboSelectedPrices =>  selectedComboPrice * _quantity;
  double get comboSelectedTakeAwayPrices => selectedComboWithTakeAwayPrice * _quantity;


  double get selectedPrices {
    if (_selectedChildCategory != null && _selectedChildCategory!.price != null) {
      return _selectedChildCategory!.price.toDouble();
    }
    return _basePrice; // ✅ Always fallback correctly
  }


  double get selectedPrice {
    double price = _basePrice; // Start with base product price

    if (_selectedChildCategory != null) {
      // Add child category price
      price = (_selectedChildCategory!.price.toDouble() ?? 0.0)
          + (_selectedChildCategory!.takeAwayPrice.toDouble() ?? 0.0);
    }

    return price;
  }

  double _addOnsTotal = 0.0;
  // double get selectedPrices {
  //   if (_selectedChildCategory != null && _selectedChildCategory!.price != null) {
  //     return _selectedChildCategory!.price.toDouble() + _addOnsTotal;
  //   }
  //   return _basePrice + _addOnsTotal; // Always include add-ons
  // }
  //
  // double get selectedPrice {
  //   double price = _basePrice;
  //
  //   if (_selectedChildCategory != null) {
  //     price = (_selectedChildCategory!.price.toDouble() ?? 0.0) +
  //         (_selectedChildCategory!.takeAwayPrice.toDouble() ?? 0.0) +
  //         _addOnsTotal; // include add-ons
  //   } else {
  //     price += _addOnsTotal;
  //   }
  //
  //   return price;
  // }

  double get selectedComboPrice {
    double price = _basePrice; // Start with base product price

    return price;
  }

  double get selectedComboWithTakeAwayPrice {
    // Print base price and takeaway price
    //print('Base prices: $_basePrice');
    //print('Takeaway prices: $_comboTakeAwayPrice');

    // Total price = base price + takeaway price
    double price = _basePrice + (_comboTakeAwayPrice ?? 0.0);
    // print('Total price: $price'); // Optional: print total

    return price;
  }



  double get totalPrices => selectedPrices * _quantity;

  double get totalPriceWithTakeWay => selectedPrice * _quantity;



  int get quantity => _quantity;



  double _takeAwayPrice = 0.0;
  double _comboTakeAwayPrice = 0.0;
  double get grandTotalPrice {
    double takeAway = 0.0;

    // ✅ First check child category takeAwayPrice
    if (_selectedChildCategory != null && _selectedChildCategory!.takeAwayPrice != null) {
      takeAway = _selectedChildCategory!.takeAwayPrice!.toDouble();
    }
    // ✅ Fallback to product-level takeAwayPrice if child category doesn't have it
    else if (_takeAwayPrice > 0) {
      takeAway = _takeAwayPrice;
    }

    // ✅ Add base price + takeaway price, then multiply by quantity
    return (selectedPrice + takeAway) * _quantity;
  }
  double discountPrice = 0.0;
  double takeAwayPrice = 0.0;
  double price = 0.0;


  // double get totalComboPrice {
  //   // Debug prints
  //   // print('Discount Price: $discountPrice');
  //   // print('TakeAway Price: $takeAwayPrice');
  //   // print('Quantity: $_quantity');
  //   // print('Total Combo Price: ${(discountPrice + takeAwayPrice) * _quantity}');
  //
  //   return (discountPrice + takeAwayPrice) * _quantity;
  // }
  double totalComboPrice({
    ChildCategory? selectedChild,
    required CategoryProvider provider,
  }) {
    // If child category is selected → use its price * provider quantity
    if (selectedChild != null) {
      final double childPrice = selectedChild.price ?? 0.0;

      // Debugging
      // print('Selected Child Price: $childPrice');
      // print('Quantity (from provider): ${provider.quantity}');
      // print('Total (Child): ${childPrice * provider.quantity}');

      return childPrice * provider.quantity;
    }
    final double validDiscountPrice = discountPrice ??  price ;

    // Otherwise → fallback to discountPrice + takeAwayPrice
    final double total = (validDiscountPrice + takeAwayPrice) * provider.quantity;

    // Debugging
    // print('Discount Price: $discountPrice');
    // print('TakeAway Price: $takeAwayPrice');
    // print('Quantity (from provider): ${provider.quantity}');
    // print('Total (Fallback): $total');

    return total;
  }

  double getChildCategoryOrDiscountTotal(
      CartItemModel cartItem, ChildCategory? selectedChild, CategoryProvider provider) {

    double total = 0.0;

    if (selectedChild != null) {
      final double childPrice = selectedChild.price ?? 0.0;
      total = childPrice * provider.quantity;

      print('Selected Child Price: $childPrice');
      print('Quantity: ${provider.quantity}');
      print('Total: $total');
    } else {
      final double discountPrice = (cartItem.discountPrice != null && cartItem.discountPrice!.isNotEmpty)
          ? double.tryParse(cartItem.discountPrice!) ?? cartItem.price ?? 0.0
          : cartItem.price ?? 0.0;

      total = discountPrice * provider.quantity;

      print('Discount Prices: $discountPrice');
      print('Quantitys: ${provider.quantity}');
      print('Totals: $total');
    }

    return total;
  }






  void setPrices({required double discount, required double takeAway}) {
    discountPrice = discount;
    takeAwayPrice = takeAway;
    notifyListeners();
  }


  final Map<int, String> _selectedChildCategoryPerProduct = {};

  String? getSelectedChildCategoryId(int productId) {
    return _selectedChildCategoryPerProduct[productId];
  }

  void setSelectedChildCategoryId(int productId, String? childCategoryId) {
    if (childCategoryId == null) {
      _selectedChildCategoryPerProduct.remove(productId);
    } else {
      _selectedChildCategoryPerProduct[productId] = childCategoryId;
    }
    notifyListeners();
  }
  /// Clear selected child category for a product
  final Map<int, ChildCategory?> _lastSelectedByProduct = {};

  void setSelectedChildCategorys(ChildCategory? child, {int? productId}) {
    _selectedChildCategory = child;

    if (productId != null && child != null) {
      _lastSelectedByProduct[productId] = child;
    }

    notifyListeners();
  }

  ChildCategory? getLastSelectedChildCategoryForProduct(int productId) {
    return _lastSelectedByProduct[productId];
  }
  void resetLastSelectedChildCategory(int productId) {
    _lastSelectedByProduct[productId] = null;
    notifyListeners();
  }

}
