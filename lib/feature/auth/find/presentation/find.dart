import 'package:flutter/material.dart';
import 'package:ormee_app/feature/auth/find/presentation/widgets/login_tab.dart';
import 'package:ormee_app/feature/auth/find/presentation/widgets/password_tab.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/tab.dart';

class Find extends StatelessWidget {
  const Find({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: OrmeeAppBar(
          isLecture: false,
          isImage: false,
          isDetail: false,
          isPosting: false,
          title: "아이디/비밀번호 찾기",
        ),
        body: Column(
          children: [
            OrmeeTabBar(
              tabs: [
                OrmeeTab(text: "아이디 찾기"),
                OrmeeTab(text: "비밀번호 찾기"),
              ],
            ),
            Expanded(
              child: TabBarView(children: [LoginTab(context), PasswordTab()]),
            ),
          ],
        ),
      ),
    );
  }
}
