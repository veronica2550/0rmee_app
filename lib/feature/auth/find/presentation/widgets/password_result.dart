import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class PasswordResult extends StatefulWidget {
  final String username;
  final String phoneNumber;
  const PasswordResult({
    super.key,
    required this.username,
    required this.phoneNumber,
  });

  @override
  State<PasswordResult> createState() => _PasswordResultState();
}

class _PasswordResultState extends State<PasswordResult> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _phone1Controller = TextEditingController();
  final FocusNode _phone1FocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _phone1Controller.dispose();
    _phone1FocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _nameController.text.isNotEmpty && _phone1Controller.text.isNotEmpty;
  }

  void _onFindIdPressed() {
    if (!_isFormValid) return;

    // final pwInfo = PWInfo(
    //   name: _nameController.text,
    //   phoneNumber: _phone1Controller.text,
    // );
    context.go('/login');
    OrmeeToast.show(context, '비밀번호를 성공적으로 변경했어요', false);
  }

  // bool get isPassword {
  //   return this == .password ||
  //       this == .passwordConfirm;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              controller: _nameController,
              focusNode: _nameFocusNode,
              textInputAction: TextInputAction.next,
              onTextChanged: (text) => setState(() {}),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_phone1FocusNode);
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
              child: Label2Regular12(
                text: '영문, 숫자, 특수문자 2종 이상 포함 8~16자',
                color: OrmeeColor.gray[60],
              ),
            ),
            const SizedBox(height: 12),
            const Body2SemiBoldNormal14(text: '비밀번호 확인'),
            const SizedBox(height: 4),
            OrmeeTextField(
              controller: _phone1Controller,
              focusNode: _phone1FocusNode,
              textInputAction: TextInputAction.next,
              onTextChanged: (text) => setState(() {}),
              onFieldSubmitted: (_) {
                if (_isFormValid) _onFindIdPressed();
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
              child: Label2Regular12(
                text: '영문, 숫자, 특수문자 2종 이상 포함 8~16자',
                color: OrmeeColor.gray[60],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: OrmeeBottomSheet(
        text: "비밀번호 변경",
        isCheck: _isFormValid,
        onTap: _onFindIdPressed,
      ),
    );
  }
}
