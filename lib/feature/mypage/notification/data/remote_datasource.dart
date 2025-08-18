import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/mypage/notification/data/model.dart';

class NotificationSettingRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<NotificationSettingModel> fetchNotificationSetting() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      final response = await _dio.post(
        '/students/notifications/settings',
        data: {'deviceToken': token},
      );

      if (response.statusCode == 200 && response.data != null) {
        return NotificationSettingModel.fromJson(response.data);
      } else {
        throw '알림설정 데이터를 불러올 수 없습니다.';
      }
    } catch (e) {
      throw '알림설정 데이터를 불러오는 중 오류가 발생했습니다.';
    }
  }

  Future<NotificationSettingModel> updateNotificationSetting(
    NotificationSettingModel settings,
  ) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      final response = await _dio.put(
        '/students/notifications/settings',
        data: settings.copyWith(deviceToken: token).toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return NotificationSettingModel.fromJson(response.data);
      } else {
        throw '알림설정 데이터를 수정할 수 없어요.';
      }
    } catch (e) {
      throw '알림설정 데이터를 수정하는 중 오류가 발생했어요.';
    }
  }
}
