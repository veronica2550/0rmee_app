import 'package:ormee_app/feature/mypage/notification/data/model.dart';
import 'package:ormee_app/feature/mypage/notification/data/remote_datasource.dart';

class NotificationSettingRepository {
  final NotificationSettingRemoteDataSource remoteDataSource;

  NotificationSettingRepository(this.remoteDataSource);

  Future<NotificationSettingModel> readStudentInfo() {
    return remoteDataSource.fetchStudentInfo();
  }

  Future<void> updateStudentInfo(NotificationSettingModel settings) async {
    await remoteDataSource.updateStudentInfo(settings);
  }
}