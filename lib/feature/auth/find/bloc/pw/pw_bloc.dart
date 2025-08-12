import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/auth/find/bloc/pw/pw_event.dart';
import 'package:ormee_app/feature/auth/find/bloc/pw/pw_state.dart';
import 'package:ormee_app/feature/auth/find/data/pw/repository.dart';

class FindPasswordBloc extends Bloc<FindPasswordEvent, FindPasswordState> {
  final FindPasswordRepository repository;

  FindPasswordBloc({required this.repository}) : super(FindPasswordInitial()) {
    on<PasswordChangeRequested>(_onPasswordChangeRequested);
    on<FindPasswordReset>(_onFindPasswordReset);
  }

  Future<void> _onPasswordChangeRequested(
    PasswordChangeRequested event,
    Emitter<FindPasswordState> emit,
  ) async {
    emit(FindPasswordLoading());

    try {
      await repository.changePassword(event.passwordInfo);
      emit(FindPasswordSuccess());
    } catch (e) {
      emit(FindPasswordFailure(e.toString()));
    }
  }

  void _onFindPasswordReset(
    FindPasswordReset event,
    Emitter<FindPasswordState> emit,
  ) {
    emit(FindPasswordInitial());
  }
}
