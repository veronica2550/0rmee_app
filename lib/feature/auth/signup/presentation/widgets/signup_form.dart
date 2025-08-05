import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/auth/signup/bloc/signup_bloc.dart';
import 'package:ormee_app/feature/auth/signup/data/model/signup_field_type.dart';
import 'package:ormee_app/feature/auth/signup/presentation/widgets/info_text.dart';
import 'package:ormee_app/feature/auth/signup/presentation/widgets/signup_field_controller.dart';
import 'package:ormee_app/feature/auth/signup/presentation/widgets/basic_field.dart';
import 'package:ormee_app/feature/auth/signup/presentation/widgets/id_field.dart';
import 'package:ormee_app/feature/auth/signup/presentation/widgets/phone_fields.dart';
import 'package:ormee_app/feature/auth/signup/presentation/widgets/email_fields.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  late final SignupFieldController _fieldController;

  @override
  void initState() {
    super.initState();
    _fieldController = SignupFieldController(context);
    _fieldController.initializeFields();
  }

  @override
  void dispose() {
    _fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoText(text: "이름"),
            BasicField(
              type: SignUpFieldType.name,
              controller: _fieldController.controllers[SignUpFieldType.name]!,
              focusNode: _fieldController.focusNodes[SignUpFieldType.name]!,
              state: state,
              onMoveToNext: _fieldController.moveToNextField,
            ),

            InfoText(text: "아이디"),
            IdField(
              controller: _fieldController.controllers[SignUpFieldType.id]!,
              focusNode: _fieldController.focusNodes[SignUpFieldType.id]!,
              state: state,
              onMoveToNext: _fieldController.moveToNextField,
              fieldController: _fieldController,
            ),

            InfoText(text: "비밀번호"),
            BasicField(
              type: SignUpFieldType.password,
              controller:
                  _fieldController.controllers[SignUpFieldType.password]!,
              focusNode: _fieldController.focusNodes[SignUpFieldType.password]!,
              state: state,
              onMoveToNext: _fieldController.moveToNextField,
            ),

            InfoText(text: "비밀번호 확인"),
            BasicField(
              type: SignUpFieldType.passwordConfirm,
              controller: _fieldController
                  .controllers[SignUpFieldType.passwordConfirm]!,
              focusNode:
                  _fieldController.focusNodes[SignUpFieldType.passwordConfirm]!,
              state: state,
              onMoveToNext: _fieldController.moveToNextField,
            ),

            InfoText(text: "연락처"),
            PhoneFields(
              controllers: _fieldController.controllers,
              focusNodes: _fieldController.focusNodes,
              state: state,
              onMoveToNext: _fieldController.moveToNextField,
            ),

            InfoText(text: "이메일"),
            EmailFields(
              controllers: _fieldController.controllers,
              focusNodes: _fieldController.focusNodes,
              state: state,
              onMoveToNext: _fieldController.moveToNextField,
            ),
          ],
        );
      },
    );
  }
}
