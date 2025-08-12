import 'package:ormee_app/feature/auth/find/data/id/model.dart';
import 'package:ormee_app/feature/auth/find/data/id/remote_datasource.dart';

class FindIdRepository {
  final FindIdRemoteDataSource remoteDataSource;

  FindIdRepository(this.remoteDataSource);

  Future<String> findId(UserName username) {
    return remoteDataSource.findId(username);
  }
}
