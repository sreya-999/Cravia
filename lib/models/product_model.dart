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
  final bool? isCombo;// <-- Add this

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
     this.categoryId,
    required this.price,
    this.isCombo// <-- Add this
  });


}

class ComboProductModel {
  final int id;
  final String name;
  final List<String> images; // Changed from single image to list
  final int price;
  final int categoryId;
  final bool? isCombo;

  ComboProductModel({
    required this.id,
    required this.name,
    required this.images,
    required this.price,
    required this.categoryId,
    this.isCombo
  });
}

class CartItemModel {
  final int id;
  final String name;
  final List<String> images;
  final int? categoryId;
  final double price;
  int quantity;
  final int? subCategoryId;   // 👈 new
  final String? childCategoryId;  // 👈 new
  final String? childCategoryName; // 👈 new// Mutable for cart updates
  final bool? isCombo;
   double? takeAwayPrice;// To differentiate between normal and combo products

  CartItemModel({
    required this.id,
    required this.name,
    required this.images,
    this.categoryId,
    this.subCategoryId,
    required this.price,
    this.quantity = 1,
    this.childCategoryId,   // 👈 optional
    this.childCategoryName, // 👈 optional
    this.isCombo,
     this.takeAwayPrice,
  });

  // Factory constructor from ProductModel
  factory CartItemModel.fromProduct(ProductModel product, {int quantity = 1}) {
    return CartItemModel(
      id: product.id,
      name: product.name,
      images: [product.image], // Single image converted to list
      categoryId: product.categoryId,
      price: product.price,
      quantity: quantity,
      isCombo: product.isCombo,
    );
  }
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
      'take_away_price':takeAwayPrice
    };
  }
  // Factory constructor from ComboProductModel
  factory CartItemModel.fromCombo(ComboProductModel combo, {int quantity = 1}) {
    return CartItemModel(
      id: combo.id,
      name: combo.name,
      images: combo.images, // Already a list
      categoryId: combo.categoryId,
      price: combo.price.toDouble(),
      quantity: quantity,
      isCombo: combo.isCombo,
    );
  }

  double get totalPrice => price * quantity;
}
