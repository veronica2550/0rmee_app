import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/question/create/data/model.dart';

class QuestionCreateRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<void> postQuestion(int lectureId, QuestionRequest request) async {
    try {
      final res = await _dio.post(
        '/students/lectures/$lectureId/questions',
        data: request.toJson(),
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw '질문을 등록할 수 없습니다.';
      }
    } catch (_) {
      throw '질문 등록 중 오류가 발생했습니다.';
    }
  }
}
