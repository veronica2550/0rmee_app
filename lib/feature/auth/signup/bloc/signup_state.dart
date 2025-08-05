part of 'signup_bloc.dart';

class SignUpState extends Equatable {
  final Map<SignUpFieldType, String> fieldValues;
  final Map<SignUpFieldType, bool> isFieldNotEmpty;
  final Map<SignUpFieldType, ValidationResult> validationResults;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  final bool terms1;
  final bool terms2;
  final bool terms3;

  bool get isAllTermsChecked => terms1 && terms2 && terms3;
  bool get isRequiredTermsChecked => terms1 && terms2;
  bool get isFieldsValid {
    List<SignUpFieldType> requiredFields = [
      SignUpFieldType.name,
      SignUpFieldType.id,
      SignUpFieldType.password,
      SignUpFieldType.passwordConfirm,
      SignUpFieldType.email,
    ];

    for (SignUpFieldType type in requiredFields) {
      final value = fieldValues[type] ?? '';
      final result = validationResults[type] ?? ValidationResult.initial;

      if (value.isEmpty || result.status == ValidationStatus.invalid) {
        return false;
      }
    }

    return true;
  }

  const SignUpState({
    required this.fieldValues,
    required this.isFieldNotEmpty,
    required this.validationResults,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    required this.terms1,
    required this.terms2,
    required this.terms3,
  });

  factory SignUpState.initial() {
    final Map<SignUpFieldType, String> initialValues = {};
    final Map<SignUpFieldType, bool> initialNotEmpty = {};
    final Map<SignUpFieldType, ValidationResult> initialValidation = {};

    for (SignUpFieldType type in SignUpFieldType.values) {
      initialValues[type] = '';
      initialNotEmpty[type] = false;

      // ID와 PW 필드에만 초기 안내 문구 설정
      if (type == SignUpFieldType.id) {
        initialValidation[type] = ValidationResult.idInitial;
      } else if (type == SignUpFieldType.password) {
        initialValidation[type] = ValidationResult.pwInitial;
      } else {
        initialValidation[type] = ValidationResult.initial;
      }
    }

    return SignUpState(
      fieldValues: initialValues,
      isFieldNotEmpty: initialNotEmpty,
      validationResults: initialValidation,
      terms1: false,
      terms2: false,
      terms3: false,
    );
  }

  SignUpState copyWith({
    Map<SignUpFieldType, String>? fieldValues,
    Map<SignUpFieldType, bool>? isFieldNotEmpty,
    Map<SignUpFieldType, ValidationResult>? validationResults,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool? terms1,
    bool? terms2,
    bool? terms3,
  }) {
    return SignUpState(
      fieldValues: fieldValues ?? this.fieldValues,
      isFieldNotEmpty: isFieldNotEmpty ?? this.isFieldNotEmpty,
      validationResults: validationResults ?? this.validationResults,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      terms1: terms1 ?? this.terms1,
      terms2: terms2 ?? this.terms2,
      terms3: terms3 ?? this.terms3,
    );
  }

  @override
  List<Object?> get props => [
    fieldValues,
    isFieldNotEmpty,
    validationResults,
    isValid,
    isLoading,
    errorMessage,
    isSuccess,
    terms1,
    terms2,
    terms3,
  ];
}
