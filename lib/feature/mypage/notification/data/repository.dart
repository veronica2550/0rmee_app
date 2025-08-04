import 'package:ormee_app/feature/mypage/notification/data/model.dart';
import 'package:ormee_app/feature/mypage/notification/data/remote_datasource.dart';

class NotificationSettingRepository {
  final NotificationSettingRemoteDataSource remoteDataSource;

  NotificationSettingRepository(this.remoteDataSource);

  Future<NotificationSettingModel> readNotificationSetting() {
    return remoteDataSource.fetchStudentInfo();
  }

  Future<void> updateNotificationSetting(NotificationSettingModel settings) async {
    await remoteDataSource.updateStudentInfo(settings);
  }
}