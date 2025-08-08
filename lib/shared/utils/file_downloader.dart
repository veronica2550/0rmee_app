import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ormee_app/shared/widgets/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> downloadFile({
  required BuildContext context,
  required String url,
  required String fileName,
}) async {
  try {
    final dio = Dio();

    // 임시 파일 다운로드
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/$fileName';
    await dio.download(url, tempPath);

    final tempFile = File(tempPath);

    if (Platform.isIOS) {
      // iOS: 공유 시트
      final xFile = XFile(tempFile.path, name: fileName);
      await Share.shareXFiles([xFile]);
    } else if (Platform.isAndroid) {
      // AOS: 경로 지정 후 저장
      final bytes = await tempFile.readAsBytes();
      await FileSaver.instance.saveAs(
        name: fileName,
        bytes: bytes,
        mimeType: MimeType.other, fileExtension: '',
      );

      OrmeeToast.show(context, "'$fileName' 저장 완료. 파일 앱에서 확인하세요.", false);
    } else {
      throw UnsupportedError("지원하지 않는 플랫폼이에요.");
    }
  } catch (e, stack) {
    debugPrint("❌ 다운로드 실패: $e");
    debugPrint("StackTrace: $stack");
    OrmeeToast.show(context, "파일을 저장 실패. 다시 시도해 주세요.", true);
  }
}
