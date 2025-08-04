import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/auth/signup/bloc/signup_bloc.dart';
import 'package:ormee_app/feature/auth/signup/data/model/signup_field_type.dart';
import 'package:ormee_app/feature/auth/signup/data/model/validation_status.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';

class EmailFields extends StatelessWidget {
  final Map<SignUpFieldType, TextEditingController> controllers;
  final Map<SignUpFieldType, FocusNode> focusNodes;
  final SignUpState state;
  final Function(SignUpFieldType) onMoveToNext;

  const EmailFields({
    Key? key,
    required this.controllers,
    required this.focusNodes,
    required this.state,
    required this.onMoveToNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailValidation =
        state.validationResults[SignUpFieldType.email] ??
        ValidationResult.initial;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: OrmeeTextField(
                hintText: SignUpFieldType.email.hintText,
                controller: controllers[SignUpFieldType.email]!,
                focusNode: focusNodes[SignUpFieldType.email]!,
                textInputAction: TextInputAction.next,
                errorText: emailValidation.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.email, text),
                  );
                },
                onFieldSubmitted: (_) {
                  onMoveToNext(SignUpFieldType.email);
                },
              ),
            ),
            SizedBox(width: 6),
            Label1Regular14(text: '@'),
            SizedBox(width: 6),
            Expanded(
              flex: 1,
              child: OrmeeTextField(
                hintText: SignUpFieldType.emailProvider.hintText,
                controller: controllers[SignUpFieldType.emailProvider]!,
                focusNode: focusNodes[SignUpFieldType.emailProvider]!,
                textInputAction: TextInputAction.done,
                errorText: emailValidation.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.emailProvider, text),
                  );
                },
                onFieldSubmitted: (_) {
                  onMoveToNext(SignUpFieldType.emailProvider);
                },
              ),
            ),
          ],
        ),
        if (emailValidation.message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Label2Regular12(
                text: emailValidation.message,
                color: emailValidation.status == ValidationStatus.valid
                    ? OrmeeColor.purple[50]
                    : OrmeeColor.systemError,
              ),
            ),
          ),
        if (emailValidation.status == ValidationStatus.checking)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '확인 중...',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: 24),
      ],
    );
  }
}
