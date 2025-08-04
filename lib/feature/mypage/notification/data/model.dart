class NotificationSettingModel {
  final bool quizRegister;
  final bool quizRemind;
  final bool quizDeadline;
  final bool homeworkRegister;
  final bool homeworkRemind;
  final bool homeworkDeadline;
  final bool memo;
  final bool question;
  final bool notice;
  final bool event;

  NotificationSettingModel({
    required this.quizRegister,
    required this.quizRemind,
    required this.quizDeadline,
    required this.homeworkRegister,
    required this.homeworkRemind,
    required this.homeworkDeadline,
    required this.memo,
    required this.question,
    required this.notice,
    required this.event,
  });

  factory NotificationSettingModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return NotificationSettingModel(
      quizRegister: data['quizRegister'] ?? false,
      quizRemind: data['quizRemind'] ?? false,
      quizDeadline: data['quizDeadline'] ?? false,
      homeworkRegister: data['homeworkRegister'] ?? false,
      homeworkRemind: data['homeworkRemind'] ?? false,
      homeworkDeadline: data['homeworkDeadline'] ?? false,
      memo: data['memo'] ?? false,
      question: data['question'] ?? false,
      notice: data['notice'] ?? false,
      event: data['event'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['quizRegister'] = quizRegister;
    json['quizRemind'] = quizRemind;
    json['quizDeadline'] = quizDeadline;
    json['homeworkRegister'] = homeworkRegister;
    json['homeworkRemind'] = homeworkRemind;
    json['homeworkDeadline'] = homeworkDeadline;
    json['memo'] = memo;
    json['question'] = question;
    json['notice'] = notice;
    json['event'] = event;

    return json;
  }
}
