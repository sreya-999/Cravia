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
  final List<AddOnModel> addOns;
  final List<String> spicy;// <-- new
  final List<String> categoryIds;

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
    required this.spicy,
    required this.categoryIds

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
      // childCategory: (json['childCategory'] as List<dynamic>?)
      //     ?.map((e) => ChildCategory.fromJson(e))
      //     .toList() ??
      //     [],
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
      spicy: (json['spicy_level'] != null && json['spicy_level'] is List)
          ? List<String>.from(
        (json['spicy_level'] as List).map((e) => e?.toString() ?? '1'),
      )
          : [],



      addOns: parsedAddOns, childCategory: [], categoryIds: json['category_id'] != null
? List<String>.from((json['category_id'] as String)
    .replaceAll('[', '')
    .replaceAll(']', '')
    .replaceAll('"', '')
    .split(','))
    : [],
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
  List<String>? descriptions;
  //final List<int>? subCategoryIds;
  final int? subCategoryId;
  final String? childCategoryId;
  final String? childCategoryName;
  final bool? isCombo;
  double? takeAwayPrice;
//  String? heatLevel;
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
  final String? disountPercent;
  final String? discountPrice;
  List<String>? addOnNames;
  List<double>? addOnPrices;
  final String? cartKey;
  int? heatLevel;
  List<String>? spicyLevel;
  List<String>? categoryIds;


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
    this.disountPercent,
    this.descriptions,
    this.discountPrice,
    this.addOnNames,
    this.addOnPrices,
    this.cartKey,
    this.spicyLevel,
    this.categoryIds
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
     // 'child_category_id': childCategoryId,
      'child_category_id': (childCategoryId == 'home' ||
          childCategoryId == 'bugOne' ||
          childCategoryId == 'combo')
          ? null
          : childCategoryId,
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

extension CartItemModelCopy on CartItemModel {
  CartItemModel copyWith({
    int? id,
    String? name,
    String? description,
    List<String>? images,
    int? categoryId,
    double? price,
    int? quantity,
    List<String>? descriptions,
    int? subCategoryId,
    String? childCategoryId,
    String? childCategoryName,
    bool? isCombo,
    double? takeAwayPrice,
    int? heatLevel,
    String? type,
    int? comboId,
    int? totalDeliveryTime,
    String? prepareTime,
    List<String>? subCategoryIds,
    List<String>? childCategoryIds,
    List<ChildCategory>? childCategory,
    List<String>? categoryName,
    String? spicy,
    String? image,
    String? disountPercent,
    String? discountPrice,
    List<String>? addOnNames,
    List<double>? addOnPrices,
    String? cartKey,
    List<String>? spicyLevel,
    List<String>? categoryIds,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      descriptions: descriptions ?? this.descriptions,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      childCategoryId: childCategoryId ?? this.childCategoryId,
      childCategoryName: childCategoryName ?? this.childCategoryName,
      isCombo: isCombo ?? this.isCombo,
      takeAwayPrice: takeAwayPrice ?? this.takeAwayPrice,
      heatLevel: heatLevel ?? this.heatLevel,
      type: type ?? this.type,
      comboId: comboId ?? this.comboId,
      totalDeliveryTime: totalDeliveryTime ?? this.totalDeliveryTime,
      prepareTime: prepareTime ?? this.prepareTime,
      subCategoryIds: subCategoryIds ?? this.subCategoryIds,
      childCategoryIds: childCategoryIds ?? this.childCategoryIds,
      childCategory: childCategory ?? this.childCategory,
      categoryName: categoryName ?? this.categoryName,
      spicy: spicy ?? this.spicy,
      image: image ?? this.image,
      disountPercent: disountPercent ?? this.disountPercent,
      discountPrice: discountPrice ?? this.discountPrice,
      addOnNames: addOnNames ?? this.addOnNames,
      addOnPrices: addOnPrices ?? this.addOnPrices,
      cartKey: cartKey ?? this.cartKey,
      categoryIds: categoryIds ?? this.categoryIds,
      spicyLevel:  spicyLevel ?? this.spicyLevel,
    );
  }
}

