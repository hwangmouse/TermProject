import 'package:flutter/material.dart';
import 'package:term_project/inapp_algorithm/AssignmentData.dart';
import 'package:term_project/DataManager.dart';
import 'package:term_project/inapp_algorithm/FinalPriority.dart';
import 'package:intl/intl.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final List<String> subjectNames; // 로컬 파일에서 불러온 과목 리스트

  ScheduleBottomSheet({required this.subjectNames, Key? key}) : super(key: key);

  @override
  _ScheduleBottomSheetState createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  String? selectedSubject;
  final TextEditingController assignmentNameController = TextEditingController();
  final TextEditingController currentRatioController = TextEditingController();
  final TextEditingController latePenaltyController = TextEditingController();
  final TextEditingController expectedPeriodController = TextEditingController();
  DateTime? deadline;

  // 과제를 로컬 파일에 저장하는 메서드
  Future<void> _saveAssignment() async {
    if (selectedSubject == null || // 과목이 선택되지 않았거나
        assignmentNameController.text.isEmpty || // 과제 이름이 비어 있거나
        deadline == null) { // 마감일이 설정되지 않았으면
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    // 새 과제 데이터를 AssignmentData 객체로 생성
    final newAssignment = AssignmentData(
      subjectName: selectedSubject!,
      assignmentName: assignmentNameController.text.trim(),
      currentRatio: double.parse(currentRatioController.text.trim()),
      latePenalty: double.parse(latePenaltyController.text.trim()),
      isAlter: 0.0, // 기본값: 0
      deadline: deadline!,
      expectedPeriod: double.parse(expectedPeriodController.text.trim()),
    );

    // 과목 데이터를 로드
    final subjects = await DataManager.loadSubjects();
    final relatedSubject = subjects.firstWhere(
          (subject) => subject.subjectName == selectedSubject,
      orElse: () => throw Exception('해당 과목을 찾을 수 없습니다.'),
    );

    // importance 값을 계산
    newAssignment.calculateImportance(
      relatedSubject.assignmentRatio,
      newAssignment.isAlter.toDouble(),
    );
    //debug
    print("Assignment Ratio: ${relatedSubject.assignmentRatio}");
    print("isAlter: ${newAssignment.isAlter}");

    // FinalPriority를 사용하여 priority 계산
    final priorityCalculator = FinalPriority([relatedSubject], [newAssignment], []);
    priorityCalculator.calcPriority();
    //debug
    print("Related Subject: ${relatedSubject.subjectName}");
    print("New Assignment: ${newAssignment.assignmentName}");

    // 기존 과제 데이터를 로드
    final currentAssignments = await DataManager.loadAssignments();

    // 새 과제를 리스트에 추가
    currentAssignments.add(newAssignment);

    // 로컬 파일에 저장
    await DataManager.saveAssignments(currentAssignments);

    // 화면 닫기와 함께 새 과제 데이터를 반환
    Navigator.pop(context, newAssignment);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView( // 스크롤 가능하도록 구성
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 과목 선택 드롭다운
            DropdownButtonFormField<String>(
              items: widget.subjectNames
                  .map((name) => DropdownMenuItem(
                value: name,
                child: Text(name),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
              decoration: InputDecoration(
                labelText: '과목 선택',
                prefixIcon: Icon(Icons.book, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // 과제 이름 입력
            TextField(
              controller: assignmentNameController,
              decoration: InputDecoration(
                labelText: '과제 이름',
                prefixIcon: Icon(Icons.assignment, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // 현재 과제 비율 입력
            TextField(
              controller: currentRatioController,
              decoration: InputDecoration(
                labelText: '현재 과제 비율 (0 ~ 1)',
                prefixIcon: Icon(Icons.percent, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            // 지각 패널티 입력
            TextField(
              controller: latePenaltyController,
              decoration: InputDecoration(
                labelText: '지각 패널티 (허용하지 않으면 0)',
                prefixIcon: Icon(Icons.warning, color: Colors.redAccent),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            // 예상 소요 시간 입력
            TextField(
              controller: expectedPeriodController,
              decoration: InputDecoration(
                labelText: '예상 소요 시간 (시간 단위)',
                prefixIcon: Icon(Icons.timer, color: Colors.blueAccent),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            // 마감일 선택 버튼
            ElevatedButton.icon(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    deadline = pickedDate;
                  });
                }
              },
              icon: Icon(Icons.date_range, color: Colors.white),
              label: Text(deadline == null
                  ? '마감일 선택'
                  : '마감일: ${DateFormat("yyyy-MM-dd HH:mm").format(DateTime(deadline!.year, deadline!.month, deadline!.day, 23, 59))}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // 저장 버튼
            Center(
              child: ElevatedButton(
                onPressed: _saveAssignment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '저장',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}