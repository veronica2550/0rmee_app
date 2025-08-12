import 'package:ormee_app/feature/auth/find/data/pw/model.dart';
import 'package:ormee_app/feature/auth/find/data/pw/remote_datasource.dart';

class FindPasswordRepository {
  final FindPasswordRemoteDataSource remoteDataSource;

  FindPasswordRepository(this.remoteDataSource);

  Future<void> changePassword(PasswordChangeInfo passwordInfo) {
    return remoteDataSource.changePassword(passwordInfo);
  }
}
