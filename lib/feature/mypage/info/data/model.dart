class StudentInfoModel {
  final String name;
  final String username;
  final String phoneNumber;
  final String email;
  final String? password;

  StudentInfoModel({
    required this.name,
    required this.username,
    required this.phoneNumber,
    required this.email,
    this.password,
  });

  factory StudentInfoModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return StudentInfoModel(
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (name.isNotEmpty) json['name'] = name;
    if (phoneNumber.isNotEmpty) json['phoneNumber'] = phoneNumber;
    if (email.isNotEmpty) json['email'] = email;
    if (password != null && password!.isNotEmpty) {
      json['password'] = password;
    }

    return json;
  }
}