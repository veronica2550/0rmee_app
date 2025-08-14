import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/homework/create/data/model.dart';

class HomeworkCreateRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<void> postHomework(int homeworkId, HomeworkRequest request) async {
    try {
      final response = await _dio.post(
        '/students/homeworks/$homeworkId',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw '숙제를 등록할 수 없어요.';
      }
    } catch (e) {
      throw '숙제 등록 중 오류가 발생했어요.';
    }
  }
}
