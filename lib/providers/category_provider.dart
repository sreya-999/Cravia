import 'package:flutter/material.dart';

import '../models/category_models.dart';
import '../models/items_model.dart';
import '../models/product_model.dart';
import '../service/download_manager.dart';


class CategoryProvider with ChangeNotifier {
  int _selectedCategoryId = 1;

  final List<CategoryModel> _categories = [
    CategoryModel(id: 1, name: 'Burger', image: 'https://img.pikbest.com/origin/09/17/77/71vpIkbEsTIN8.png!sw800'),
    CategoryModel(id: 2, name: 'Fresh Juice', image: 'https://media.istockphoto.com/id/1316298380/photo/champagne-coupe-glass-of-refreshing-orange-cocktail-with-ice-served-on-gray-table-surface.jpg?s=612x612&w=0&k=20&c=U-Yupox-haVt4rXzyQDdkMKl8tTTRTXL9GCbpCWkTJI='),
    CategoryModel(id: 3, name: 'Pizza', image: 'https://media.istockphoto.com/id/1149135424/photo/group-of-sweet-and-salty-snacks-perfect-for-binge-watching.jpg?s=612x612&w=0&k=20&c=YAVqRyUJgj_nXpltYUPpaW_PYtd4v2TC5Mo0DtVFuoo='),
    CategoryModel(id: 4, name: 'Biriyani', image: 'https://www.chilipeppermadness.com/wp-content/uploads/2024/10/Chicken-Biryani-Recipe-SQ-scaled.jpg'),

  ];

  final List<ProductModel> _products = [
    ProductModel(id: 1, name: 'Chicken Burger', image: 'https://img.pikbest.com/png-images/20250218/delicious-cheese-burger-_11536406.png!w700wp',
         categoryId: 1, price: 20),
    ProductModel(id: 2, name: 'Veg Burger', image: 'https://img.pikbest.com/png-images/20241202/tasty-fresh-beef-burger-with-delicious-cheese-free-png-and-clipart_11160704.png!w700wp',
        categoryId: 1, price: 15),
    ProductModel(id: 3, name: 'Apple Juice', image: 'https://images.onlymyhealth.com/imported/images/2022/November/19_Nov_2022/main-applejuicebenefits.jpg', categoryId: 2, price: 78),
    ProductModel(id: 4, name: 'Chikoo Juice', image: 'https://5.imimg.com/data5/SELLER/Default/2021/7/CR/CO/FE/26828545/chickoo-juice-500x500.jpg', categoryId: 2, price: 55),
    ProductModel(id: 5, name: 'Veg Pizza', image: 'https://img.pikbest.com/png-images/20240625/meat-and-cheese-quesadillas-delicious_10637190.png!w700wp', categoryId: 3, price: 60),
    ProductModel(id: 6, name: 'Butter Pizza', image: 'https://img.pikbest.com/png-images/20240625/meat-and-cheese-quesadillas-delicious_10637190.png!w700wp', categoryId: 3, price: 90),
    ProductModel(id: 7, name: 'Chicken', image: 'https://cookingfromheart.com/wp-content/uploads/2020/09/Thalassery-Egg-Biriyani-2.jpg', categoryId: 4, price: 90),
    ProductModel(id: 8, name: 'Beef', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxAOW7aTEqMA8kpWO2iaDA85jZoZf2LGqLJA&s', categoryId: 4, price: 90),
    ProductModel(id: 9, name: 'Mutton', image: 'https://www.cubesnjuliennes.com/wp-content/uploads/2021/03/Best-Mutton-Biryani-Recipe.jpg', categoryId: 4, price: 90),
    ProductModel(id: 10, name: 'Mango Juice', image: 'https://images.pexels.com/photos/16557598/pexels-photo-16557598/free-photo-of-fresh-juice-in-a-glass-and-fruits.jpeg', categoryId: 2, price: 30),
    ProductModel(id: 11, name: 'Grilled veg', image: 'https://img.pikbest.com/png-images/20240625/delicious-quesadillas-plate-meat-and-cheese-cheesy-_10637200.png!w700wp', categoryId: 3, price: 30),
    ProductModel(id: 12, name: 'Cheese burger', image:  'https://img.pikbest.com/png-images/20241202/tasty-fresh-beef-burger-with-delicious-cheese-free-png-and-clipart_11160704.png!w700wp', categoryId: 1, price: 80),
    ProductModel(id: 13, name: 'Cheese burger', image:  'https://img.pikbest.com/png-images/20241202/tasty-fresh-beef-burger-with-delicious-cheese-free-png-and-clipart_11160704.png!w700wp', categoryId: 1, price: 80),
    ProductModel(id: 14, name: 'Cheese burger', image:  'https://img.pikbest.com/png-images/20250218/delicious-cheese-burger-_11536406.png!w700wp',
        categoryId: 1, price: 80),

  ];

  List<CategoryModel> get categories => _categories;

  int get selectedCategoryId => _selectedCategoryId;

  void selectCategory(int id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  List<ProductModel> get selectedCategoryProducts =>
      _products.where((p) => p.categoryId == _selectedCategoryId).toList();


  final List<ProductModel> _bestOfferProduct= [
    ProductModel(id: 1, name: 'Chicken Burger', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSeiAPhree4G5Zv1rj7AGG-lGYjpf8O3CxuyDtlJ4wIQKQJog7mW-AhvhJwYcrx_nAjS8&usqp=CAU', price: 20),
    ProductModel(id: 2, name: 'Veg Burger', image:         'https://img.pikbest.com/png-images/20241202/tasty-fresh-beef-burger-with-delicious-cheese-free-png-and-clipart_11160704.png!w700wp',
        categoryId: 1, price: 15),
    ProductModel(id: 3, name: 'Cruchy Burger', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXnXGPtleq-sOCf4ghN-q2LiFV2VTDDfLHEX4mkPS3ACytDXpeKTsXfY3xaxMIQW8DqAE&usqp=CAU', categoryId: 2, price: 78),
    ProductModel(id: 4, name: 'Chicken Burger ', image: 'https://pinchofyum.com/wp-content/uploads/Teriyaki-Burgers-9-1.jpg', categoryId: 2, price: 55),
    ProductModel(id: 5, name: 'Chick Burg', image: 'https://pinchofyum.com/wp-content/uploads/Teriyaki-Burgers-9-1.jpg', categoryId: 3, price: 60),
    ProductModel(id: 6, name: 'Butter Pizza', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-5q2KjScnELyjvrEWMhwWRQvx2qs6mxKpAg&s', categoryId: 3, price: 90),
  ];


  List<ProductModel> get bestOfferProducts => _bestOfferProduct;

  final List<ComboProductModel> _comboOffer = [
    ComboProductModel(
      id: 1,
      name: 'Burger + French fried + Lime Juice Burger',
      images: [
        'https://img.pikbest.com/png-images/20250218/delicious-cheese-burger-_11536406.png!w700wp',
        'https://img.pikbest.com/origin/09/17/77/71vpIkbEsTIN8.png!sw800',
        'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJ1aXQlMjBqdWljZXxlbnwwfHwwfHx8MA%3D%3D',
      ],
      price: 60,
      categoryId: 1,
    ),
    ComboProductModel(
      id: 2,
      name: 'Burger + French fried + Lime Juice Burger',
      images: [
        'https://img.pikbest.com/png-images/20241202/tasty-fresh-beef-burger-with-delicious-cheese-free-png-and-clipart_11160704.png!w700wp',
        'https://img.pikbest.com/origin/09/17/77/71vpIkbEsTIN8.png!sw800',
        'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJ1aXQlMjBqdWljZXxlbnwwfHwwfHx8MA%3D%3D',
      ],
      price: 70,
      categoryId: 2,
    ),
    ComboProductModel(
      id: 3,
      name: 'Burger + French fried + Lime Juice Burger',
      images: [
        'https://img.pikbest.com/origin/09/17/77/71vpIkbEsTIN8.png!sw800',
        'https://img.pikbest.com/png-images/20250218/delicious-cheese-burger-_11536406.png!w700wp',
        'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJ1aXQlMjBqdWljZXxlbnwwfHwwfHx8MA%3D%3D',
      ],
      price: 80,
      categoryId: 3,
    ),
  ];

  List<ComboProductModel> get comboOffer => _comboOffer;
  String _selectedSize = 'Small';
  //double _basePrice = 0;
  //int _quantity = 1;

  String get selectedSize => _selectedSize;
  //int get quantity => _quantity;


  // double get selectedPrice {
  //   if (_selectedSize == 'Small') return _basePrice;
  //   if (_selectedSize == 'Medium') return _basePrice + 10;
  //   if (_selectedSize == 'Large') return _basePrice + 20;
  //   return _basePrice;
  // }

  // void setBasePrice(double price) {
  //   _basePrice = price;
  //   notifyListeners();
  // }

  void setSelectedSize(String size) {
    _selectedSize = size;
    _quantity = 1;
    notifyListeners();
  }
 // double get totalPrice => selectedPrice * _quantity;
  // void increaseQuantity() {
  //   _quantity++;
  //   notifyListeners();
  // }
  //
  // void decreaseQuantity() {
  //   if (_quantity > 1) {
  //     _quantity--;
  //     notifyListeners();
  //   }
  // }
  //
  // void setQuantity(int value) {
  //   _quantity = value;
  //   notifyListeners();
  // }


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

  List<Item>? _comboProduct;
  List<Item>? get comboProduct => _comboProduct;

  List<Item>? _buyOneGetOne;
  List<Item>? get buyOneGetOne => _buyOneGetOne;

  Future<void> getComboProduct(BuildContext context,String? searchText) async {
    setLoading(true);
    _comboProduct = await DownloadManager().getComboOffer(context,searchText);
    setLoading(false);
    notifyListeners();
  }

  Future<void> getOffer(BuildContext context,String? searchText) async {
    setLoading(true);
    _comboProduct = await DownloadManager().bugOneGetOne(context,searchText);
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
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void setSelectedChildCategory(ChildCategory? child) {
    _selectedChildCategory = child;
    notifyListeners();
  }

  double get selectedPrice {
    // ✅ If childCategory selected, use its price
    if (_selectedChildCategory != null) {
      return (_selectedChildCategory!.price ?? _basePrice).toDouble();
    }
    // ✅ Otherwise fall back to base price
    return _basePrice;
  }

  double get totalPrice => selectedPrice * _quantity;

  int get quantity => _quantity;
  ChildCategory? get selectedChildCategory => _selectedChildCategory;
}
