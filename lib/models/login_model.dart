class VendorLoginModel {
  final String token;
  final VendorUser user;

  VendorLoginModel({required this.token, required this.user});

  factory VendorLoginModel.fromJson(Map<String, dynamic> json) {
    return VendorLoginModel(
      token: json['token'],
      user: VendorUser.fromJson(json['user']),
    );
  }
}

class VendorUser {
  final int id;
  final String name;
  final String email;
  final String contactNumber;
  final String address;
  final String state;
  final String city;
  final String? zipCode;
  final String profileImage;
  final int status;
  final int role;
  final String roleName;
  final String createdAt;

  VendorUser({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.address,
    required this.state,
    required this.city,
    this.zipCode,
    required this.profileImage,
    required this.status,
    required this.role,
    required this.roleName,
    required this.createdAt,
  });

  factory VendorUser.fromJson(Map<String, dynamic> json) {
    return VendorUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      contactNumber: json['contact_number'],
      address: json['address'],
      state: json['state'],
      city: json['city'],
      zipCode: json['zip_code'],
      profileImage: json['profile_image'],
      status: json['status'],
      role: json['role'],
      roleName: json['role_name'],
      createdAt: json['created_at'],
    );
  }
}
