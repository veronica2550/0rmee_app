part of 'signup_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class FieldChanged extends SignUpEvent {
  final SignUpFieldType fieldType;
  final String value;

  const FieldChanged(this.fieldType, this.value);

  @override
  List<Object> get props => [fieldType, value];
}

class FieldValidated extends SignUpEvent {
  final SignUpFieldType fieldType;

  const FieldValidated(this.fieldType);

  @override
  List<Object> get props => [fieldType];
}

class SubmitSignUp extends SignUpEvent {
  const SubmitSignUp();
}

class ValidateFields extends SignUpEvent {
  const ValidateFields();
}

class CheckIdDuplication extends SignUpEvent {
  final String id;
  const CheckIdDuplication(this.id);

  @override
  List<Object> get props => [id];
}

class TermsToggled extends SignUpEvent {
  final int index;
  final bool value;

  const TermsToggled({required this.index, required this.value});

  @override
  List<Object> get props => [index, value];
}

class AllTermsToggled extends SignUpEvent {
  final bool value;

  const AllTermsToggled({required this.value});

  @override
  List<Object> get props => [value];
}
