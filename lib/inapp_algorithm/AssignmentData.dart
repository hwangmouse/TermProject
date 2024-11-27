import 'CalenderData.dart';

class AssignmentData {
  String subjectName;
  String assignmentName;
  double currentRatio;
  double latePenalty;
  double isAlter; // 0 = none, 1 = midterm, 2 = final
  DateTime deadline;
  DateTime recDeadline;
  double expectedPeriod;
  double importance;
  double priority;
  bool isCompleted; // 완료 상태 추가

  AssignmentData({
    required this.subjectName,
    required this.assignmentName,
    required this.currentRatio,
    required this.latePenalty,
    required this.isAlter,
    required this.deadline,
    required this.expectedPeriod,
    this.importance = 0.0,
    this.priority = 0.0,
    this.isCompleted = false, // 기본값: 미완료
  }) : recDeadline = deadline;

  void calculateImportance(double subjectRatio, double alterVal) {
    double currentAssignmentRatio = currentRatio * subjectRatio * 10;
    double penalty = 1.0 - latePenalty;

    if (isAlter == 1 || isAlter == 2) {
      currentAssignmentRatio = 0.0;
      penalty = alterVal * 10;
    }

    importance = currentAssignmentRatio + penalty;

    // 디버깅 출력
    print("subjectRatio: $subjectRatio");
    print("currentRatio: $currentRatio");
    print("latePenalty: $latePenalty");
    print("currentAssignmentRatio: $currentAssignmentRatio");
    print("penalty: $penalty");
    print("importance: $importance");
  }

  void calculateRecDeadline(List<CalenderData> schedules) {
    DateTime calculatedRecDeadline = deadline;

    for (var schedule in schedules) {
      DateTime scheduleDate = schedule.getScheduleDate();

      // If the schedule and deadline overlap, set recDeadline to one day in advance.
      if (calculatedRecDeadline.isAtSameMomentAs(scheduleDate)) {
        calculatedRecDeadline = calculatedRecDeadline.subtract(Duration(days: 1));
      }
      // If the schedule is behind (deadline - expectedPeriod), set recDeadline to that schedule date.
      else if (deadline.difference(scheduleDate).inHours < expectedPeriod * 24) {
        calculatedRecDeadline = scheduleDate;
      }
    }

    recDeadline = calculatedRecDeadline;
  }



  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'assignmentName': assignmentName,
      'currentRatio': currentRatio,
      'latePenalty': latePenalty,
      'isAlter': isAlter,
      'deadline': deadline.toIso8601String(),
      'recDeadline': recDeadline.toIso8601String(),
      'expectedPeriod': expectedPeriod,
      'importance': importance,
      'priority': priority,
      'isCompleted': isCompleted, // JSON에 포함
    };
  }

  // JSON에서 객체 생성
  factory AssignmentData.fromJson(Map<String, dynamic> json) {
    return AssignmentData(
      subjectName: json['subjectName'],
      assignmentName: json['assignmentName'],
      currentRatio: (json['currentRatio'] as num).toDouble(), // int 또는 double 모두 처리
      latePenalty: (json['latePenalty'] as num).toDouble(), // int 또는 double 모두 처리
      isAlter: (json['isAlter'] as num).toDouble(), // int 또는 double 모두 처리
      deadline: DateTime.parse(json['deadline']),
      expectedPeriod: (json['expectedPeriod'] as num).toDouble(), // int 또는 double 모두 처리
      importance: (json['importance'] as num?)?.toDouble() ?? 0.0,
      priority: (json['priority'] as num?)?.toDouble() ?? 0.0,
      isCompleted: json['isCompleted'] ?? false, // 기본값 처리
    );
  }
}
