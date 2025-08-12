import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/auth/find/bloc/id/id_event.dart';
import 'package:ormee_app/feature/auth/find/bloc/id/id_state.dart';
import 'package:ormee_app/feature/auth/find/data/id/repository.dart';

class FindIdBloc extends Bloc<FindIdEvent, FindIdState> {
  final FindIdRepository repository;

  FindIdBloc({required this.repository}) : super(FindIdInitial()) {
    on<FindIdSubmitted>(_onFindIdSubmitted);
    on<FindIdReset>(_onFindIdReset);
  }

  Future<void> _onFindIdSubmitted(
    FindIdSubmitted event,
    Emitter<FindIdState> emit,
  ) async {
    emit(FindIdLoading());

    try {
      final foundId = await repository.findId(event.userInfo);
      emit(FindIdSuccess(name: event.userInfo.name, foundId: foundId));
    } catch (e) {
      emit(FindIdFailure(e.toString()));
    }
  }

  void _onFindIdReset(FindIdReset event, Emitter<FindIdState> emit) {
    emit(FindIdInitial());
  }
}
