import 'package:ormee_app/core/model/author.dart';
import 'package:ormee_app/core/model/file_attachment.dart';

class NoticeDetailModel {
  final String title;
  final String description;
  final DateTime postDate;
  bool isLiked;
  final AuthorModel author;

  final List<String> imageUrls;
  final List<AttachmentFile> attachmentFiles;

  NoticeDetailModel({
    required this.title,
    required this.description,
    required this.postDate,
    required this.isLiked,
    required this.author,
    required this.imageUrls,
    required this.attachmentFiles,
  });

  factory NoticeDetailModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> fileNames = json['data']['fileNames'] ?? [];
    final List<dynamic> filePaths = json['data']['filePaths'] ?? [];
    final List<dynamic> fileTypes = json['data']['fileTypes'] ?? [];

    List<String> images = [];
    List<AttachmentFile> files = [];

    for (int i = 0; i < filePaths.length; i++) {
      final url = filePaths[i] as String;
      final name = fileNames.length > i ? fileNames[i] as String : '파일';
      final type = fileTypes.length > i ? fileTypes[i] as String : '';

      if (type.endsWith('_IMAGE')) {
        images.add(url);
      } else {
        files.add(AttachmentFile(name: name, url: url));
      }
    }

    return NoticeDetailModel(
      title: json['data']['title'] ?? '',
      description: json['data']['description'] ?? '',
      postDate: DateTime.parse(json['data']['postDate']),
      isLiked: json['data']['isLiked'] ?? false,
      author: AuthorModel.fromJson(json['data']['author'] ?? {}),
      imageUrls: images,
      attachmentFiles: files,
    );
  }
}
