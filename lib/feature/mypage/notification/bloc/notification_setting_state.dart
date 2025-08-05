import 'package:ormee_app/feature/mypage/notification/data/model.dart';

abstract class NotificationSettingState {}

class NotificationSettingInitial extends NotificationSettingState {}

class NotificationSettingLoading extends NotificationSettingState {}

class NotificationSettingLoaded extends NotificationSettingState {
  final NotificationSettingModel settings;

  NotificationSettingLoaded(this.settings);
}

class NotificationSettingUpdating extends NotificationSettingState {}

class NotificationSettingUpdateSuccess extends NotificationSettingState {}

class NotificationSettingError extends NotificationSettingState {
  final String message;

  NotificationSettingError(this.message);
}
