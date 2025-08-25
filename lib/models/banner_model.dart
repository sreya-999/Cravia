class BannerModel {
  final int id;

  final String image;

  BannerModel({
    required this.id,

    required this.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
    };
  }
}
