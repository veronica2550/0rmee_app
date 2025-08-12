import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/auth/find/data/pw/model.dart';

abstract class FindPasswordEvent extends Equatable {
  const FindPasswordEvent();

  @override
  List<Object> get props => [];
}

class PasswordChangeRequested extends FindPasswordEvent {
  final PasswordChangeInfo passwordInfo;

  const PasswordChangeRequested(this.passwordInfo);

  @override
  List<Object> get props => [passwordInfo];
}

class FindPasswordReset extends FindPasswordEvent {}
