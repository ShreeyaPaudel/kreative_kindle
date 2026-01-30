class AuthApiModel {
  final String? fullName; // UI uses fullName
  final String email;
  final String? address;
  final String password;
  final String? role;

  // response fields (optional, depends on your backend)
  final String? token;
  final String? message;

  const AuthApiModel({
    this.fullName,
    required this.email,
    this.address,
    required this.password,
    this.role,
    this.token,
    this.message,
  });

  Map<String, dynamic> toRegisterJson() {
    return {
      "username": fullName ?? "",
      "email": email,
      "password": password,
      if (address != null) "address": address,
    };
  }

  Map<String, dynamic> toLoginJson() {
    return {"email": email, "password": password};
  }

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      fullName: (json["username"] ?? json["fullName"])?.toString(),
      email: (json["email"] ?? "").toString(),
      address: json["address"]?.toString(),
      password: "", // never store password from response
      role: json["role"]?.toString(),
      token: json["token"]?.toString(),
      message: json["message"]?.toString(),
    );
  }
}
