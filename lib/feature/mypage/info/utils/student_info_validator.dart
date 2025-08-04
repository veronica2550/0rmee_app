class StudentInfoValidator {
  static String? validateEmail(String local, String provider) {
    final email = "$local@$provider";
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(email)) {
      return "올바른 이메일 형식을 입력해 주세요.";
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return null;

    final regex =
    RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,16}$');
    if (!regex.hasMatch(password)) {
      return "비밀번호는 영문, 숫자, 특수문자 포함 8~16자여야 해요.";
    }
    return "사용 가능한 비밀번호예요.";
  }

  static String? validatePasswordConfirm(String password, String confirm) {
    if (password.isEmpty && confirm.isEmpty) return null;

    if (password != confirm) {
      return "비밀번호가 일치하지 않아요.";
    }
    return "비밀번호 일치";
  }
}