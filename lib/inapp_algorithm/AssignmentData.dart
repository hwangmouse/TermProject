import 'CalenderData.dart';

class AssignmentData {
  String subjectName; // Subject name associated with the assignment
  String assignmentName; // Name of the assignment
  double currentRatio; // Ratio of the assignment in the subject grading
  double latePenalty; // Penalty applied for late submission
  double isAlter; // Indicator for midterm/final (0 = none, 1 = midterm, 2 = final)
  DateTime deadline; // Submission deadline
  DateTime recDeadline; // Recommended deadline
  double expectedPeriod; // Expected time to complete the assignment (in days)
  double importance; // Calculated importance of the assignment
  double priority; // Priority score for scheduling
  bool isCompleted; // Completion status of the assignment

  AssignmentData({
    required this.subjectName,
    required this.assignmentName,
    required this.currentRatio,
    required this.latePenalty,
    required this.isAlter,
    required this.deadline,
    required this.expectedPeriod,
    this.importance = 0.0, // Default importance
    this.priority = 0.0, // Default priority
    this.isCompleted = false, // Default to not completed
  }) : recDeadline = deadline; // Initialize recommended deadline as the deadline

  // Calculates the importance of the assignment
  void calculateImportance(double subjectRatio, double alterVal) {
    double currentAssignmentRatio = currentRatio * subjectRatio * 10;
    double penalty = 1.0 - latePenalty;

    if (isAlter == 1 || isAlter == 2) { // Adjust calculations for midterm/final
      currentAssignmentRatio = 0.0;
      penalty = alterVal * 10;
    }

    importance = currentAssignmentRatio + penalty;

    // Debugging output
    print("subjectRatio: $subjectRatio");
    print("currentRatio: $currentRatio");
    print("latePenalty: $latePenalty");
    print("currentAssignmentRatio: $currentAssignmentRatio");
    print("penalty: $penalty");
    print("importance: $importance");
  }

  // Calculates a recommended deadline to avoid scheduling conflicts
  void calculateRecDeadline(List<CalenderData> schedules) {
    DateTime calculatedRecDeadline = deadline;

    for (var schedule in schedules) {
      DateTime scheduleDate = schedule.getScheduleDate();

      // Adjust if the schedule and deadline overlap
      if (calculatedRecDeadline.isAtSameMomentAs(scheduleDate)) {
        calculatedRecDeadline = calculatedRecDeadline.subtract(Duration(days: 1));
      }
      // Adjust if the schedule affects the expected period
      else if (deadline.difference(scheduleDate).inHours < expectedPeriod * 24) {
        calculatedRecDeadline = scheduleDate;
      }
    }

    recDeadline = calculatedRecDeadline;
  }

  // Converts the object to a JSON representation
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
      'isCompleted': isCompleted, // Include completion status in JSON
    };
  }

  // Creates an object from a JSON representation
  factory AssignmentData.fromJson(Map<String, dynamic> json) {
    return AssignmentData(
      subjectName: json['subjectName'],
      assignmentName: json['assignmentName'],
      currentRatio: (json['currentRatio'] as num).toDouble(),
      latePenalty: (json['latePenalty'] as num).toDouble(),
      isAlter: (json['isAlter'] as num).toDouble(),
      deadline: DateTime.parse(json['deadline']),
      expectedPeriod: (json['expectedPeriod'] as num).toDouble(),
      importance: (json['importance'] as num?)?.toDouble() ?? 0.0,
      priority: (json['priority'] as num?)?.toDouble() ?? 0.0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
