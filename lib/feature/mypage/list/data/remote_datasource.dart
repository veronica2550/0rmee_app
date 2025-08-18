import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ormee_app/core/network/api_client.dart';

class MyPageProfileRemoteDatasource {
  final Dio _dio = ApiClient.instance.dio;

  Future<String> fetchProfile() async {
    try {
      final response = await _dio.get('/students/profile');

      if (response.statusCode == 200 && response.data != null) {
        return response.data['data'] as String;
      } else {
        throw '프로필 데이터를 불러올 수 없어요.';
      }
    } catch (e) {
      print(e.toString());
      throw '프로필 데이터를 불러오는 중 오류가 발생했어요.';
    }
  }

  Future<void> logOut() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      final response = await _dio.post('/students/logout', data: {'deviceToken' : token});
      if (response.statusCode == 200 && response.data != null) {
      } else {
        throw '로그아웃에 실패했어요.';
      }
    } catch (e) {
      throw '로그아웃 과정 중 오류가 발생했어요.';
    }
  }
}
