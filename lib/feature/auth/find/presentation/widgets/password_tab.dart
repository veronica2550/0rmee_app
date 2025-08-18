import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/button.dart';

class PasswordTab extends StatelessWidget {
  const PasswordTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Body2RegularNormal14(text: "비밀번호를 찾으려면 본인인증이 필요해요."),
            SizedBox(height: 16),
            OrmeeButton(
              text: '본인인증 하기',
              isTrue: true,
              // trueAction: () {
              //   // 추후 본인 인증 연결
              //   context.push(
              //     '/find/password',
              //     extra: {
              //       'username': "student3",
              //       'phoneNumber': "010-4444-4444",
              //     },
              //   );
              // },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          ],
        ),
      ),
    );
  }
}
