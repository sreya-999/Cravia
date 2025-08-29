import 'package:flutter/cupertino.dart';
import 'package:ravathi_store/models/category_models.dart';

import '../models/banner_model.dart';
import '../models/items_model.dart';
import '../models/product_model.dart';
import '../service/download_manager.dart';

class DashboardProvider extends ChangeNotifier {

  List<BannerModel>? _homeBanner;

  List<BannerModel>? get homeBanner => _homeBanner;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Item>? _items;
  List<Item>? get items => _items;

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  // Track selected category
  int _selectedCategoryId = -1; // -1 for "All"
  int get selectedCategoryId => _selectedCategoryId;

  List<Item>? _buyOneGetOne;
  List<Item>? get buyOneGetOne => _buyOneGetOne;

  List<ComboProductModel>? _comboProduct;
  List<ComboProductModel>? get comboProduct => _comboProduct;

  void selectCategory(int categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  Future<void> getBannerImage(BuildContext context) async {
    setLoading(true);
    _homeBanner = await DownloadManager().getBanner(context);
    setLoading(false);
    notifyListeners();
  }

  Future<void> getCategoryBasedItems(BuildContext context,int? categoryId) async {
    setLoading(true);
    _items = await DownloadManager().getCategoryItems(context,categoryId);
    setLoading(false);
    notifyListeners();
  }

  Future<void> getCategorys(BuildContext context) async {
    setLoading(true);
    _categoryList = await DownloadManager().getCategory(context);
    setLoading(false);
    notifyListeners();
  }

  Future<void> getSearchProduct(BuildContext context,String? searchText,int? categoryId) async {
    setLoading(true);
    _items = await DownloadManager().searchText(context,searchText,categoryId);
    setLoading(false);
    notifyListeners();
  }

  Future<void> getBuyOneOffer(BuildContext context,String? searchText) async {
    setLoading(true);
    _buyOneGetOne = await DownloadManager().bugOneGetOne(context,searchText);
    setLoading(false);
    notifyListeners();
  }

  Future<void> getComboProduct(BuildContext context,String? searchText) async {
    setLoading(true);
    _comboProduct = await DownloadManager().getComboOffer(context,searchText);
    setLoading(false);
    notifyListeners();
  }
}