import 'add_on.dart';
import 'category_models.dart';
import 'items_model.dart';

class DataResponse {
  final List<CategoryModel> categories;
  final List<Item> items;

  DataResponse({required this.categories, required this.items});

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      categories: (json['category'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e))
          .toList(),
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String image;
  final int? categoryId;
  final double price;
  final bool? isCombo; // <-- Add this
  String? prepareTime;

  ProductModel(
      {required this.id,
      required this.name,
      required this.image,
      this.categoryId,
      required this.price,
      this.isCombo,
      this.prepareTime // <-- Add this
      });
}

class ComboProductModel {
  final int id;
  final String name;
  final List<String> images; // Changed from single image to list
  final int price;
  final String? time;
  final String? disountPercent;
  final String? discountPrice;
  final int categoryId;
  final bool? isCombo;
  String? takeAwayPrice;
  final CategoryModel? category;
  final List<String> categoryName;
  final List<String> description;
  final List<String> subCategoryIds; // ✅ Added
  final List<String> childCategoryIds; // ✅ Added
  final List<ChildCategory> childCategory;
  final List<AddOnModel> addOns; // <-- new

  ComboProductModel({
    required this.id,
    required this.name,
    required this.images,
    required this.price,
    this.time,
    this.discountPrice,
    this.disountPercent,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    this.isCombo,
    this.category,
    this.takeAwayPrice,
    required this.childCategory,
    required this.subCategoryIds,
    required this.childCategoryIds,
    required this.addOns,
  });

  factory ComboProductModel.fromJson(Map<String, dynamic> json) {
    final rawAddOns = json['addOns'] ?? json['addons'] ?? json['add_ons'];
    final List<AddOnModel> parsedAddOns = (rawAddOns is List)
        ? rawAddOns
            .map((e) => AddOnModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <AddOnModel>[];
    return ComboProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      // description: json['description'] ?? '',
      disountPercent: json['discount_percent'] ?? '',
      discountPrice: json['discount_price'] ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
      time: json['preparing_time'] ?? '',
      categoryId: json['categoryId'] ?? 0,
      isCombo: json['isCombo'],
      takeAwayPrice: json['take_away_price'],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      childCategory: (json['childCategory'] as List<dynamic>?)
              ?.map((e) => ChildCategory.fromJson(e))
              .toList() ??
          [],
      subCategoryIds: json['sub_category_id'] != null
          ? List<String>.from((json['sub_category_id'] as String)
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll('"', '')
              .split(','))
          : [],
      childCategoryIds: json['child_category_id'] != null
          ? List<String>.from((json['child_category_id'] as String)
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll('"', '')
              .split(','))
          : [],
      categoryName: json['category_name'] != null
          ? List<String>.from(json['category_name'])
          : [],
      description: json['description'] != null
          ? List<String>.from(json['description'])
          : [],

      addOns: parsedAddOns,
    );
  }
}

class CartItemModel {
  final int id;
  final String name;
  String? description;
  final List<String> images;
  final int? categoryId;
  final double price;
  int quantity;
  //final List<int>? subCategoryIds;
  final int? subCategoryId;
  final String? childCategoryId;
  final String? childCategoryName;
  final bool? isCombo;
  double? takeAwayPrice;
  String? heatLevel;
  final String? type; // type of cart item (e.g., normal, offer, etc.)
  final int? comboId;
  final int? totalDeliveryTime;
  String? prepareTime;
  List<String>? subCategoryIds; // ✅ Added
  List<String>? childCategoryIds; // ✅ Added
  List<ChildCategory>? childCategory;
  List<String>? categoryName;
  final String? spicy;
   String? image;

  CartItemModel({
    required this.id,
    required this.name,
    required this.images,
    this.categoryId,
    this.subCategoryId,
    required this.price,
    this.quantity = 1,
    this.childCategoryId,
    this.childCategoryName,
    this.isCombo,
    this.takeAwayPrice,
    this.heatLevel,
    this.type,
    this.comboId,
    this.totalDeliveryTime,
    this.prepareTime,
    this.categoryName,
    this.description,
    this.childCategory,
    this.subCategoryIds,
    this.childCategoryIds,
    this.spicy,
     this.image,
  });

  // Factory constructor from ProductModel
  // factory CartItemModel.fromProduct(ProductModel product, {int quantity = 1}) {
  //   return CartItemModel(
  //     id: product.id,
  //     name: product.name,
  //     images: [product.image], // Single image converted to list
  //     categoryId: product.categoryId,
  //     price: product.price,
  //     quantity: quantity,
  //     isCombo: product.isCombo,
  //     prepareTime: product.prepareTime,
  //   );
  // }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'price': price,
      'quantity': quantity,
      'child_category_id': childCategoryId,
      //   'childcategoryName': childCategoryName,
      'take_away_price': takeAwayPrice,
      "type": type,
      "combo_id": comboId,
      //  'products': products?.map((product) => product.toJson()).toList() ?? [],
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'child_category_id': childCategoryId,
      'name': name,
    };
  }
  // Factory constructor from ComboProductModel
  // factory CartItemModel.fromCombo(ComboProductModel combo, {int quantity = 1}) {
  //   return CartItemModel(
  //     id: combo.id,
  //     name: combo.name,
  //     images: combo.images, // Already a list
  //     categoryId: combo.categoryId,
  //     price: combo.price.toDouble(),
  //     quantity: quantity,
  //     isCombo: combo.isCombo,
  //   );
  // }

  double get totalPrice => price * quantity;
}
