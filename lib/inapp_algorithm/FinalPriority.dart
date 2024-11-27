import 'dart:math';
import 'SubjectData.dart';
import 'AssignmentData.dart';

class FinalPriority {
  List<SubjectData> subjects;
  List<AssignmentData> assignments;
  List<DateTime> schedules;

  FinalPriority(this.subjects, this.assignments, this.schedules);

  void calcPriority() {
    final DateTime now = DateTime.now();

    Map<String, double> subjectImportanceMap = {};
    for (var subject in subjects) {
      subjectImportanceMap[subject.subjectName] = subject.importance;
    }

    // 우선 기존 우선순위 산출
    for (var assignment in assignments) {
      double assignmentImportance = assignment.importance;
      DateTime assignmentRecDeadline = assignment.recDeadline;
      double subjectImportance = subjectImportanceMap[assignment.subjectName] ?? 0.0;

      if (assignment.deadline != null) {
        double recDeadlineImportance = calcDeadlineImportance(
            assignmentRecDeadline, assignment.deadline!, now);

        double finalPriority =
            subjectImportance + assignmentImportance + recDeadlineImportance;
        assignment.priority = finalPriority;

        // 디버깅 출력
        print("assignmentImportance: $assignmentImportance");
        print("subjectImportance: $subjectImportance");
        print("recDeadlineImportance: $recDeadlineImportance");
        print("finalPriority: $finalPriority");
      }
    }

    // 0-1 Knapsack 문제 적용: 데드라인과 예상 소요 시간을 고려해 선택 조정
    int deadlineLimit = _calculateDaysUntilClosestDeadline(now);
    List<List<double>> dp = List.generate(assignments.length + 1,
        (_) => List.filled(deadlineLimit + 1, 0.0)); // double 타입으로 dp 테이블 생성

    for (int i = 1; i <= assignments.length; i++) {
      for (int w = 0; w <= deadlineLimit; w++) {
        int expectedPeriod = assignments[i - 1].expectedPeriod.toInt(); // double을 int로 변환
        double priority = assignments[i - 1].priority;

        if (expectedPeriod <= w) {
          dp[i][w] = max(dp[i - 1][w], dp[i - 1][w - expectedPeriod] + priority);
        } else {
          dp[i][w] = dp[i - 1][w];
        }
      }
    }

    // 선택된 과제를 기반으로 우선순위 조정
    int remainingCapacity = deadlineLimit;
    for (int i = assignments.length; i > 0 && remainingCapacity > 0; i--) {
      if (dp[i][remainingCapacity] != dp[i - 1][remainingCapacity]) {
        assignments[i - 1].priority += 10; // 우선순위 재조정
        remainingCapacity -= assignments[i - 1].expectedPeriod.toInt(); // double을 int로 변환
      }
    }
  }

  double calcDeadlineImportance(
      DateTime recDeadline, DateTime deadline, DateTime currentDate) {
    double baseImportance = 2.5;

    int daysUntilDeadline = deadline.difference(currentDate).inDays;
    if (daysUntilDeadline <= 3) {
      double scalingFactor = 3.0;
      baseImportance += baseImportance * (1 - (daysUntilDeadline / 3)) * scalingFactor;
    } else {
      double totalDays = deadline.difference(recDeadline).inDays.toDouble();
      if (totalDays > 0) {
        baseImportance += (baseImportance * (1 - (daysUntilDeadline / totalDays)));
      }
    }

    return baseImportance < 2.5 ? 2.5 : baseImportance;
  }

  int _calculateDaysUntilClosestDeadline(DateTime now) {
    return assignments
        .where((a) => a.deadline != null)
        .map((a) => a.deadline!.difference(now).inDays)
        .reduce(min);
  }
}