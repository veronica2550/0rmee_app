import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class NotificationSettingGroup extends StatelessWidget {
  final String title;
  final bool register;
  final bool remind;
  final bool deadline;
  final VoidCallback? registerOnTap;
  final VoidCallback? remindOnTap;
  final VoidCallback? deadlineOnTap;

  const NotificationSettingGroup({
    super.key,
    required this.title,
    required this.register,
    required this.remind,
    required this.deadline,
    this.registerOnTap,
    this.remindOnTap,
    this.deadlineOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: OrmeeColor.gray[10],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Headline2SemiBold16(text: title, color: OrmeeColor.gray[90]),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Body2SemiBoldNormal14(text: '등록', color: OrmeeColor.gray[60]),
                GestureDetector(
                  onTap: registerOnTap,
                  child: Body2SemiBoldNormal14(
                    text: register ? "ON" : "OFF",
                    color: register
                        ? OrmeeColor.purple[50]
                        : OrmeeColor.gray[50],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Body2SemiBoldNormal14(text: '리마인드', color: OrmeeColor.gray[60]),
                GestureDetector(
                  onTap: remindOnTap,
                  child: Body2SemiBoldNormal14(
                    text: remind ? "ON" : "OFF",
                    color: remind ? OrmeeColor.purple[50] : OrmeeColor.gray[50],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Body2SemiBoldNormal14(text: '마감', color: OrmeeColor.gray[60]),
                GestureDetector(
                  onTap: deadlineOnTap,
                  child: Body2SemiBoldNormal14(
                    text: deadline ? "ON" : "OFF",
                    color: deadline
                        ? OrmeeColor.purple[50]
                        : OrmeeColor.gray[50],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
