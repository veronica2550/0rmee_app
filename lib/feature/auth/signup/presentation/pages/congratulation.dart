import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';

class Congratulation extends StatelessWidget {
  final String name;
  const Congratulation({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/congratulation.png'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.16),
            Heading2SemiBold20(text: '$name님, 가입을 환영해요!'),
            SizedBox(height: 16),
            Headline1Regular18(
              text: '오르미 사용을 위한 준비가 완료되었어요.',
              color: OrmeeColor.gray[70],
            ),
          ],
        ),
      ),
      bottomNavigationBar: OrmeeBottomSheet(
        text: '오르미 시작하기',
        isCheck: true,
        onTap: () => context.go('/login'),
      ),
    );
  }
}
