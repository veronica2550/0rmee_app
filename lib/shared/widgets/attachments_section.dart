import 'package:flutter/material.dart';
import 'package:ormee_app/core/model/file_attachment.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/downloader.dart';

class AttachmentsSection extends StatelessWidget {
  final List<AttachmentFile> attachmentFiles;

  const AttachmentsSection({super.key, required this.attachmentFiles});

  String _safeDecodeName(String s) {
    if (s.isEmpty) return s;
    if (!s.contains('%')) return s;
    try {
      return Uri.decodeComponent(s);
    } catch (_) {
      try {
        return Uri.decodeFull(s);
      } catch (_) {
        return s;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: OrmeeColor.gray[10],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Label2Regular12(text: '첨부파일', color: OrmeeColor.gray[50]),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: attachmentFiles.map((file) {
                print(file.url);
                return Downloader(fileName: _safeDecodeName(file.name), url: file.url);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
