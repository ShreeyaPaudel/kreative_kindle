class AuthApiModel {
  final String? id;

  // Signup fields (based on your UI)
  final String fullName;
  final String email;
  final String address;
  final String password;
  final String role; // parent / instructor / admin

  // Response
  final String? token;
  final String? message;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.address,
    required this.password,
    required this.role,
    this.token,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "address": address,
      "password": password,
      "role": role,
    };
  }

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: (json["_id"] ?? json["id"])?.toString(),

      // ✅ NOTE: no ?.toString() here
      fullName: (json["fullName"] ?? json["name"] ?? "").toString(),
      email: (json["email"] ?? "").toString(),
      address: (json["address"] ?? "").toString(),

      // ✅ never store password from response
      password: "",

      role: (json["role"] ?? "parent").toString(),
      token: json["token"]?.toString(),
      message: json["message"]?.toString(),
    );
  }
}
