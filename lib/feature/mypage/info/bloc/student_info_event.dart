import 'package:ormee_app/feature/mypage/info/data/model.dart';

abstract class StudentInfoEvent {}

class FetchStudentInfo extends StudentInfoEvent {}

class UpdateStudentInfo extends StudentInfoEvent {
  final StudentInfoModel student;

  UpdateStudentInfo(this.student);
}