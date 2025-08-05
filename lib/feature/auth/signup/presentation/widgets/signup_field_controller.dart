import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/auth/signup/bloc/signup_bloc.dart';
import 'package:ormee_app/feature/auth/signup/data/model/signup_field_type.dart';
import 'package:ormee_app/feature/auth/signup/data/model/validation_status.dart';

class SignupFieldController {
  final BuildContext context;
  final Map<SignUpFieldType, TextEditingController> controllers = {};
  final Map<SignUpFieldType, FocusNode> focusNodes = {};

  // ID 필드 상태 관리를 위한 변수들
  String _lastCheckedId = '';
  String _lastValidatedId = '';
  bool _idTextChanged = false;

  SignupFieldController(this.context);

  void initializeFields() {
    // 컨트롤러와 포커스 노드 초기화
    for (SignUpFieldType type in SignUpFieldType.values) {
      controllers[type] = TextEditingController();
      focusNodes[type] = FocusNode();
    }

    _setupFieldListeners();
    _setupIdFieldListeners();
    _setupPasswordFieldListeners();
  }

  void _setupFieldListeners() {
    // 아이디 필드가 아닌 경우에만 포커스 잃을 때 validation 실행
    for (SignUpFieldType type in SignUpFieldType.values) {
      if (type != SignUpFieldType.id) {
        focusNodes[type]!.addListener(() {
          if (!focusNodes[type]!.hasFocus) {
            context.read<SignUpBloc>().add(FieldValidated(type));
          }
        });
      }
    }
  }

  void _setupIdFieldListeners() {
    // ID 필드 포커스 리스너 등록
    focusNodes[SignUpFieldType.id]!.addListener(() {
      if (!focusNodes[SignUpFieldType.id]!.hasFocus) {
        _handleIdFieldUnfocus();
      }
    });

    // ID 필드 텍스트 변경 감지
    String previousText = '';
    controllers[SignUpFieldType.id]!.addListener(() {
      final currentText = controllers[SignUpFieldType.id]!.text;

      if (currentText != previousText) {
        debugPrint(
          '📝 Text actually changed: "$previousText" → "$currentText"',
        );
        previousText = currentText;

        if (currentText != _lastCheckedId) {
          debugPrint('🔄 Setting _idTextChanged to true');
          _idTextChanged = true;
        }

        debugPrint('📤 Sending FieldChanged event');
        context.read<SignUpBloc>().add(
          FieldChanged(SignUpFieldType.id, currentText),
        );
      } else {
        debugPrint(
          '👆 Focus change detected, but text unchanged: "$currentText"',
        );
      }
    });
  }

  void _setupPasswordFieldListeners() {
    // 비밀번호 필드 unfocus 시 비밀번호 확인 필드 재검증
    focusNodes[SignUpFieldType.password]!.addListener(() {
      if (!focusNodes[SignUpFieldType.password]!.hasFocus) {
        final passwordConfirmText =
            controllers[SignUpFieldType.passwordConfirm]!.text;

        if (passwordConfirmText.isNotEmpty) {
          context.read<SignUpBloc>().add(
            FieldValidated(SignUpFieldType.passwordConfirm),
          );
        }
      }
    });
  }

  void _handleIdFieldUnfocus() {
    final currentText = controllers[SignUpFieldType.id]!.text;
    final currentState = context.read<SignUpBloc>().state;
    final currentValidation =
        currentState.validationResults[SignUpFieldType.id];

    debugPrint(
      '🔍 ID unfocus - current: "$currentText", lastChecked: "$_lastCheckedId", lastValidated: "$_lastValidatedId"',
    );
    debugPrint('📊 Current status: ${currentValidation?.status}');

    // checked 상태에서 텍스트가 변경되지 않았다면 아무것도 하지 않음
    if (currentValidation?.status == ValidationStatus.checked &&
        currentText == _lastCheckedId) {
      debugPrint('🚫 Skipping validation - text unchanged in checked state');
      return;
    }

    bool textActuallyChanged = currentText != _lastValidatedId;
    bool shouldValidate =
        currentText.isNotEmpty &&
        textActuallyChanged &&
        (currentValidation?.status == ValidationStatus.initial ||
            currentValidation?.status == ValidationStatus.valid ||
            currentValidation?.status == ValidationStatus.invalid);

    if (shouldValidate) {
      debugPrint('✅ Validating ID field on unfocus');
      context.read<SignUpBloc>().add(FieldValidated(SignUpFieldType.id));
      _lastValidatedId = currentText;
    } else {
      debugPrint('🚫 Skipping validation - conditions not met');
    }
  }

  void moveToNextField(SignUpFieldType currentType) {
    List<SignUpFieldType> fieldOrder = SignUpFieldType.values;
    int currentIndex = fieldOrder.indexOf(currentType);

    if (currentIndex < fieldOrder.length - 1) {
      SignUpFieldType nextType = fieldOrder[currentIndex + 1];
      FocusScope.of(context).requestFocus(focusNodes[nextType]!);
    } else {
      // 마지막 필드에서 엔터 누르면 회원가입 실행
      // context.read<SignUpBloc>().add(const SubmitSignUp());
    }
  }

  void handleIdDuplicateCheck() {
    FocusScope.of(context).unfocus();
    context.read<SignUpBloc>().add(
      CheckIdDuplication(controllers[SignUpFieldType.id]!.text),
    );

    // 중복확인 완료 후 상태 업데이트
    _lastCheckedId = controllers[SignUpFieldType.id]!.text;
    _idTextChanged = false;
  }

  bool isDuplicateCheckNeeded(ValidationResult validationResult) {
    switch (validationResult.status) {
      case ValidationStatus.valid:
        return true;
      case ValidationStatus.checked:
        return _idTextChanged;
      case ValidationStatus.initial:
      case ValidationStatus.invalid:
      case ValidationStatus.checking:
      default:
        return false;
    }
  }

  // Getters
  String get lastCheckedId => _lastCheckedId;
  bool get idTextChanged => _idTextChanged;

  set idTextChanged(bool value) {
    _idTextChanged = value;
  }

  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    focusNodes.values.forEach((focusNode) => focusNode.dispose());
  }
}
