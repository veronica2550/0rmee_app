import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/auth/signup/bloc/signup_bloc.dart';
import 'package:ormee_app/feature/auth/signup/data/model/signup_field_type.dart';
import 'package:ormee_app/feature/auth/signup/data/model/validation_status.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';

class BasicField extends StatelessWidget {
  final SignUpFieldType type;
  final TextEditingController controller;
  final FocusNode focusNode;
  final SignUpState state;
  final Function(SignUpFieldType) onMoveToNext;

  const BasicField({
    Key? key,
    required this.type,
    required this.controller,
    required this.focusNode,
    required this.state,
    required this.onMoveToNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final validationResult =
        state.validationResults[type] ?? ValidationResult.initial;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OrmeeTextField(
          hintText: type.hintText,
          controller: controller,
          focusNode: focusNode,
          textInputAction: _getTextInputAction(),
          isPassword: type.isPassword,
          errorText: validationResult.status == ValidationStatus.invalid
              ? ""
              : null,
          onTextChanged: (text) {
            context.read<SignUpBloc>().add(FieldChanged(type, text));
          },
          onFieldSubmitted: (_) {
            onMoveToNext(type);
          },
        ),
        if (validationResult.message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
            child: Label2Regular12(
              text: validationResult.message,
              color: validationResult.status == ValidationStatus.valid
                  ? OrmeeColor.purple[50]
                  : validationResult.status == ValidationStatus.initial
                  ? OrmeeColor.gray[60]
                  : OrmeeColor.systemError,
            ),
          ),
        if (validationResult.status == ValidationStatus.checking)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
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
        SizedBox(height: 16),
      ],
    );
  }

  TextInputAction _getTextInputAction() {
    return type == SignUpFieldType.emailProvider
        ? TextInputAction.done
        : TextInputAction.next;
  }
}
