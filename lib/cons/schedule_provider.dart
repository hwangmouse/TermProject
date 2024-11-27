import 'package:flutter/material.dart';

class ScheduleProvider with ChangeNotifier {
  List<Map<String, dynamic>> _schedules = [];

  List<Map<String, dynamic>> get schedules => _schedules;

  void addSchedule(Map<String, dynamic> schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  void toggleComplete(int index) {
    _schedules[index]['isCompleted'] = !_schedules[index]['isCompleted'];
    notifyListeners();
  }

  void updateSchedule(int index, Map<String, dynamic> updatedSchedule) {
    _schedules[index] = updatedSchedule;
    notifyListeners();
  }

  void removeSchedule(int index) {
    _schedules.removeAt(index); // 인덱스를 사용해 일정 제거
    notifyListeners(); // 상태 업데이트
  }

  List<Map<String, dynamic>> getWeeklySchedules(DateTime startOfWeek, DateTime endOfWeek) {
    return _schedules.where((schedule) {
      final scheduleDate = schedule['selectedDate'] as DateTime;
      return scheduleDate.isAtSameMomentAs(startOfWeek) || scheduleDate.isAtSameMomentAs(endOfWeek) ||
          (scheduleDate.isAfter(startOfWeek) && scheduleDate.isBefore(endOfWeek));
    }).toList();
  }
}
