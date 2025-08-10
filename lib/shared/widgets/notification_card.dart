import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/notification/data/repository.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/profile.dart';

class NotificationCard extends StatelessWidget {
  final String? profile;
  final String? type;
  final int id;
  final int parentId;
  final String headline;
  final String title;
  final String body;
  final String time;
  final bool read;
  //final VoidCallback? onDelete; // 삭제 콜백 추가
  final VoidCallback? onReadStatusChanged;

  const NotificationCard({
    super.key,
    this.profile,
    required this.type,
    required this.id,
    required this.parentId,
    required this.headline,
    required this.title,
    required this.body,
    required this.time,
    required this.read,
    //this.onDelete,
    this.onReadStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final repository = NotificationRepository();
    return Dismissible(
      key: Key('notification_${id}'), // 고유한 키 필요
      direction: DismissDirection.endToStart, // 오른쪽에서 왼쪽으로만
      confirmDismiss: (direction) async {
        // confirmDismiss를 true로 반환하여 dismiss 허용
        return true;

        // 삭제 확인 다이얼로그 (선택사항)
        // return await showDialog<bool>(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('알림 삭제'),
        //     content: Text('이 알림을 삭제하시겠습니까?'),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.of(context).pop(false),
        //         child: Text('취소'),
        //       ),
        //       TextButton(
        //         onPressed: () => Navigator.of(context).pop(true),
        //         child: Text('삭제'),
        //       ),
        //     ],
        //   ),
        // );
      },
      onDismissed: (direction) async {
        // 삭제 API 호출
        // onDelete?.call();
        bool isDeleted = await repository.deleteNotification(id);
        if (isDeleted) {
          // 삭제 성공 처리
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: OrmeeColor.gray[30],
          //borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: () async {
          // 읽음 처리
          bool isRead = await repository.readNotification(id);
          if (isRead) {
            onReadStatusChanged?.call();
          }

          // type에 따라 라우팅
          if (!context.mounted) return;

          switch (type) {
            case "공지":
              context.push('/notice/detail/$parentId');
              break;
            case "퀴즈":
              context.push('/quiz/detail/$parentId');
              break;
            case "숙제":
              context.push('/homework/detail/$parentId');
              break;
            case "질문":
              context.push('/question/detail/$parentId');
              break;
            default:
            // 정의되지 않은 type에 대한 fallback 처리 (예: 에러 로그 or 무시)
              break;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Profile(profileImageUrl: profile, opacity: read ? 0.5 : 1),
              SizedBox(width: 18),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Headline2Bold16(
                          text: headline,
                          color: OrmeeColor.gray[read ? 50 : 800],
                        ),
                        Caption2Semibold10(
                          text: time,
                          color: OrmeeColor.gray[40],
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Label1Semibold14(
                      text: title,
                      color: OrmeeColor.gray[read ? 50 : 75],
                    ),
                    Body2RegularNormal14(
                      text: body,
                      color: OrmeeColor.gray[read ? 50 : 75],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
