import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/auth/signup/bloc/signup_bloc.dart';
import 'package:ormee_app/feature/auth/signup/data/model/signup_field_type.dart';
import 'package:ormee_app/feature/auth/signup/data/model/validation_status.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';

class PhoneFields extends StatelessWidget {
  final Map<SignUpFieldType, TextEditingController> controllers;
  final Map<SignUpFieldType, FocusNode> focusNodes;
  final SignUpState state;
  final Function(SignUpFieldType) onMoveToNext;

  const PhoneFields({
    Key? key,
    required this.controllers,
    required this.focusNodes,
    required this.state,
    required this.onMoveToNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phone1Validation =
        state.validationResults[SignUpFieldType.phone1] ??
        ValidationResult.initial;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OrmeeTextField(
                hintText: SignUpFieldType.phone1.hintText,
                controller: controllers[SignUpFieldType.phone1]!,
                focusNode: focusNodes[SignUpFieldType.phone1]!,
                textInputAction: TextInputAction.next,
                errorText: phone1Validation.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.phone1, text),
                  );
                },
                onFieldSubmitted: (_) {
                  onMoveToNext(SignUpFieldType.phone1);
                },
              ),
            ),
            SizedBox(
              width: 13,
              child: Center(child: Label1Regular14(text: "-")),
            ),
            Expanded(
              child: OrmeeTextField(
                hintText: SignUpFieldType.phone2.hintText,
                controller: controllers[SignUpFieldType.phone2]!,
                focusNode: focusNodes[SignUpFieldType.phone2]!,
                textInputAction: TextInputAction.next,
                errorText: phone1Validation.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.phone2, text),
                  );
                },
                onFieldSubmitted: (_) {
                  onMoveToNext(SignUpFieldType.phone2);
                },
              ),
            ),
            SizedBox(
              width: 13,
              child: Center(child: Label1Regular14(text: "-")),
            ),
            Expanded(
              child: OrmeeTextField(
                hintText: SignUpFieldType.phone3.hintText,
                controller: controllers[SignUpFieldType.phone3]!,
                focusNode: focusNodes[SignUpFieldType.phone3]!,
                textInputAction: TextInputAction.next,
                errorText: phone1Validation.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.phone3, text),
                  );
                },
                onFieldSubmitted: (_) {
                  onMoveToNext(SignUpFieldType.phone3);
                },
              ),
            ),
          ],
        ),
        if (phone1Validation.message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Label2Regular12(
                text: phone1Validation.message,
                color: phone1Validation.status == ValidationStatus.valid
                    ? OrmeeColor.purple[50]
                    : OrmeeColor.systemError,
              ),
            ),
          ),
        if (phone1Validation.status == ValidationStatus.checking)
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
        SizedBox(height: 16),
      ],
    );
  }
}
