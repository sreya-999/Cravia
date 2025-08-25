import 'package:flutter/foundation.dart';

import 'category_models.dart';

class Item {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final String? price;
  final String? time;
  final String image;
  final String createdAt;
  final String updatedAt;
  final CategoryModel? category;
  final List<ChildCategory> childCategory;

  Item({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    this.price,
    this.time,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    required this.childCategory,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      time: json['preparing_time'] ?? '',
      price: json['price']?.toString(),
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      category:
      json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      childCategory: (json['childCategory'] as List<dynamic>?)
          ?.map((e) => ChildCategory.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class ChildCategory {
  final int id;
  final int categoryId;
  final int subCategoryId;
  final String name;
  final String description;
  final double price;
  final double takeAwayPrice;


  ChildCategory({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.takeAwayPrice,
  });

  factory ChildCategory.fromJson(Map<String, dynamic> json) {
    return ChildCategory(
      id: json['id'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] != null) ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      takeAwayPrice: (json['take_away_price'] != null) ? double.tryParse(json['take_away_price'].toString()) ?? 0.0 : 0.0,

    );
  }
}
