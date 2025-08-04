import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_event.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_state.dart';
import 'package:ormee_app/feature/mypage/info/data/model.dart';
import 'package:ormee_app/feature/mypage/info/data/repository.dart';

class StudentInfoBloc extends Bloc<StudentInfoEvent, StudentInfoState> {
  final StudentInfoRepository repository;

  StudentInfoBloc(this.repository) : super(StudentInfoInitial()) {
    on<FetchStudentInfo>((event, emit) async {
      emit(StudentInfoLoading());
      try {
        final student = await repository.readStudentInfo();
        emit(StudentInfoLoaded(student));
      } catch (e) {
        emit(StudentInfoError('회원 정보를 불러오는 중 오류가 발생했어요.'));
      }
    });

    on<UpdateStudentInfo>((event, emit) async {
      if (state is! StudentInfoLoaded) return;
      final currentState = state as StudentInfoLoaded;
      try {
        await repository.updateStudentInfo(event.student);
        final updated = StudentInfoModel(
          name: event.student.name,
          username: currentState.student.username,
          phoneNumber: event.student.phoneNumber,
          email: event.student.email,
          password: null,
        );
        emit(StudentInfoLoaded(updated));
        emit(StudentInfoUpdateSuccess());
      } catch (e) {
        emit(StudentInfoError('회원 정보가 수정되지 않았어요.'));
        emit(currentState);
      }
    });

    on<VerifyPassword>((event, emit) async {
      emit(PasswordVerifying());
      try {
        final result = await repository.verifyPassword(event.password);
        if (result) {
          emit(PasswordVerified());
        } else {
          emit(PasswordVerifyFailed("비밀번호가 일치하지 않아요."));
        }
      } catch (e) {
        emit(PasswordVerifyFailed("비밀번호 확인 중 오류가 발생했습니다."));
      }
    });
  }
}