import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/mypage/version/data/model.dart';

class VersionRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<String> fetchLatestVersion() async {
    final response = await _dio.get('/students/version');

    if (response.statusCode == 200) {
      final responseData = VersionResponse.fromJson(response.data);
      if (responseData.status == 'success') {
        return responseData.data;
      } else {
        throw Exception('버전 정보를 불러오지 못했습니다.');
      }
    } else {
      throw Exception('버전 정보를 불러오지 못했습니다.');
    }
  }
}
