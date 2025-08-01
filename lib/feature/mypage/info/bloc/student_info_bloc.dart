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
        emit(StudentInfoError('학생 정보를 불러오는 중 오류: ${e.toString()}'));
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
        emit(StudentInfoError('학생 정보 수정 실패: ${e.toString()}'));
        emit(currentState);
      }
    });
  }
}