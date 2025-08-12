class PasswordValidator {
  static bool isValidPassword(String password) {
    if (password.length < 8 || password.length > 16) {
      return false;
    }

    int typeCount = 0;
    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasLetter) typeCount++;
    if (hasDigit) typeCount++;
    if (hasSpecial) typeCount++;

    return typeCount >= 2;
  }

  static String? getPasswordError(String password) {
    if (password.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (password.length < 8) {
      return '비밀번호는 8자 이상이어야 합니다.';
    }
    if (password.length > 16) {
      return '비밀번호는 16자 이하여야 합니다.';
    }
    if (!isValidPassword(password)) {
      return '영문, 숫자, 특수문자 중 2종 이상을 포함해야 합니다.';
    }
    return null;
  }

  static String? getPasswordConfirmError(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) {
      return '비밀번호 확인을 입력해주세요.';
    }
    if (password != confirmPassword) {
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }
}
