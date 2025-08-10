import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';

class AttachmentRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<int> uploadAttachment({
    required File file,
    required String type,
    // 타입 종류: QUIZ, NOTICE, HOMEWORK, HOMEWORK_SUBMIT, QUESTION, ANSWER, TEACHER_IMAGE
  }) async {
    try {
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'type': type,
      });

      final response = await _dio.post('/attachment', data: formData);

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data['data']; // 파일 ID 반환
      } else {
        throw Exception('파일 업로드 실패: ${response.data}');
      }
    } catch (e) {
      print('Attachment upload error: $e');
      rethrow;
    }
  }
}