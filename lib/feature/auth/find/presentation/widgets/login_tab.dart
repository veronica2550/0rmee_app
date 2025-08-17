import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/auth/find/bloc/id/id_bloc.dart';
import 'package:ormee_app/feature/auth/find/bloc/id/id_event.dart';
import 'package:ormee_app/feature/auth/find/bloc/id/id_state.dart';
import 'package:ormee_app/feature/auth/find/data/id/model.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _phone1Controller = TextEditingController();
  final FocusNode _phone1FocusNode = FocusNode();
  final TextEditingController _phone2Controller = TextEditingController();
  final FocusNode _phone2FocusNode = FocusNode();
  final TextEditingController _phone3Controller = TextEditingController();
  final FocusNode _phone3FocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    _phone1Controller.dispose();
    _phone1FocusNode.dispose();
    _phone2Controller.dispose();
    _phone2FocusNode.dispose();
    _phone3Controller.dispose();
    _phone3FocusNode.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _phone1Controller.text.isNotEmpty &&
        _phone2Controller.text.isNotEmpty &&
        _phone3Controller.text.isNotEmpty;
  }

  void _onFindIdPressed() {
    if (!_isFormValid) return;

    final phoneNumber =
        '${_phone1Controller.text}-${_phone2Controller.text}-${_phone3Controller.text}';
    final userInfo = UserName(
      name: _nameController.text,
      phoneNumber: phoneNumber,
    );

    context.read<FindIdBloc>().add(FindIdSubmitted(userInfo));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocListener<FindIdBloc, FindIdState>(
        listener: (context, state) {
          if (state is FindIdSuccess) {
            context.push(
              '/find/login',
              extra: {'name': state.name, 'foundId': state.foundId},
            );
          } else if (state is FindIdFailure) {
            OrmeeToast.show(context, state.message, true);
          }
        },
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 51),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Body2SemiBoldNormal14(text: '이름'),
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
                const SizedBox(height: 12),
                const Body2SemiBoldNormal14(text: '연락처'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: OrmeeTextField(
                        controller: _phone1Controller,
                        focusNode: _phone1FocusNode,
                        textInputAction: TextInputAction.next,
                        onTextChanged: (text) => setState(() {}),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_phone2FocusNode);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 13,
                      child: Center(child: Label1Regular14(text: "-")),
                    ),
                    Expanded(
                      flex: 4,
                      child: OrmeeTextField(
                        controller: _phone2Controller,
                        focusNode: _phone2FocusNode,
                        textInputAction: TextInputAction.next,
                        onTextChanged: (text) => setState(() {}),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_phone3FocusNode);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 13,
                      child: Center(child: Label1Regular14(text: "-")),
                    ),
                    Expanded(
                      flex: 4,
                      child: OrmeeTextField(
                        controller: _phone3Controller,
                        focusNode: _phone3FocusNode,
                        textInputAction: TextInputAction.done,
                        onTextChanged: (text) => setState(() {}),
                        onFieldSubmitted: (_) {
                          if (_isFormValid) _onFindIdPressed();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomSheet: BlocBuilder<FindIdBloc, FindIdState>(
            builder: (context, state) {
              return OrmeeBottomSheet(
                text: state is FindIdLoading ? "조회 중..." : "아이디 찾기",
                isCheck: _isFormValid && state is! FindIdLoading,
                onTap: state is FindIdLoading ? null : _onFindIdPressed,
              );
            },
          ),
        ),
      ),
    );
  }
}
