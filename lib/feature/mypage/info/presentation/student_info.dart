import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_bloc.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_event.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_state.dart';
import 'package:ormee_app/feature/mypage/info/data/remote_datasource.dart';
import 'package:ormee_app/feature/mypage/info/data/repository.dart';
import 'package:ormee_app/feature/mypage/info/presentation/widgets/password_modal.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  bool _isVerified = false;

  void _showPasswordModal(BuildContext context) {
    Future.microtask(() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return PasswordModal(
            titleText: "회원정보 수정",
            onConfirm: (password) {
              context.read<StudentInfoBloc>().add(VerifyPassword(password));
            },
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StudentInfoBloc(StudentInfoRepository(StudentInfoRemoteDataSource())),
      child: BlocConsumer<StudentInfoBloc, StudentInfoState>(
        listener: (context, state) {
          if (state is PasswordVerifyFailed) {
            OrmeeToast.show(context, state.message);
          } else if (state is PasswordVerified) {
            setState(() {
              _isVerified = true;
            });
            context.read<StudentInfoBloc>().add(FetchStudentInfo());
            context.pop();
          } else if (state is StudentInfoError) {
            OrmeeToast.show(context, state.message);
          } else if (state is StudentInfoUpdateSuccess) {
            OrmeeToast.show(context, "회원 정보가 수정되었습니다.");
            context.pop();
          }
        },
        builder: (context, state) {
          if (!_isVerified) {
            _showPasswordModal(context);
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is StudentInfoLoaded) {
            final student = state.student;
            return Scaffold(
              appBar: OrmeeAppBar(
                title: '회원정보 수정',
                isLecture: false,
                isImage: false,
                isDetail: false,
                isPosting: false,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("이름: ${student.name}"),
                      Text("아이디: ${student.username}"),
                      Text("이메일: ${student.email}"),
                      Text("전화번호: ${student.phoneNumber}"),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: OrmeeBottomSheet(
                text: '수정하기',
                isCheck: false,
              ),
            );
          } else if (state is StudentInfoLoading ||
              state is PasswordVerifying) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return const Scaffold(
              body: Center(child: Text("회원 정보를 불러오지 못했습니다.")),
            );
          }
        },
      ),
    );
  }
}
