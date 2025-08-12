import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';

class LoginResult extends StatelessWidget {
  final String name;
  final String foundId;

  const LoginResult({super.key, required this.name, required this.foundId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrmeeAppBar(
        isLecture: false,
        isImage: false,
        isDetail: false,
        isPosting: false,
        title: "아이디/비밀번호 찾기",
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Heading2SemiBold20(text: "$name님의 아이디는"),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Heading2SemiBold20(text: foundId, color: OrmeeColor.purple[50]),
                const Heading2SemiBold20(text: " 입니다."),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          ],
        ),
      ),
      bottomSheet: OrmeeBottomSheet(
        text: "확인",
        isCheck: true,
        onTap: () => context.go('/login'),
      ),
    );
  }
}
