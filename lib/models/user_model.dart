class UserModel {
  final String message;
  final int? userId;

  UserModel({
    required this.message,
    this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    int? id;

    if (user != null && user is Map<String, dynamic>) {
      id = user['id'] is int ? user['id'] : int.tryParse(user['id'].toString());
    }

    return UserModel(
      message: json['message'] ?? '',
      userId: id,
    );
  }
}
