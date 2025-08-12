import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/auth/find/bloc/id/id_bloc.dart';
import 'package:ormee_app/feature/auth/find/bloc/pw/pw_bloc.dart';
import 'package:ormee_app/feature/auth/find/data/id/remote_datasource.dart';
import 'package:ormee_app/feature/auth/find/data/id/repository.dart';
import 'package:ormee_app/feature/auth/find/data/pw/remote_datasource.dart';
import 'package:ormee_app/feature/auth/find/data/pw/repository.dart';
import 'package:ormee_app/feature/auth/find/presentation/widgets/login_tab.dart';
import 'package:ormee_app/feature/auth/find/presentation/widgets/password_tab.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/tab.dart';
import 'package:http/http.dart' as http;

class Find extends StatelessWidget {
  const Find({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FindIdBloc(
            repository: FindIdRepository(FindIdRemoteDataSource(http.Client())),
          ),
        ),
        BlocProvider(
          create: (context) => FindPasswordBloc(
            repository: FindPasswordRepository(
              FindPasswordRemoteDataSource(http.Client()),
            ),
          ),
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: const OrmeeAppBar(
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
              const Expanded(
                child: TabBarView(children: [LoginTab(), PasswordTab()]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
