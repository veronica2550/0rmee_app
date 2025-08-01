import 'package:ormee_app/feature/mypage/info/data/model.dart';
import 'package:ormee_app/feature/mypage/info/data/remote_datasource.dart';

class StudentInfoRepository {
  final StudentInfoRemoteDataSource remoteDataSource;

  StudentInfoRepository(this.remoteDataSource);

  Future<StudentInfoModel> readStudentInfo() {
    return remoteDataSource.fetchStudentInfo();
  }

  Future<void> updateStudentInfo(StudentInfoModel student) async {
    await remoteDataSource.updateStudentInfo(student);
  }
}