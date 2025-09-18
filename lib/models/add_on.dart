class AddOnModel {
  final int id;
  final String name;
  final double price;
  final String? description;

  AddOnModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  factory AddOnModel.fromJson(Map<String, dynamic> json) {
    return AddOnModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name'] ?? json['title'] ?? '',
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse('${json['price']}') ?? 0.0,
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'description': description,
  };
}

final List<Map<String, dynamic>> sampleAddOnJson = [
  {
    "id": 1,
    "name": "Extra Cheese",
    "price": 50.0,
    "description": "Add extra cheese to your pizza for a delicious taste."
  },
  {
    "id": 2,
    "name": "Garlic Bread",
    "price": 80.0,
    "description": "Freshly baked garlic bread with herbs."
  },
  {
    "id": 3,
    "name": "Cold Drink",
    "price": 40.0,
    "description": "A chilled soft drink to go with your meal."
  },
  {
    "id": 4,
    "name": "Chocolate Lava Cake",
    "price": 120.0,
    "description": "Warm chocolate cake with a molten center."
  },
];
final addOns = sampleAddOnJson.map((json) => AddOnModel.fromJson(json)).toList();

