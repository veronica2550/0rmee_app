import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/auth/find/bloc/pw/pw_bloc.dart';
import 'package:ormee_app/feature/auth/find/bloc/pw/pw_event.dart';
import 'package:ormee_app/feature/auth/find/bloc/pw/pw_state.dart';
import 'package:ormee_app/feature/auth/find/data/pw/model.dart';
import 'package:ormee_app/feature/auth/find/presentation/widgets/password_validator.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class PasswordChangeScreen extends StatefulWidget {
  final String username;
  final String phoneNumber;

  const PasswordChangeScreen({
    super.key,
    required this.username,
    required this.phoneNumber,
  });

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _passwordError == null &&
        _confirmPasswordError == null &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  void _validatePassword() {
    setState(() {
      _passwordError = PasswordValidator.getPasswordError(
        _passwordController.text,
      );
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      _confirmPasswordError = PasswordValidator.getPasswordConfirmError(
        _passwordController.text,
        _confirmPasswordController.text,
      );
    });
  }

  void _onChangePasswordPressed() {
    if (!_isFormValid) return;

    final passwordInfo = PasswordChangeInfo(
      username: widget.username,
      phoneNumber: widget.phoneNumber,
      newPassword: _passwordController.text,
    );

    context.read<FindPasswordBloc>().add(PasswordChangeRequested(passwordInfo));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocListener<FindPasswordBloc, FindPasswordState>(
        listener: (context, state) {
          if (state is FindPasswordSuccess) {
            context.go('/login');
            OrmeeToast.show(context, '비밀번호를 성공적으로 변경했어요', false);
          } else if (state is FindPasswordFailure) {
            OrmeeToast.show(context, state.message, true);
          }
        },
        child: Scaffold(
          appBar: const OrmeeAppBar(
            isLecture: false,
            isImage: false,
            isDetail: false,
            isPosting: false,
            title: "아이디/비밀번호 찾기",
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 51),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Body2SemiBoldNormal14(text: '새 비밀번호'),
                const SizedBox(height: 4),
                OrmeeTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  textInputAction: TextInputAction.next,
                  isPassword: true,
                  onTextChanged: (text) {
                    _validatePassword();
                    if (_confirmPasswordController.text.isNotEmpty) {
                      _validateConfirmPassword();
                    }
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(
                      context,
                    ).requestFocus(_confirmPasswordFocusNode);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
                  child: Label2Regular12(
                    text: _passwordError ?? '영문, 숫자, 특수문자 2종 이상 포함 8~16자',
                    color: _passwordError != null
                        ? OrmeeColor.systemError
                        : OrmeeColor.gray[60],
                  ),
                ),
                const SizedBox(height: 12),
                const Body2SemiBoldNormal14(text: '비밀번호 확인'),
                const SizedBox(height: 4),
                OrmeeTextField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  textInputAction: TextInputAction.done,
                  isPassword: true,
                  onTextChanged: (text) => _validateConfirmPassword(),
                  onFieldSubmitted: (_) {
                    if (_isFormValid) _onChangePasswordPressed();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
                  child: Label2Regular12(
                    text: _confirmPasswordError ?? '',
                    color: _confirmPasswordError != null
                        ? OrmeeColor.systemError
                        : OrmeeColor.purple[50],
                  ),
                ),
              ],
            ),
          ),
          bottomSheet: BlocBuilder<FindPasswordBloc, FindPasswordState>(
            builder: (context, state) {
              return OrmeeBottomSheet(
                text: state is FindPasswordLoading ? "변경 중..." : "비밀번호 변경",
                isCheck: _isFormValid && state is! FindPasswordLoading,
                onTap: state is FindPasswordLoading
                    ? null
                    : _onChangePasswordPressed,
              );
            },
          ),
        ),
      ),
    );
  }
}
