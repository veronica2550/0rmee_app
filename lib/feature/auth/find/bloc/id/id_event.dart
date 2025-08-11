import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/auth/find/data/id/model.dart';

abstract class FindIdEvent extends Equatable {
  const FindIdEvent();

  @override
  List<Object> get props => [];
}

class FindIdSubmitted extends FindIdEvent {
  final UserName userInfo;

  const FindIdSubmitted(this.userInfo);

  @override
  List<Object> get props => [userInfo];
}

class FindIdReset extends FindIdEvent {}
