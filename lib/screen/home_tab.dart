import 'package:flutter/material.dart';
import 'package:term_project/DataManager.dart';
import 'package:term_project/components/calendar.dart';
import 'package:term_project/components/today_banner.dart';
import 'package:term_project/components/schedule_bottom_sheet.dart';
import 'package:term_project/inapp_algorithm/AssignmentData.dart';
import 'package:term_project/cons/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  List<AssignmentData> assignments = []; // 로컬 파일에서 불러올 과제 데이터
  List<String> subjectNames = []; // 과목 이름 리스트

  @override
  void initState() {
    super.initState();
    _loadAssignments(); // 초기화 시 로컬 데이터 로드
    _loadSubjects(); // 과목 데이터를 로드
  }


  // JSON 파일에서 과제 데이터를 불러오는 메서드
  Future<void> _loadAssignments() async {
    final loadedAssignments = await DataManager.loadAssignments(); // DataManager 호출
    setState(() {
      assignments = loadedAssignments; // 불러온 데이터를 상태에 저장
    });
  }

  Future<void> _loadSubjects() async {
    final subjects = await DataManager.loadSubjects();
    setState(() {
      subjectNames = subjects.map((subject) => subject.subjectName).toList();
    });
  }

  // 새로운 과제 추가 후 저장
  Future<void> _addAssignment(AssignmentData newAssignment) async {
    setState(() {
      assignments.add(newAssignment); // 새 과제 추가
    });
    await DataManager.saveAssignments(assignments); // 로컬 파일에 저장
  }

  // 과제 삭제
  Future<void> _deleteAssignment(int index) async {
    setState(() {
      assignments.removeAt(index); // 특정 과제 삭제
    });
    await DataManager.saveAssignments(assignments); // 로컬 파일 업데이트
  }

  @override
  Widget build(BuildContext context) {
    // 선택된 날짜에 해당하는 과제 필터링
    final filteredAssignments = assignments.where((assignment) {
      final deadline = assignment.deadline; // 일정 마감일
      // 선택된 날짜가 마감일과 같거나 이전인지 확인
      return selectedDate.isBefore(deadline.add(Duration(days: 1)));
    }).toList();

    // 과목별로 과제 그룹화
    final Map<String, List<AssignmentData>> groupedAssignments = {};
    for (var assignment in filteredAssignments) {
      if (!groupedAssignments.containsKey(assignment.subjectName)) {
        groupedAssignments[assignment.subjectName] = [];
      }
      groupedAssignments[assignment.subjectName]!.add(assignment);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Screen - Assignments',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: PRIMARY_COLOR,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 과제 추가를 위한 Bottom Sheet 호출
          final result = await showModalBottomSheet<AssignmentData>(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(subjectNames: subjectNames),
            isScrollControlled: true,
          );
          if (result != null) {
            await _addAssignment(result); // 과제 저장
          }
        },
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 달력
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: _onDaySelected, // 날짜 선택 시 호출
            ),
            SizedBox(height: 8.0),
            // 오늘 과제 배너
            TodayBanner(
              selectedDate: selectedDate,
              count: filteredAssignments.length,
            ),
            SizedBox(height: 8.0),
            // 과목별로 정렬된 과제 리스트
            Expanded(
              child: groupedAssignments.isEmpty
                  ? Center(
                child: Text(
                  '오늘은 과제가 없습니다.',
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              )
                  : ListView(
                children: groupedAssignments.entries.map((entry) {
                  final subjectName = entry.key;
                  final subjectAssignments = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 과목 이름 헤더
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          subjectName,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: PRIMARY_COLOR,
                          ),
                        ),
                      ),
                      // 과제 리스트
                      ...subjectAssignments.map((assignment) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          elevation: 2.0,
                          child: ListTile(
                            title: Text(
                              assignment.assignmentName,
                              style: TextStyle(
                                decoration: assignment.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: assignment.isCompleted ? Colors.grey : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              '마감일: ${_formatDate(assignment.deadline)}',
                              style: TextStyle(
                                decoration: assignment.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 완료 체크박스
                                Checkbox(
                                  value: assignment.isCompleted,
                                  onChanged: (value) {
                                    setState(() {
                                      assignment.isCompleted = value!;
                                    });
                                    DataManager.saveAssignments(assignments); // 변경 사항 저장
                                  },
                                ),
                                // 삭제 버튼
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      _deleteAssignment(assignments.indexOf(assignment)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 날짜 선택 시 호출
  void _onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  // 날짜를 YYYY-MM-DD 형식으로 변환
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}