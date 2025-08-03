import 'package:equatable/equatable.dart';

abstract class VersionEvent extends Equatable {
  const VersionEvent();

  @override
  List<Object> get props => [];
}

class LoadVersionInfo extends VersionEvent {}
