import 'dart:math';
import 'SubjectData.dart';
import 'AssignmentData.dart';

class FinalPriority {
  List<SubjectData> subjects; // List of subject data
  List<AssignmentData> assignments; // List of assignment data
  List<DateTime> schedules; // List of scheduled dates

  FinalPriority(this.subjects, this.assignments, this.schedules);

  void calcPriority() {
    final DateTime now = DateTime.now(); // Current date and time

    Map<String, double> subjectImportanceMap = {};
    for (var subject in subjects) {
      subjectImportanceMap[subject.subjectName] = subject.importance; // Map subject importance
    }

    // Calculate initial priority for assignments
    for (var assignment in assignments) {
      double assignmentImportance = assignment.importance;
      DateTime assignmentRecDeadline = assignment.recDeadline;
      double subjectImportance = subjectImportanceMap[assignment.subjectName] ?? 0.0;

      if (assignment.deadline != null) {
        double recDeadlineImportance = calcDeadlineImportance(
          assignmentRecDeadline,
          assignment.deadline!,
          now,
        );

        double finalPriority =
            subjectImportance + assignmentImportance + recDeadlineImportance;
        assignment.priority = finalPriority;

        // Debugging output
        print("assignmentImportance: $assignmentImportance");
        print("subjectImportance: $subjectImportance");
        print("recDeadlineImportance: $recDeadlineImportance");
        print("finalPriority: $finalPriority");
      }
    }

    // Apply 0-1 Knapsack algorithm to optimize assignment selection
    int deadlineLimit = _calculateDaysUntilClosestDeadline(now);
    List<List<double>> dp = List.generate(assignments.length + 1,
            (_) => List.filled(deadlineLimit + 1, 0.0)); // DP table for priorities

    for (int i = 1; i <= assignments.length; i++) {
      for (int w = 0; w <= deadlineLimit; w++) {
        int expectedPeriod = assignments[i - 1].expectedPeriod.toInt();
        double priority = assignments[i - 1].priority;

        if (expectedPeriod <= w) {
          dp[i][w] = max(dp[i - 1][w], dp[i - 1][w - expectedPeriod] + priority);
        } else {
          dp[i][w] = dp[i - 1][w];
        }
      }
    }

    // Adjust priorities based on selected assignments
    int remainingCapacity = deadlineLimit;
    for (int i = assignments.length; i > 0 && remainingCapacity > 0; i--) {
      if (dp[i][remainingCapacity] != dp[i - 1][remainingCapacity]) {
        assignments[i - 1].priority += 10; // Boost priority
        remainingCapacity -= assignments[i - 1].expectedPeriod.toInt();
      }
    }
  }

  // Calculate importance based on deadline proximity
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

  // Calculate the number of days until the closest deadline
  int _calculateDaysUntilClosestDeadline(DateTime now) {
    return assignments
        .where((a) => a.deadline != null)
        .map((a) => ((a.deadline!.add(Duration(days: 1))).difference(now).inMinutes / 60).ceil())
        .reduce(min);
  }
}
