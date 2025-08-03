import 'package:ormee_app/feature/mypage/info/data/model.dart';

abstract class StudentInfoState {}

class StudentInfoInitial extends StudentInfoState {}

class StudentInfoLoading extends StudentInfoState {}

class StudentInfoLoaded extends StudentInfoState {
  final StudentInfoModel student;

  StudentInfoLoaded(this.student);
}

class StudentInfoUpdating extends StudentInfoState {}

class StudentInfoUpdateSuccess extends StudentInfoState {}

class StudentInfoError extends StudentInfoState {
  final String message;

  StudentInfoError(this.message);
}

class PasswordVerifying extends StudentInfoState {}

class PasswordVerified extends StudentInfoState {}

class PasswordVerifyFailed extends StudentInfoState {
  final String message;

  PasswordVerifyFailed(this.message);
}