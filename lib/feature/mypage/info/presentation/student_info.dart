import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_bloc.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_event.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_state.dart';
import 'package:ormee_app/feature/mypage/info/data/model.dart';
import 'package:ormee_app/feature/mypage/info/data/remote_datasource.dart';
import 'package:ormee_app/feature/mypage/info/data/repository.dart';
import 'package:ormee_app/feature/mypage/info/presentation/widgets/password_modal.dart';
import 'package:ormee_app/feature/mypage/info/presentation/widgets/phone_field.dart';
import 'package:ormee_app/feature/mypage/info/utils/student_info_validator.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  bool _isVerified = false;
  bool _isModified = false;
  bool _isPasswordDirty = false;
  bool _isPasswordConfirmDirty = false;
  StudentInfoModel? _originalStudent;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _emailLocalController = TextEditingController();
  final TextEditingController _emailProviderController =
      TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();
  final FocusNode _emailLocalFocus = FocusNode();
  final FocusNode _emailProviderFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _emailLocalController.dispose();
    _emailProviderController.dispose();
    _nameFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmFocus.dispose();
    _emailLocalFocus.dispose();
    _emailProviderFocus.dispose();
    super.dispose();
  }

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

  void _setEmail(String email) {
    final parts = email.split('@');
    if (parts.length == 2) {
      _emailLocalController.text = parts[0];
      _emailProviderController.text = parts[1];
    }
  }

  void _checkModified() {
    if (_originalStudent == null) return;

    final newName = _nameController.text.trim();
    final newPassword = _passwordController.text.trim();
    final email =
        "${_emailLocalController.text.trim()}@${_emailProviderController.text.trim()}";

    final modified =
        newName != _originalStudent!.name ||
        email != _originalStudent!.email ||
        newPassword.isNotEmpty;

    if (modified != _isModified) {
      setState(() {
        _isModified = modified;
      });
    }
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
          } else if (state is StudentInfoLoaded) {
            _originalStudent = state.student;
            _nameController.text = state.student.name;
            _setEmail(state.student.email);
          } else if (state is StudentInfoUpdateSuccess) {
            OrmeeToast.show(context, "회원 정보가 수정되었어요.");
            context.pop();
          } else if (state is StudentInfoError) {
            OrmeeToast.show(context, state.message);
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
            final emailError = StudentInfoValidator.validateEmail(
              _emailLocalController.text,
              _emailProviderController.text,
            );
            final pwError = StudentInfoValidator.validatePassword(
              _passwordController.text,
            );
            final pwConfirmError = StudentInfoValidator.validatePasswordConfirm(
              _passwordController.text,
              _passwordConfirmController.text,
            );

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                appBar: OrmeeAppBar(
                  title: '회원정보 수정',
                  isLecture: false,
                  isImage: false,
                  isDetail: false,
                  isPosting: false,
                ),

                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Body2SemiBoldNormal14(
                        text: "이름",
                        color: OrmeeColor.gray[90],
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: OrmeeColor.gray[20]!),
                          color: OrmeeColor.gray[10],
                        ),
                        child: Label1Regular14(
                          text: student.name,
                          color: OrmeeColor.gray[50],
                        ),
                      ),
                      const SizedBox(height: 30),

                      Body2SemiBoldNormal14(
                        text: "아이디",
                        color: OrmeeColor.gray[90],
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: OrmeeColor.gray[20]!),
                          color: OrmeeColor.gray[10], // 회색 배경
                        ),
                        child: Label1Regular14(
                          text: student.username,
                          color: OrmeeColor.gray[50],
                        ),
                      ),

                      const SizedBox(height: 30),
                      Body2SemiBoldNormal14(
                        text: "비밀번호",
                        color: OrmeeColor.gray[90],
                      ),
                      SizedBox(height: 4),
                      OrmeeTextField(
                        hintText: "********",
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        onTextChanged: (_) {
                          if (!_isPasswordDirty)
                            setState(() => _isPasswordDirty = true);
                          _checkModified();
                          setState(() {});
                        },
                        errorText:
                            _isPasswordDirty && pwError != "사용 가능한 비밀번호예요."
                            ? pwError
                            : null,
                        onFieldSubmitted: (_) => FocusScope.of(
                          context,
                        ).requestFocus(_passwordConfirmFocus),
                      ),
                      if (_isPasswordDirty && pwError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Label2Regular12(
                            text: pwError,
                            color: (pwError == "사용 가능한 비밀번호예요.")
                                ? OrmeeColor.purple[50]
                                : OrmeeColor.systemError,
                          ),
                        ),
                      const SizedBox(height: 30),

                      Body2SemiBoldNormal14(
                        text: "비밀번호 확인",
                        color: OrmeeColor.gray[90],
                      ),
                      SizedBox(height: 4),
                      OrmeeTextField(
                        hintText: "********",
                        controller: _passwordConfirmController,
                        focusNode: _passwordConfirmFocus,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        onTextChanged: (_) {
                          if (!_isPasswordConfirmDirty) {
                            setState(() => _isPasswordConfirmDirty = true);
                          }
                          _checkModified();
                          setState(() {});
                        },
                        errorText:
                            _isPasswordConfirmDirty && pwConfirmError != "비밀번호 일치"
                            ? pwError
                            : null,
                        onFieldSubmitted: (_) => FocusScope.of(
                          context,
                        ).requestFocus(_emailLocalFocus),
                      ),
                      if (_isPasswordConfirmDirty && pwConfirmError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Label2Regular12(
                            text: pwConfirmError,
                            color: (pwConfirmError == "비밀번호 일치")
                                ? OrmeeColor.purple[50]
                                : OrmeeColor.systemError,
                          ),
                        ),
                      const SizedBox(height: 30),

                      Body2SemiBoldNormal14(
                        text: "연락처",
                        color: OrmeeColor.gray[90],
                      ),
                      SizedBox(height: 4),
                      PhoneField(phoneNumber: student.phoneNumber),
                      const SizedBox(height: 30),

                      Body2SemiBoldNormal14(
                        text: "이메일",
                        color: OrmeeColor.gray[90],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: OrmeeTextField(
                              controller: _emailLocalController,
                              focusNode: _emailLocalFocus,
                              textInputAction: TextInputAction.next,
                              errorText: emailError,
                              onTextChanged: (_) {
                                _checkModified();
                                setState(() {});
                              },
                              onFieldSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_emailProviderFocus),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text("@", style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OrmeeTextField(
                              controller: _emailProviderController,
                              focusNode: _emailProviderFocus,
                              errorText: emailError,
                              textInputAction: TextInputAction.done,
                              onTextChanged: (_) {
                                _checkModified();
                                setState(() {});
                              },
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).unfocus(),
                            ),
                          ),
                        ],
                      ),
                      if (emailError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Label2Regular12(
                            text: emailError,
                            color: OrmeeColor.systemError,
                          ),
                        ),
                      const SizedBox(height: 72),
                    ],
                  ),
                ),
                bottomNavigationBar: OrmeeBottomSheet(
                  text: '수정하기',
                  isCheck: _isModified &&
                      emailError == null &&
                      (!_isPasswordDirty || pwError == "사용 가능한 비밀번호예요.") &&
                      (!_isPasswordConfirmDirty || pwConfirmError == "비밀번호 일치"),
                  onTap: _isModified &&
                      emailError == null &&
                      (!_isPasswordDirty || pwError == "사용 가능한 비밀번호예요.") &&
                      (!_isPasswordConfirmDirty || pwConfirmError == "비밀번호 일치")
                      ? () {
                    final newPassword = (_isPasswordDirty)
                        ? _passwordController.text.trim()
                        : null;

                    final email =
                        "${_emailLocalController.text.trim()}@${_emailProviderController.text.trim()}";

                    context.read<StudentInfoBloc>().add(
                      UpdateStudentInfo(
                        student.copyWith(
                          name: _nameController.text.trim(),
                          email: email,
                          password: newPassword,
                        ),
                      ),
                    );
                  }
                      : null,
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
