class CategoryModel {
  final int id;
  final String name;
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0, // type casting to int
      name: json['name'] != null ? json['name'].toString() : '',
      image: json['image'] != null ? json['image'].toString() : '',
    );
  }
}
