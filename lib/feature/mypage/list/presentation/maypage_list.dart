import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_bloc.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_event.dart';
import 'package:ormee_app/feature/mypage/info/bloc/student_info_state.dart';
import 'package:ormee_app/feature/mypage/info/data/remote_datasource.dart';
import 'package:ormee_app/feature/mypage/info/data/repository.dart';
import 'package:ormee_app/feature/mypage/list/bloc/mypage_list_bloc.dart';
import 'package:ormee_app/feature/mypage/list/bloc/mypage_list_event.dart';
import 'package:ormee_app/feature/mypage/list/bloc/mypage_list_state.dart';
import 'package:ormee_app/feature/mypage/list/data/repository.dart';
import 'package:ormee_app/feature/mypage/list/data/remote_datasource.dart';
import 'package:ormee_app/feature/mypage/list/presentation/widgets/appbar.dart';
import 'package:ormee_app/feature/mypage/list/presentation/widgets/mypage_card.dart';
import 'package:ormee_app/feature/mypage/list/presentation/widgets/password_modal.dart';
import 'package:ormee_app/feature/mypage/list/presentation/widgets/profile_card.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/widgets/dialog.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyPageListBloc(
        MyPageProfileRepository(MyPageProfileRemoteDatasource()),
      )..add(FetchMyPageList()),
      child: BlocConsumer<MyPageListBloc, MyPageListState>(
        listener: (context, state) {
          if (state is MyPageListError) {
            OrmeeToast.show(context, state.message, true);
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is MyPageListLoaded) {
            final name = state.name;
            return Scaffold(
              appBar: MyPageAppBar(title: '마이페이지'),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      ProfileCard(
                        name: name,
                        onTap: () async {
                          final submitting = ValueNotifier<bool>(false); // ← 추가

                          final verified = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            useRootNavigator: true,
                            builder: (dialogContext) {
                              return BlocProvider(
                                create: (_) => StudentInfoBloc(
                                  StudentInfoRepository(
                                    StudentInfoRemoteDataSource(),
                                  ),
                                ),
                                child:
                                    BlocConsumer<
                                      StudentInfoBloc,
                                      StudentInfoState
                                    >(
                                      listener: (ctx, state) {
                                        if (state is PasswordVerified) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                Navigator.of(
                                                  dialogContext,
                                                  rootNavigator: true,
                                                ).pop(true);
                                              });
                                        } else if (state
                                            is PasswordVerifyFailed) {
                                          submitting.value = false;
                                          OrmeeToast.show(
                                            dialogContext,
                                            state.message,
                                            true,
                                          );
                                        }
                                      },
                                      builder: (ctx, state) {
                                        return PasswordModal(
                                          titleText: "회원정보 수정",
                                          submitting: submitting,
                                          onConfirm: (pw) => ctx
                                              .read<StudentInfoBloc>()
                                              .add(VerifyPassword(pw)),
                                        );
                                      },
                                    ),
                              );
                            },
                          );

                          if (verified == true && context.mounted) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (context.mounted)
                                GoRouter.of(context).push('/mypage/info');
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      MyPageCard(
                        icon: 'assets/icons/list.svg',
                        title: '수강내역',
                        onTap: () {
                          context.push('/mypage/history');
                        },
                      ),
                      MyPageCard(
                        icon: 'assets/icons/notification_empty.svg',
                        title: '알림설정',
                        onTap: () {
                          context.push('/mypage/notification');
                        },
                      ),
                      Divider(
                        height: 16,
                        thickness: 1,
                        color: OrmeeColor.gray[20],
                      ),
                      // MyPageCard(
                      //   icon: 'assets/icons/help.svg',
                      //   title: 'FAQ',
                      //   onTap: () {
                      //     // FAQ 화면 라우팅
                      //   },
                      // ),
                      MyPageCard(
                        icon: 'assets/icons/hand.svg',
                        title: '이용약관',
                        onTap: () {
                          // 이용약관 화면 라우탱
                        },
                      ),
                      MyPageCard(
                        icon: 'assets/icons/verified.svg',
                        title: '개인정보처리방침',
                        onTap: () {
                          // 개인정보처리방침 라우팅
                        },
                      ),
                      MyPageCard(
                        icon: 'assets/icons/info.svg',
                        title: '버전',
                        onTap: () {
                          context.push('/mypage/version');
                        },
                      ),
                      Divider(
                        height: 16,
                        thickness: 1,
                        color: OrmeeColor.gray[20],
                      ),
                      MyPageCard(
                        icon: 'assets/icons/logout.svg',
                        title: '로그아웃',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return OrmeeDialog(
                                titleText: '로그아웃 하시겠어요?',
                                icon: 'assets/icons/logout.svg',
                                onConfirm: () {
                                  ApiClient.instance.logout();
                                  context.pop();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
