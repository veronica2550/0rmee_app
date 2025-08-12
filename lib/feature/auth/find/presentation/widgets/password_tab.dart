import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';

class PasswordTab extends StatelessWidget {
  const PasswordTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Body2SemiBoldNormal14(text: "비밀번호를 찾으려면 본인인증이 필요해요."),
      ),
      bottomSheet: OrmeeBottomSheet(
        text: "본인인증 하기",
        isCheck: true,
        onTap: () => context.push(
          '/find/password',
          extra: {'username': "김다라", 'phoneNumber': "010-4444-4444"},
        ),
      ),
    );
  }
}
