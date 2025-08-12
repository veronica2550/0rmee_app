import 'package:equatable/equatable.dart';

abstract class FindPasswordState extends Equatable {
  const FindPasswordState();

  @override
  List<Object> get props => [];
}

class FindPasswordInitial extends FindPasswordState {}

class FindPasswordLoading extends FindPasswordState {}

class FindPasswordSuccess extends FindPasswordState {}

class FindPasswordFailure extends FindPasswordState {
  final String message;

  const FindPasswordFailure(this.message);

  @override
  List<Object> get props => [message];
}
