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

    // map index -> label
    final heatLabels = ['Mild', 'Medium', 'Hot'];
    _selectedHeatLabel = heatLabels[level];

    notifyListeners();
  }

  // List<ProductModel> get selectedCategoryProducts =>
  //     _products.where((p) => p.categoryId == _selectedCategoryId).toList();

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

  Future<void> getBuyOneOffer(BuildContext context,String? searchText,String sortBy) async {
    setLoading(true);
    _buyOneGetOne = await DownloadManager().bugOneGetOne(context,searchText,sortBy);
    setLoading(false);
    notifyListeners();
  }

  double _basePrice = 0.0;
  int _quantity = 1;
  ChildCategory? _selectedChildCategory;

  void setBasePrice(double price) {
    _basePrice = price;
    notifyListeners();
  }

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

  // double get selectedPrice {
  //
  //   if (_selectedChildCategory != null) {
  //     return (_selectedChildCategory!.price ?? _basePrice).toDouble();
  //   }
  //
  //   return _basePrice;
  // }

  double get selectedPrice {
    if (_selectedChildCategory != null && _selectedChildCategory!.price != null) {
      return _selectedChildCategory!.price!.toDouble();
    }
    return _basePrice; // ✅ Always fallback correctly
  }

  double get totalPrice => selectedPrice * _quantity;

  int get quantity => _quantity;
  ChildCategory? get selectedChildCategory => _selectedChildCategory;
}
