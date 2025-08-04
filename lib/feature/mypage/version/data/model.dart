class VersionResponse {
  final String status;
  final int code;
  final String data;

  VersionResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) {
    return VersionResponse(
      status: json['status'],
      code: json['code'],
      data: json['data'],
    );
  }
}

class VersionInfo {
  final String currentVersion;
  final String latestVersion;
  final bool isLatest;

  VersionInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.isLatest,
  });
}
