import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/mypage/notification/presentation/widgets/notification_setting_card.dart';
import 'package:ormee_app/feature/mypage/notification/presentation/widgets/notification_setting_group.dart';
import 'package:ormee_app/feature/mypage/notification/presentation/widgets/toggle_button.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/toast.dart';
import 'package:ormee_app/feature/mypage/notification/bloc/notification_setting_bloc.dart';
import 'package:ormee_app/feature/mypage/notification/bloc/notification_setting_event.dart';
import 'package:ormee_app/feature/mypage/notification/bloc/notification_setting_state.dart';
import 'package:ormee_app/feature/mypage/notification/data/remote_datasource.dart';
import 'package:ormee_app/feature/mypage/notification/data/repository.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationSettingBloc(
        NotificationSettingRepository(NotificationSettingRemoteDataSource()),
      )..add(FetchNotificationSetting()),
      child: BlocConsumer<NotificationSettingBloc, NotificationSettingState>(
        listener: (context, state) {
          if (state is NotificationSettingError) {
            OrmeeToast.show(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is NotificationSettingLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is NotificationSettingLoaded) {
            final settings = state.settings;

            final isOn = [
              settings.quizRegister,
              settings.quizRemind,
              settings.quizDeadline,
              settings.homeworkRegister,
              settings.homeworkRemind,
              settings.homeworkDeadline,
              settings.memo,
              settings.question,
              settings.notice,
              settings.event,
            ].every((e) => e);

            return Scaffold(
              appBar: OrmeeAppBar(
                title: '알림설정',
                isLecture: false,
                isImage: false,
                isDetail: false,
                isPosting: false,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Headline2SemiBold16(
                          text: '전체 알림',
                          color: OrmeeColor.gray[90],
                        ),
                        ToggleButton(
                          isOn: isOn,
                          onChanged: (value) {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(
                                  quizRegister: value,
                                  quizRemind: value,
                                  quizDeadline: value,
                                  homeworkRegister: value,
                                  homeworkRemind: value,
                                  homeworkDeadline: value,
                                  memo: value,
                                  question: value,
                                  notice: value,
                                  event: value,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 8, thickness: 8, color: OrmeeColor.gray[10]),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        NotificationSettingGroup(
                          title: "퀴즈 알림",
                          register: settings.quizRegister,
                          remind: settings.quizRemind,
                          deadline: settings.quizDeadline,
                          registerOnTap: () {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(
                                  quizRegister: !settings.quizRegister,
                                ),
                              ),
                            );
                          },
                          remindOnTap: () {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(
                                  quizRemind: !settings.quizRemind,
                                ),
                              ),
                            );
                          },
                          deadlineOnTap: () {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(
                                  quizDeadline: !settings.quizDeadline,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 14),
                        NotificationSettingGroup(
                          title: "숙제 알림",
                          register: settings.homeworkRegister,
                          remind: settings.homeworkRemind,
                          deadline: settings.homeworkDeadline,
                          registerOnTap: () {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(
                                  homeworkRegister: !settings.homeworkRegister,
                                ),
                              ),
                            );
                          },
                          remindOnTap: () {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(
                                  homeworkRemind: !settings.homeworkRemind,
                                ),
                              ),
                            );
                          },
                          deadlineOnTap: () {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(
                                  homeworkDeadline: !settings.homeworkDeadline,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 14),
                        NotificationSettingCard(
                          title: "쪽지 알림",
                          isOn: settings.memo,
                          onTap: () {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(memo: !settings.memo),
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: 28,
                          thickness: 1,
                          color: OrmeeColor.gray[20],
                        ),
                        NotificationSettingCard(
                          title: "질문 알림",
                          isOn: settings.question,
                          onTap: () {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(question: !settings.question),
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: 28,
                          thickness: 1,
                          color: OrmeeColor.gray[20],
                        ),
                        NotificationSettingCard(
                          title: "공지 알림",
                          isOn: settings.notice,
                          onTap: () {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(notice: !settings.notice),
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: 28,
                          thickness: 1,
                          color: OrmeeColor.gray[20],
                        ),
                        NotificationSettingCard(
                          title: "마케팅/이벤트 알림",
                          isOn: settings.event,
                          onTap: () {
                            context.read<NotificationSettingBloc>().add(
                              UpdateNotificationSetting(
                                settings.copyWith(event: !settings.event),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
