class PasswordChangeInfo {
  final String username;
  final String phoneNumber;
  final String newPassword;

  PasswordChangeInfo({
    required this.username,
    required this.phoneNumber,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phoneNumber': phoneNumber,
      'newPassword': newPassword,
    };
  }
}
