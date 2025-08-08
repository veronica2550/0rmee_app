import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

// 사용법:
// OrmeeToast.show(context, "message", true);
// 이렇게 호출

class OrmeeToast {
  static void show(BuildContext context, String message, bool isError) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.1, // 화면 하단 20% 위치
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
              color: isError ? OrmeeColor.systemRed : OrmeeColor.systemGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SvgPicture.asset(isError? 'assets/icons/alert.svg' : 'assets/icons/complete.svg'),
                Headline1SemiBold18(
                  text: message,
                  color: OrmeeColor.gray[90],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // 일정 시간 후 제거
    Future.delayed(Duration(seconds: 2)).then((_) => overlayEntry.remove());
  }
}