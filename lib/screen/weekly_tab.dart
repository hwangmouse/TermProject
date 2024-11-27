import 'package:flutter/material.dart';
import 'package:term_project/cons/colors.dart';
import 'package:term_project/inapp_algorithm/TaskQueue.dart';
import 'package:term_project/DataManager.dart';
import 'package:term_project/inapp_algorithm/AssignmentData.dart';

class WeeklyTab extends StatefulWidget {
  @override
  _WeeklyTabState createState() => _WeeklyTabState();
}

class _WeeklyTabState extends State<WeeklyTab> {
  TaskQueue taskQueue = TaskQueue(); // TaskQueue 객체 생성
  List<AssignmentData> assignments = []; // 전체 과제 리스트

  @override
  void initState() {
    super.initState();
    _loadAssignments(); // 초기화 시 과제 데이터 로드
  }

  // JSON 파일에서 모든 과제 데이터를 로드하고 TaskQueue에 추가
  Future<void> _loadAssignments() async {
    final loadedAssignments = await DataManager.loadAssignments();

    // TaskQueue에 모든 과제 추가
    for (var assignment in loadedAssignments) {
      print("Loaded Assignment: ${assignment.assignmentName}, Priority: ${assignment.priority}, Importance: ${assignment.importance}"); //debugging
      taskQueue.addTask(assignment);
      print("Added to TaskQueue: ${assignment.assignmentName}, Priority: ${assignment.priority}, Importance: ${assignment.importance}"); //debugging
    }

    // TaskQueue에서 정렬된 과제 가져오기
    setState(() {
      assignments = taskQueue.queue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Assignments', style: TextStyle(color: Colors.white)),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '전체 과제 목록',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: DARK_GREY_COLOR,
                ),
              ),
            ),
            Expanded(
              child: assignments.isEmpty
                  ? Center(
                child: Text(
                  '등록된 과제가 없습니다.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: DARK_GREY_COLOR,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final assignment = assignments[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
                        assignment.assignmentName,
                        style: TextStyle(
                          color: assignment.isCompleted
                              ? Colors.grey
                              : DARK_GREY_COLOR,
                          fontWeight: FontWeight.bold,
                          decoration: assignment.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subject: ${assignment.subjectName}',
                            style: TextStyle(
                              color: assignment.isCompleted
                                  ? Colors.grey
                                  : Colors.deepPurple,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              decoration: assignment.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          /*
                          Text(
                            'Priority: ${assignment.priority.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: assignment.isCompleted
                                  ? Colors.grey
                                  : Colors.blueGrey,
                              fontSize: 14.0,
                              decoration: assignment.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                           */
                          Text(
                            'Deadline: ${_formatDate(assignment.deadline)}',
                            style: TextStyle(
                              color: assignment.isCompleted
                                  ? Colors.grey
                                  : Colors.teal,
                              fontSize: 14.0,
                              decoration: assignment.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: assignment.isCompleted,
                        onChanged: (value) {
                          setState(() {
                            assignment.isCompleted = value!;
                          });
                          DataManager.saveAssignments(assignments); // 로컬 저장
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
