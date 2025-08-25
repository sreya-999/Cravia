class OtpResponse {
  final String message;
  final int otp;
  final int? userId; // 👈 new optional field

  OtpResponse({
    required this.message,
    required this.otp,
    this.userId, // optional
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message'] ?? '',
      otp: json['otp'] ?? 0,
      userId: json['id'], // 👈 map userId from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'otp': otp,
      'userId': userId,
    };
  }
}
