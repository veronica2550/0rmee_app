import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ormee_app/core/constants/api.dart';

class ApiService {
  static const String _baseUrl = API.hostConnect;

  /// 아이디 중복 체크
  /// [id] : 체크할 아이디 문자열
  /// true: 중복됨 / false: 사용 가능
  static Future<bool> checkIdDuplication(String id) async {
    final url = Uri.parse('$_baseUrl/students/username');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': id}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // 서버에서 {"duplicated": true} 형태로 응답한다고 가정
      return data['data'] == true;
    } else if (response.statusCode == 409) {
      return false;
    } else {
      throw Exception(
        'Failed to check ID duplication. Code: ${response.statusCode}',
      );
    }
  }

  /// 회원가입
  /// [username] : 사용자 아이디
  /// [password] : 비밀번호
  /// [name] : 사용자 이름
  /// [phoneNumber] : 전화번호 (010-1234-5678 형식)
  static Future<void> signUp({
    required String username,
    required String password,
    required String name,
    required String phoneNumber,
    // 약관 동의 상태 (추후 API에 추가 예정)
    // bool? terms1,
    // bool? terms2,
    // bool? terms3,
  }) async {
    final url = Uri.parse('$_baseUrl/students/signup');

    final requestBody = {
      'username': username,
      'password': password,
      'phoneNumber': phoneNumber,
      'name': name,
      // 약관 동의 상태 (추후 API에 추가 예정)
      // 'termsOfService': terms1,
      // 'privacyPolicy': terms2,
      // 'marketingConsent': terms3,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // 회원가입 성공
      final responseData = jsonDecode(response.body);
      print('회원가입 성공: $responseData');
      return;
    } else if (response.statusCode == 409) {
      // 중복된 사용자
      throw Exception('이미 존재하는 사용자입니다.');
    } else if (response.statusCode == 400) {
      // 잘못된 요청
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['data'] ?? '잘못된 요청입니다.';
      throw Exception(errorMessage);
    } else {
      // 기타 오류
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['data'];
      print(errorMessage);
      throw Exception('회원가입에 실패했습니다. (코드: ${response.statusCode})');
    }
  }
}
