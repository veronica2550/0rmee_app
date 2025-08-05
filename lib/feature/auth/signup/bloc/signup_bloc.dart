import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/auth/signup/data/model/signup_field_type.dart';
import 'package:ormee_app/feature/auth/signup/data/model/validation_status.dart';
import 'package:ormee_app/feature/auth/signup/data/repositories/api.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState.initial()) {
    on<FieldChanged>(_onFieldChanged);
    on<FieldValidated>(_onFieldValidated);
    on<SubmitSignUp>(_onSubmitSignUp);
    on<ValidateFields>(_onValidateFields);
    on<CheckIdDuplication>(_onCheckIdDuplication);
    on<TermsToggled>(_onTermsToggled);
    on<AllTermsToggled>(_onAllTermsToggled);
  }

  void _onFieldChanged(FieldChanged event, Emitter<SignUpState> emit) {
    final newFieldValues = Map<SignUpFieldType, String>.from(state.fieldValues);
    final newIsFieldNotEmpty = Map<SignUpFieldType, bool>.from(
      state.isFieldNotEmpty,
    );
    final newValidationResults = Map<SignUpFieldType, ValidationResult>.from(
      state.validationResults,
    );

    newFieldValues[event.fieldType] = event.value;
    newIsFieldNotEmpty[event.fieldType] = event.value.isNotEmpty;

    // 실시간 validation (에러 상태에서만)
    if (state.validationResults[event.fieldType]?.status ==
        ValidationStatus.invalid) {
      newValidationResults[event.fieldType] = _validateField(
        event.fieldType,
        event.value,
      );
    } else if (state.validationResults[event.fieldType]?.status ==
        ValidationStatus.checked) {
      // checked → initial로 되돌리기
      newValidationResults[event.fieldType] = ValidationResult.idInitial;
    }

    emit(
      state.copyWith(
        fieldValues: newFieldValues,
        isFieldNotEmpty: newIsFieldNotEmpty,
        validationResults: newValidationResults,
        isValid: _calculateOverallValidity(
          newFieldValues,
          newValidationResults,
          state.terms1,
          state.terms2,
        ),
        errorMessage: null,
      ),
    );
  }

  void _onFieldValidated(
    FieldValidated event,
    Emitter<SignUpState> emit,
  ) async {
    final newValidationResults = Map<SignUpFieldType, ValidationResult>.from(
      state.validationResults,
    );

    final value = state.fieldValues[event.fieldType] ?? '';

    // 전화번호나 이메일의 경우 API 호출이 필요한 경우
    if ((event.fieldType == SignUpFieldType.phone1 ||
            event.fieldType == SignUpFieldType.phone2 ||
            event.fieldType == SignUpFieldType.phone3) &&
        _isPhoneNumberComplete() &&
        _isPhoneNumberValid()) {
      // 전화번호 중복 확인
      newValidationResults[SignUpFieldType.phone1] = ValidationResult.checking;
      emit(state.copyWith(validationResults: newValidationResults));

      final isPhoneAvailable = await _checkPhoneAvailability(
        _getFullPhoneNumber(),
      );
      newValidationResults[SignUpFieldType.phone1] = isPhoneAvailable
          ? ValidationResult.phoneValid
          : ValidationResult.phoneError;
    } else if (event.fieldType == SignUpFieldType.email &&
        _isEmailComplete() &&
        _isEmailValid()) {
      // 이메일 중복 확인
      newValidationResults[SignUpFieldType.email] = ValidationResult.checking;
      emit(state.copyWith(validationResults: newValidationResults));

      final isEmailAvailable = await _checkEmailAvailability(_getFullEmail());
      newValidationResults[SignUpFieldType.email] = isEmailAvailable
          ? ValidationResult.emailValid
          : ValidationResult.emailError;
    } else {
      // 일반 필드 validation
      newValidationResults[event.fieldType] = _validateField(
        event.fieldType,
        value,
      );
    }

    emit(
      state.copyWith(
        validationResults: newValidationResults,
        isValid: _calculateOverallValidity(
          state.fieldValues,
          newValidationResults,
          state.terms1,
          state.terms2,
        ),
      ),
    );
  }

  void _onValidateFields(ValidateFields event, Emitter<SignUpState> emit) {
    final isValid = _calculateOverallValidity(
      state.fieldValues,
      state.validationResults,
      state.terms1,
      state.terms2,
    );
    emit(state.copyWith(isValid: isValid));
  }

  Future<void> _onSubmitSignUp(
    SubmitSignUp event,
    Emitter<SignUpState> emit,
  ) async {
    // 필수 약관 동의 확인
    if (!state.terms1 || !state.terms2) {
      emit(state.copyWith(errorMessage: '필수 약관에 동의해주세요.'));
      return;
    }

    // 필드 유효성 검사
    if (!_validateAllFields(state.fieldValues, state.validationResults)) {
      emit(state.copyWith(errorMessage: '모든 필드를 올바르게 입력해주세요.'));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // API 호출
      final apiData = _getApiData();

      // 실제 API 호출 로직
      // await signUpRepository.signUp(apiData);

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: '회원가입 중 오류가 발생했습니다: ${e.toString()}',
        ),
      );
    }
  }

  ValidationResult _validateField(SignUpFieldType fieldType, String value) {
    switch (fieldType) {
      case SignUpFieldType.name:
        return _validateName(value);
      case SignUpFieldType.id:
        return _validateId(value);
      case SignUpFieldType.password:
        return _validatePassword(value);
      case SignUpFieldType.passwordConfirm:
        return _validatePasswordConfirm(value);
      case SignUpFieldType.email:
        return _validateEmailFormat(value);
      default:
        return ValidationResult.initial;
    }
  }

  ValidationResult _validateName(String value) {
    if (value.isEmpty) return ValidationResult.initial;

    // 한글만 허용 (영문, 특수문자, 숫자 입력 불가)
    final koreanOnly = RegExp(r'^[가-힣ㄱ-ㅎㅏ-ㅣ]+$');
    if (!koreanOnly.hasMatch(value)) {
      return ValidationResult.nameError;
    }

    return ValidationResult.nameValid;
  }

  ValidationResult _validateId(String value) {
    if (value.isEmpty) return ValidationResult.idInitial; // 빈 값일 때 초기 안내 문구

    // 영문, 숫자, 언더스코어만 허용, 4~15자
    final idPattern = RegExp(r'^[a-zA-Z0-9_]{4,15}$');
    if (!idPattern.hasMatch(value)) {
      return ValidationResult.idError;
    }

    return ValidationResult.idValid;
  }

  ValidationResult _validatePassword(String value) {
    if (value.isEmpty) return ValidationResult.pwInitial; // 빈 값일 때 초기 안내 문구

    // 8~16자, 영문, 숫자, 특수문자 중 2종 이상 포함
    if (value.length < 8 || value.length > 16) {
      return ValidationResult.passwordError;
    }

    int typeCount = 0;
    if (RegExp(r'[a-zA-Z]').hasMatch(value)) typeCount++;
    if (RegExp(r'[0-9]').hasMatch(value)) typeCount++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>];=').hasMatch(value)) typeCount++;

    if (typeCount < 2) {
      return ValidationResult.passwordError;
    }

    return ValidationResult.passwordValid;
  }

  ValidationResult _validatePasswordConfirm(String value) {
    if (value.isEmpty) return ValidationResult.initial;

    final password = state.fieldValues[SignUpFieldType.password] ?? '';
    if (password != value) {
      return ValidationResult.passwordConfirmError;
    }

    return ValidationResult.passwordConfirmValid;
  }

  ValidationResult _validateEmailFormat(String value) {
    if (value.isEmpty) return ValidationResult.initial;

    // 기본 이메일 형식 검사
    final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+$');
    if (!emailPattern.hasMatch(value)) {
      return ValidationResult.emailError;
    }

    return ValidationResult.initial; // 형식이 맞으면 API 호출 대기
  }

  // 필드만 검증 (약관 제외)
  bool get isFieldsValid =>
      _validateAllFields(state.fieldValues, state.validationResults);

  // 전체 유효성 검사를 위한 새로운 함수
  bool _calculateOverallValidity(
    Map<SignUpFieldType, String> fieldValues,
    Map<SignUpFieldType, ValidationResult> validationResults,
    bool terms1,
    bool terms2,
  ) {
    // 필수 약관 동의 확인
    if (!terms1 || !terms2) {
      return false;
    }

    // 필드 유효성 검사
    return _validateAllFields(fieldValues, validationResults);
  }

  bool _validateAllFields(
    Map<SignUpFieldType, String> fieldValues,
    Map<SignUpFieldType, ValidationResult> validationResults,
  ) {
    // 필수 필드 체크
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

    // 전화번호 validation (선택사항이지만 입력했다면 유효해야 함)
    if (_isPhoneNumberComplete()) {
      final phoneResult =
          validationResults[SignUpFieldType.phone1] ?? ValidationResult.initial;
      if (phoneResult.status == ValidationStatus.invalid) {
        return false;
      }
    }

    return true;
  }

  bool _isPhoneNumberComplete() {
    final phone1 = state.fieldValues[SignUpFieldType.phone1] ?? '';
    final phone2 = state.fieldValues[SignUpFieldType.phone2] ?? '';
    final phone3 = state.fieldValues[SignUpFieldType.phone3] ?? '';

    return phone1.isNotEmpty && phone2.isNotEmpty && phone3.isNotEmpty;
  }

  bool _isPhoneNumberValid() {
    final phone1 = state.fieldValues[SignUpFieldType.phone1] ?? '';
    final phone2 = state.fieldValues[SignUpFieldType.phone2] ?? '';
    final phone3 = state.fieldValues[SignUpFieldType.phone3] ?? '';

    return RegExp(r'^010$').hasMatch(phone1) &&
        RegExp(r'^\d{4}$').hasMatch(phone2) &&
        RegExp(r'^\d{4}$').hasMatch(phone3);
  }

  bool _isEmailComplete() {
    final email = state.fieldValues[SignUpFieldType.email] ?? '';
    final provider = state.fieldValues[SignUpFieldType.emailProvider] ?? '';

    return email.isNotEmpty && provider.isNotEmpty;
  }

  bool _isEmailValid() {
    final email = state.fieldValues[SignUpFieldType.email] ?? '';
    final provider = state.fieldValues[SignUpFieldType.emailProvider] ?? '';

    final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+$');
    final providerPattern = RegExp(r'^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    return emailPattern.hasMatch(email) && providerPattern.hasMatch(provider);
  }

  String _getFullPhoneNumber() {
    final phone1 = state.fieldValues[SignUpFieldType.phone1] ?? '';
    final phone2 = state.fieldValues[SignUpFieldType.phone2] ?? '';
    final phone3 = state.fieldValues[SignUpFieldType.phone3] ?? '';

    return '$phone1$phone2$phone3';
  }

  String _getFullEmail() {
    final email = state.fieldValues[SignUpFieldType.email] ?? '';
    final provider = state.fieldValues[SignUpFieldType.emailProvider] ?? '';

    return '$email@$provider';
  }

  // API 호출 함수들 (실제 구현 필요)
  Future<bool> _checkPhoneAvailability(String phoneNumber) async {
    // 실제 API 호출 로직 구현
    await Future.delayed(Duration(milliseconds: 500)); // 시뮬레이션
    return true; // 임시로 항상 사용 가능하다고 반환
  }

  Future<bool> _checkEmailAvailability(String email) async {
    // 실제 API 호출 로직 구현
    await Future.delayed(Duration(milliseconds: 500)); // 시뮬레이션
    return true; // 임시로 항상 사용 가능하다고 반환
  }

  Map<String, String> _getApiData() {
    final Map<String, String> data = {};

    // 필드 데이터 추가
    state.fieldValues.forEach((type, value) {
      data[type.apiKey] = value;
    });

    // 약관 동의 상태 추가
    data['terms_service'] = state.terms1.toString();
    data['terms_privacy'] = state.terms2.toString();
    data['terms_marketing'] = state.terms3.toString();

    return data;
  }

  Future<void> _onCheckIdDuplication(
    CheckIdDuplication event,
    Emitter<SignUpState> emit,
  ) async {
    // ID 중복 확인 시작 - 로딩 상태로 변경
    emit(
      state.copyWith(
        validationResults: {
          ...state.validationResults,
          SignUpFieldType.id: ValidationResult(
            status: ValidationStatus.checking,
            message: '중복 확인 중...',
          ),
        },
      ),
    );

    try {
      // API 호출 예시 (실제 API 서비스를 사용하세요)
      final isDuplicate = await _checkIdDuplication(event.id);

      if (isDuplicate) {
        // 중복된 ID
        emit(
          state.copyWith(
            validationResults: {
              ...state.validationResults,
              SignUpFieldType.id: ValidationResult(
                status: ValidationStatus.invalid,
                message: '이미 사용 중인 아이디예요.',
              ),
            },
            isValid: false, // 중복된 ID가 있으면 전체 유효성도 false
          ),
        );
      } else {
        // 사용 가능한 ID
        final newValidationResults = {
          ...state.validationResults,
          SignUpFieldType.id: ValidationResult(
            status: ValidationStatus.checked,
            message: '사용 가능한 아이디예요.',
          ),
        };

        emit(
          state.copyWith(
            validationResults: newValidationResults,
            isValid: _calculateOverallValidity(
              state.fieldValues,
              newValidationResults,
              state.terms1,
              state.terms2,
            ),
          ),
        );
      }
    } catch (e) {
      // 에러 처리
      emit(
        state.copyWith(
          validationResults: {
            ...state.validationResults,
            SignUpFieldType.id: ValidationResult(
              status: ValidationStatus.invalid,
              message: '중복 확인 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
            ),
          },
          isValid: false, // 에러가 있으면 전체 유효성도 false
        ),
      );
    }
  }

  void _onTermsToggled(TermsToggled event, Emitter<SignUpState> emit) {
    bool t1 = state.terms1;
    bool t2 = state.terms2;
    bool t3 = state.terms3;

    if (event.index == 1) t1 = event.value;
    if (event.index == 2) t2 = event.value;
    if (event.index == 3) t3 = event.value;

    emit(
      state.copyWith(
        terms1: t1,
        terms2: t2,
        terms3: t3,
        isValid: _calculateOverallValidity(
          state.fieldValues,
          state.validationResults,
          t1,
          t2,
        ),
      ),
    );
  }

  void _onAllTermsToggled(AllTermsToggled event, Emitter<SignUpState> emit) {
    emit(
      state.copyWith(
        terms1: event.value,
        terms2: event.value,
        terms3: event.value,
        isValid: _calculateOverallValidity(
          state.fieldValues,
          state.validationResults,
          event.value,
          event.value,
        ),
      ),
    );
  }

  // ID 중복 확인 API 호출 함수
  Future<bool> _checkIdDuplication(String id) async {
    bool avail = await ApiService.checkIdDuplication(id);
    return !avail;
  }
}
