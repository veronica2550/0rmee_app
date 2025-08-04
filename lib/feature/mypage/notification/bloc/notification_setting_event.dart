import 'package:ormee_app/feature/mypage/notification/data/model.dart';

abstract class NotificationSettingEvent {}

class FetchNotificationSetting extends NotificationSettingEvent {}

class UpdateNotificationSetting extends NotificationSettingEvent {
  final NotificationSettingModel settings;

  UpdateNotificationSetting(this.settings);
}