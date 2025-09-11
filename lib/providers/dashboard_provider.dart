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

  String _selectedSort = '';        // API value
  String _selectedSortLabel = '';   // UI value

  String get selectedSort => _selectedSort;
  String get selectedSortLabel => _selectedSortLabel;

  void setSortOption(String apiSort, String label) {
    _selectedSort = apiSort;
    _selectedSortLabel = label;
    notifyListeners();
  }

  void clearSort() {
    _selectedSort = '';
    _selectedSortLabel = '';
    notifyListeners();
  }
  String _comboSelectedSort = '';
  String _comboSelectedSortLabel = '';

  String get comboSelectedSort => _comboSelectedSort;
  String get comboSelectedSortLabel => _comboSelectedSortLabel;

  void setComboSortOption(String apiSort, String label) {
    _comboSelectedSort = apiSort;
    _comboSelectedSortLabel = label;
    notifyListeners();
  }

  void clearComboSort() {
    _comboSelectedSort = '';
    _comboSelectedSortLabel = '';
    notifyListeners();
  }

  // 🔸 Offer products
  String _offerSelectedSort = '';
  String _offerSelectedSortLabel = '';

  String get offerSelectedSort => _offerSelectedSort;
  String get offerSelectedSortLabel => _offerSelectedSortLabel;

  void setOfferSortOption(String apiSort, String label) {
    _offerSelectedSort = apiSort;
    _offerSelectedSortLabel = label;
    notifyListeners();
  }

  void clearOfferSort() {
    _offerSelectedSort = '';
    _offerSelectedSortLabel = '';
    notifyListeners();
  }

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

  Future<void> getCategoryBasedItems(BuildContext context,int? categoryId, String? sortBy) async {
    setLoading(true);
    _items = await DownloadManager().getCategoryItems(context,categoryId,sortBy);
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

  Future<void> getBuyOneOffer(BuildContext context,String? searchText,String? sortBy) async {
    setLoading(true);
    _buyOneGetOne = await DownloadManager().bugOneGetOne(context,searchText,sortBy);
    setLoading(false);
    notifyListeners();
  }

  Future<void> bugOneGetOneOfferSearch(BuildContext context,String? searchText,) async {
    setLoading(true);
    _buyOneGetOne = await DownloadManager().bugOneGetOneOfferSearch(context,searchText);
    setLoading(false);
    notifyListeners();
  }

  Future<void> getComboProduct(BuildContext context,String? searchText,String sortBy) async {
    setLoading(true);
    _comboProduct = await DownloadManager().getComboOffer(context,searchText,sortBy);
    setLoading(false);
    notifyListeners();
  }
}