import 'package:ormee_app/feature/mypage/version/data/model.dart';
import 'package:ormee_app/feature/mypage/version/data/remote_datasource.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionRepository {
  final VersionRemoteDataSource remoteDataSource;

  VersionRepository(this.remoteDataSource);

  Future<VersionInfo> getVersionInfo() async {
    try {
      // 현재 앱 버전 가져오기
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // 최신 버전 가져오기
      final latestVersion = await remoteDataSource.fetchLatestVersion();

      // 버전 비교
      final isLatest = _compareVersions(currentVersion, latestVersion);

      return VersionInfo(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        isLatest: isLatest,
      );
    } catch (e) {
      throw Exception('버전 정보를 가져오는데 실패했습니다: $e');
    }
  }

  bool _compareVersions(String current, String latest) {
    // 버전 문자열을 숫자 배열로 변환
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    // 길이를 맞춤 (예: 1.0 vs 1.0.0)
    while (currentParts.length < latestParts.length) {
      currentParts.add(0);
    }
    while (latestParts.length < currentParts.length) {
      latestParts.add(0);
    }

    // 버전 비교
    for (int i = 0; i < currentParts.length; i++) {
      if (currentParts[i] < latestParts[i]) {
        return false; // 업데이트 필요
      } else if (currentParts[i] > latestParts[i]) {
        return true; // 현재 버전이 더 높음 (최신)
      }
    }
    return true; // 같은 버전 (최신)
  }
}
