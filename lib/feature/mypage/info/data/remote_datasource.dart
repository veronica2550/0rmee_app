import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/mypage/info/data/model.dart';

class StudentInfoRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<StudentInfoModel> fetchStudentInfo() async {
    try {
      final response = await _dio.get('/students/info');

      if (response.statusCode == 200 && response.data != null) {
        return StudentInfoModel.fromJson(response.data);
      } else {
        throw Exception('학생 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      throw Exception('학생 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }

  Future<StudentInfoModel> updateStudentInfo(StudentInfoModel student) async {
    try {
      final response = await _dio.put('/students/info', data: student.toJson());

      if (response.statusCode == 200 && response.data != null) {
        return StudentInfoModel.fromJson(response.data);
      } else {
        throw Exception('학생 데이터를 수정할 수 없습니다.');
      }
    } catch (e) {
      throw Exception('학생 데이터를 수정하는 중 오류가 발생했습니다.');
    }
  }

  Future<bool> verifyPassword(String password) async {
    try {
      final response = await _dio.post('/students/password', data: {"password": password});

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 403) {
        return false;
      }
      rethrow;
    }
  }
}
