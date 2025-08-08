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
    final maxWidth = MediaQuery.of(context).size.width * 0.9;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.1,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: isError ? OrmeeColor.systemRed : OrmeeColor.systemGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      isError ? 'assets/icons/alert.svg' : 'assets/icons/complete.svg',
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Headline1SemiBold18(
                        text: message,
                        color: OrmeeColor.gray[90],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2)).then((_) => overlayEntry.remove());
  }
}