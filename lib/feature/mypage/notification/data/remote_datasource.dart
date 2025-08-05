import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/mypage/notification/data/model.dart';

class NotificationSettingRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<NotificationSettingModel> fetchStudentInfo() async {
    try {
      final response = await _dio.get('/students/notifications/settings');

      if (response.statusCode == 200 && response.data != null) {
        return NotificationSettingModel.fromJson(response.data);
      } else {
        throw Exception('알림설정 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      throw Exception('알림설정 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }

  Future<NotificationSettingModel> updateStudentInfo(NotificationSettingModel settings) async {
    try {
      final response = await _dio.put('/students/notifications/settings', data: settings.toJson());

      if (response.statusCode == 200 && response.data != null) {
        return NotificationSettingModel.fromJson(response.data);
      } else {
        throw Exception('알림설정 데이터를 수정할 수 없습니다.');
      }
    } catch (e) {
      throw Exception('알림설정 데이터를 수정하는 중 오류가 발생했습니다.');
    }
  }
}