import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/find/data/id/model.dart';

class FindIdRemoteDataSource {
  final http.Client client;

  FindIdRemoteDataSource(this.client);

  Future<String> findId(UserName username) async {
    final response = await http.post(
      Uri.parse('${API.hostConnect}/members/username'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: utf8.encode(
        jsonEncode({
          'name': username.name,
          'phoneNumber': username.phoneNumber,
        }),
      ),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      final originalId = responseData['data'] ?? 'error';

      // 뒤 세 글자를 * 로 마스킹
      if (originalId.length > 3) {
        return originalId.substring(0, originalId.length - 3) + '***';
      } else {
        // ID가 3글자 이하인 경우 모두 *로 표시
        return '*' * originalId.length;
      }
    } else {
      throw Exception('입력하신 정보와 일치하는 아이디가 없어요.');
    }
  }
}
