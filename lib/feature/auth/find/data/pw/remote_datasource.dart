import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/find/data/pw/model.dart';

class FindPasswordRemoteDataSource {
  final http.Client client;

  FindPasswordRemoteDataSource(this.client);

  Future<void> changePassword(PasswordChangeInfo passwordInfo) async {
    final response = await http.put(
      Uri.parse('${API.hostConnect}/members/password'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: utf8.encode(jsonEncode(passwordInfo.toJson())),
    );

    if (response.statusCode != 200) {
      throw Exception('비밀번호 변경에 실패했습니다. 다시 시도해주세요.');
    }
  }
}
