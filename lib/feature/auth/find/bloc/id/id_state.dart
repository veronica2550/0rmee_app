import 'package:equatable/equatable.dart';

abstract class FindIdState extends Equatable {
  const FindIdState();

  @override
  List<Object> get props => [];
}

class FindIdInitial extends FindIdState {}

class FindIdLoading extends FindIdState {}

class FindIdSuccess extends FindIdState {
  final String name;
  final String foundId;

  const FindIdSuccess({required this.name, required this.foundId});

  @override
  List<Object> get props => [name, foundId];
}

class FindIdFailure extends FindIdState {
  final String message;

  const FindIdFailure(this.message);

  @override
  List<Object> get props => [message];
}
