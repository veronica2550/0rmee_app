import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/mypage/version/bloc/version_event.dart';
import 'package:ormee_app/feature/mypage/version/bloc/version_state.dart';
import 'package:ormee_app/feature/mypage/version/data/repository.dart';

class VersionBloc extends Bloc<VersionEvent, VersionState> {
  final VersionRepository repository;

  VersionBloc(this.repository) : super(VersionInitial()) {
    on<LoadVersionInfo>(_onLoadVersionInfo);
  }

  Future<void> _onLoadVersionInfo(
    LoadVersionInfo event,
    Emitter<VersionState> emit,
  ) async {
    emit(VersionLoading());
    try {
      final versionInfo = await repository.getVersionInfo();
      emit(VersionLoaded(versionInfo));
    } catch (e) {
      emit(VersionError(e.toString()));
    }
  }
}
