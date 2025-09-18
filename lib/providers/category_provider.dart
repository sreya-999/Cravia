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

  void clearSelectedChildCategory() {
    _selectedChildCategory = null;
    notifyListeners();
  }

  void setBasePrice(double price) {
    _basePrice = price;
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


  void setTakeAwayPrice(double price) {
    _takeAwayPrice = price;
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

  double get totalPrices => selectedPrices * _quantity;
  double get totalPrice => selectedPrices * _quantity;


  int get quantity => _quantity;
  ChildCategory? get selectedChildCategory => _selectedChildCategory;


  double _takeAwayPrice = 0.0;

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

}
