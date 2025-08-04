import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/mypage/notification/bloc/notification_setting_event.dart';
import 'package:ormee_app/feature/mypage/notification/bloc/notification_setting_state.dart';
import 'package:ormee_app/feature/mypage/notification/data/model.dart';
import 'package:ormee_app/feature/mypage/notification/data/repository.dart';

class NotificationSettingBloc
    extends Bloc<NotificationSettingEvent, NotificationSettingState> {
  final NotificationSettingRepository repository;

  NotificationSettingBloc(this.repository)
      : super(NotificationSettingInitial()) {
    on<FetchNotificationSetting>((event, emit) async {
      emit(NotificationSettingLoading());
      try {
        final student = await repository.readNotificationSetting();
        emit(NotificationSettingLoaded(student));
      } catch (e) {
        emit(NotificationSettingError('알림 설정 정보를 불러오는 중 오류가 발생했어요.'));
      }
    });

    on<UpdateNotificationSetting>((event, emit) async {
      if (state is! NotificationSettingLoaded) return;
      final currentState = state as NotificationSettingLoaded;
      try {
        await repository.updateNotificationSetting(event.settings);
        final updated = NotificationSettingModel(
            quizRegister: event.settings.quizRegister,
            quizRemind: event.settings.quizRemind,
            quizDeadline: event.settings.quizDeadline,
            homeworkRegister: event.settings.homeworkRegister,
            homeworkRemind: event.settings.homeworkRemind,
            homeworkDeadline: event.settings.homeworkDeadline,
            memo: event.settings.memo,
            question: event.settings.question,
            notice: event.settings.notice,
            event: event.settings.event);
        emit(NotificationSettingLoaded(updated));
        emit(NotificationSettingUpdateSuccess());
      } catch (e) {
        emit(NotificationSettingError('알림 설정이 수정되지 않았어요.'));
        emit(currentState);
      }
    });
  }
}