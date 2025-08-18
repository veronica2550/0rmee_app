import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/core/events/quiz_events.dart';
import 'package:ormee_app/feature/quiz/detail/data/model.dart';
import 'package:ormee_app/feature/quiz/take/presentation/controller.dart';
import 'package:ormee_app/feature/quiz/widgets/OrmeeTextField2.dart';
import 'package:ormee_app/feature/quiz/widgets/single_choice.dart';
import 'package:ormee_app/feature/quiz/widgets/submit_confirm_dialog.dart';
import 'package:ormee_app/feature/quiz/widgets/time_over_dialog.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart' show OrmeeAppBar;
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class Quiz extends StatelessWidget {
  final QuizController controller = Get.put(QuizController());

  final int quizId;
  final String quizTitle;

  final RxBool _timeUpHandled = false.obs;

  Quiz({super.key, required this.quizId, required this.quizTitle});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchQuiz(quizId).then((_) {
        // 퀴즈 데이터가 로드된 후 답안 초기화 (기존 방식과 동일)
        if (controller.problems.isNotEmpty) {
          // 모든 문제에 대해 빈 답안으로 초기화
          for (var problem in controller.problems) {
            controller.saveAnswer(problem.id, "");
          }
        }
        // 타이머는 fetchQuiz 내부에서 자동으로 시작
      });
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: OrmeeColor.white,
      appBar: OrmeeAppBar(
        title: quizTitle,
        isLecture: false,
        isImage: false,
        isDetail: false,
        isPosting: false,
      ),
      body: Stack(
        children: [
          // 메인 컨텐츠 - 로딩/에러 상태만 Obx로 감시
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.error.value != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('오류: ${controller.error.value}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.fetchQuiz(quizId),
                      child: Text('다시 시도'),
                    ),
                  ],
                ),
              );
            }

            if (controller.problems.isEmpty) {
              return Center(child: Text('퀴즈 정보가 없습니다.'));
            }

            return SingleChildScrollView(child: buildQuizContent());
          }),

          // 타이머 - 별도 Obx로 분리
          buildTimerWidget(),

          // 시간 종료 다이얼로그 - 별도 Obx로 분리
          buildTimeUpDialog(context),
        ],
      ),
      bottomSheet: Obx(() {
        final loading = controller.isLoading.value;
        final canSubmit = _allAnswered() && !loading;

        return OrmeeBottomSheet(
          text: loading ? '제출 중...' : '제출하기',
          isCheck: canSubmit && !loading,
          onTap: () async => _handleSubmitQuiz(context),
        );
      }),
    );
  }

  Widget buildQuizContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: EdgeInsets.only(bottom: 89.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.problems.length,
            itemBuilder: (context, index) {
              final problem = controller.problems[index];

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: OrmeeColor.gray[20]!),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label1Regular14(text: "${index + 1}. "),
                        Expanded(child: Label1Regular14(text: problem.content)),
                      ],
                    ),
                    SizedBox(height: 15),

                    // 문제 타입에 따른 답안 입력 위젯
                    if (problem.type == ProblemType.choice) // 선택형 퀴즈
                      OrmeeSingleChoiceList(
                        items: problem.items
                            .where((item) => item.isNotEmpty)
                            .toList(),
                        selectedIndex: _getSelectedChoiceIndex(problem),
                        onSelectionChanged: (selectedIndex) {
                          // 선택된 항목을 저장
                          controller.saveAnswer(
                            problem.id,
                            problem.items[selectedIndex],
                          );
                        },
                      )
                    else if (problem.type == ProblemType.essay) // 에세이형 퀴즈
                      // 기존 방식 적용: 빈 컨트롤러로 시작
                      OrmeeTextField2(
                        hintText: '답을 입력해주세요.',
                        controller: TextEditingController(), // 빈 컨트롤러
                        textInputAction: TextInputAction.done,
                        onSelectionUnfocused: (value) {
                          // 포커스 해제시에만 저장 (기존 방식)
                          controller.saveAnswer(problem.id, value);
                        },
                      ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 13);
            },
          ),
        ],
      ),
    );
  }

  Widget buildTimerWidget() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 90,
      child: Obx(() {
        if (controller.remainingTime.value.isEmpty) {
          return SizedBox.shrink();
        }

        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0x8019191D),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Body1RegularReading16(
              text: controller.remainingTime.value,
              color: OrmeeColor.white,
            ),
          ),
        );
      }),
    );
  }

  Widget buildTimeUpDialog(BuildContext context) {
    return Obx(() {
      if (controller.isTimeUp.value && !_timeUpHandled.value) {
        _timeUpHandled.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _handleTimeUp(context);
        });
      }
      return const SizedBox.shrink();
    });
  }

  Future<void> _handleTimeUp(BuildContext context) async {
    if (controller.isLoading.value) return;

    FocusScope.of(context).unfocus();

    bool submitted = false;
    try {
      await controller.submitQuiz(quizId);
      submitted = true;
    } catch (e) {
      _timeUpHandled.value = false;
      OrmeeToast.show(context, '제출 중 오류가 발생했어요. 다시 시도할게요.', true);
    }

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => submitted
            ? customDialog(context)
            : TimeOverDialog(
                onConfirm: () async {
                  GoRouter.of(
                    context,
                  ).routerDelegate.navigatorKey.currentState?.popUntil(
                    (route) => route.settings.name == '/quiz/detail/$quizId',
                  );
                  GlobalEventBus().fire(QuizDetailRefreshEvent(quizId));
                },
              ),
      );
    }
  }

  // 선택형 문제의 현재 선택된 인덱스 반환
  int? _getSelectedChoiceIndex(Problem problem) {
    final answer = controller.getAnswer(problem.id);
    if (answer == null || answer.isEmpty) return null;
    return int.tryParse(answer);
  }

  // 퀴즈 제출 처리
  Future<void> _handleSubmitQuiz(BuildContext context) async {
    // 중복 제출/타임업 가드
    if (controller.isLoading.value) return;
    if (controller.isTimeUp.value) {
      OrmeeToast.show(context, '시간이 종료되어 자동 제출을 진행 중이에요.', true);
      return;
    }
    if (!_allAnswered()) {
      OrmeeToast.show(context, '모든 문제에 응답해주세요.', true);
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SubmitConfirmDialog(
        onConfirm: () {
          Navigator.of(context).pop(true);
        },
      ),
    );

    if (confirmed != true) return;

    FocusScope.of(context).unfocus();

    try {
      await controller.submitQuiz(quizId);
    } catch (e) {
      OrmeeToast.show(context, '제출 중 오류가 발생했어요. 다시 시도해 주세요.', true);
      return;
    }

    if (!context.mounted) return;

    OrmeeToast.show(context, '퀴즈 응시 완료', false);
    // 상세로 복귀 + 새로고침 이벤트
    GoRouter.of(context).routerDelegate.navigatorKey.currentState?.popUntil(
      (route) => route.settings.name == '/quiz/detail/$quizId',
    );
    GlobalEventBus().fire(QuizDetailRefreshEvent(quizId));
  }

  Widget customDialog(BuildContext context) {
    return TimeOverDialog(
      onConfirm: () async {
        GoRouter.of(context).routerDelegate.navigatorKey.currentState?.popUntil(
          (route) => route.settings.name == '/quiz/detail/$quizId',
        );
        GlobalEventBus().fire(QuizDetailRefreshEvent(quizId));
      },
    );
  }

  bool _allAnswered() {
    for (final p in controller.problems) {
      final a = controller.getAnswer(p.id);
      if (a == null) return false;
      if (a is String && a.trim().isEmpty) return false;
    }
    return true;
  }
}
