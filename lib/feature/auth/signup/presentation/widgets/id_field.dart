import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/auth/signup/bloc/signup_bloc.dart';
import 'package:ormee_app/feature/auth/signup/data/model/signup_field_type.dart';
import 'package:ormee_app/feature/auth/signup/data/model/validation_status.dart';
import 'package:ormee_app/feature/auth/signup/presentation/widgets/signup_field_controller.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';

class IdField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final SignUpState state;
  final Function(SignUpFieldType) onMoveToNext;
  final SignupFieldController fieldController;

  const IdField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.state,
    required this.onMoveToNext,
    required this.fieldController,
  }) : super(key: key);

  @override
  _IdFieldState createState() => _IdFieldState();
}

class _IdFieldState extends State<IdField> {
  @override
  Widget build(BuildContext context) {
    final validationResult =
        widget.state.validationResults[SignUpFieldType.id] ??
        ValidationResult.idInitial;

    // 중복확인 버튼 활성화 조건
    bool isDuplicateCheckEnabled =
        widget.controller.text.isNotEmpty &&
        widget.fieldController.isDuplicateCheckNeeded(validationResult);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OrmeeTextField(
                hintText: SignUpFieldType.id.hintText,
                controller: widget.controller,
                focusNode: widget.focusNode,
                textInputAction: TextInputAction.next,
                errorText: validationResult.status == ValidationStatus.invalid
                    ? ""
                    : null,
                onTextChanged: (text) {
                  setState(() {
                    widget.fieldController.idTextChanged = true;
                  });
                  context.read<SignUpBloc>().add(
                    FieldChanged(SignUpFieldType.id, text),
                  );
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                  context.read<SignUpBloc>().add(
                    FieldValidated(SignUpFieldType.id),
                  );
                  widget.onMoveToNext(SignUpFieldType.id);
                },
              ),
            ),
            SizedBox(width: 8),
            OrmeeButton(
              text: "중복확인",
              isTrue: isDuplicateCheckEnabled,
              trueAction: () {
                widget.fieldController.handleIdDuplicateCheck();
                setState(() {}); // UI 업데이트를 위한 setState
              },
            ),
          ],
        ),
        if (validationResult.message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
            child: Label2Regular12(
              text: validationResult.message,
              color: validationResult.status == ValidationStatus.checked
                  ? OrmeeColor.purple[50]
                  : (validationResult.status == ValidationStatus.initial ||
                        validationResult.status == ValidationStatus.valid ||
                        validationResult.status == ValidationStatus.checking)
                  ? OrmeeColor.gray[60]
                  : OrmeeColor.systemError,
            ),
          ),
        SizedBox(height: 16),
      ],
    );
  }
}
