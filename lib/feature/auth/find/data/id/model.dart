class UserName {
  final String name;
  final String phoneNumber;

  UserName({required this.name, required this.phoneNumber});

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(name: json['name'], phoneNumber: json['phoneNumber']);
  }
}
