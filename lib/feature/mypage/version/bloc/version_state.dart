import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/mypage/version/data/model.dart';

// States
abstract class VersionState extends Equatable {
  const VersionState();

  @override
  List<Object> get props => [];
}

class VersionInitial extends VersionState {}

class VersionLoading extends VersionState {}

class VersionLoaded extends VersionState {
  final VersionInfo versionInfo;

  const VersionLoaded(this.versionInfo);

  @override
  List<Object> get props => [versionInfo];
}

class VersionError extends VersionState {
  final String message;

  const VersionError(this.message);

  @override
  List<Object> get props => [message];
}
