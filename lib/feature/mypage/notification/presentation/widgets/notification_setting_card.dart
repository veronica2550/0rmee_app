import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class NotificationSettingCard extends StatelessWidget {
  final String title;
  final bool isOn;
  final VoidCallback? onTap;

  const NotificationSettingCard({
    super.key,
    required this.title,
    required this.isOn,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Body2SemiBoldNormal14(text: title, color: OrmeeColor.gray[60]),
          GestureDetector(
            onTap: onTap,
            child: Body2SemiBoldNormal14(
              text: isOn ? "ON" : "OFF",
              color: isOn ? OrmeeColor.purple[50] : OrmeeColor.gray[50],
            ),
          ),
        ],
      ),
    );
  }
}
