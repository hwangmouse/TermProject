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
  ); // Initialize selected date to today
  List<AssignmentData> assignments = []; // List of assignments loaded from local storage
  List<String> subjectNames = []; // List of subject names

  @override
  void initState() {
    super.initState();
    _loadAssignments(); // Load assignments on initialization
    _loadSubjects(); // Load subjects on initialization
  }

  // Load assignments from JSON file
  Future<void> _loadAssignments() async {
    final loadedAssignments = await DataManager.loadAssignments();
    setState(() {
      assignments = loadedAssignments;
    });
  }

  // Load subject names
  Future<void> _loadSubjects() async {
    final subjects = await DataManager.loadSubjects();
    setState(() {
      subjectNames = subjects.map((subject) => subject.subjectName).toList();
    });
  }

  // Add a new assignment and save it
  Future<void> _addAssignment(AssignmentData newAssignment) async {
    setState(() {
      assignments.add(newAssignment);
    });
    await DataManager.saveAssignments(assignments);
  }

  // Delete an assignment and save changes
  Future<void> _deleteAssignment(int index) async {
    setState(() {
      assignments.removeAt(index);
    });
    await DataManager.saveAssignments(assignments);
  }

  @override
  Widget build(BuildContext context) {
    // Filter assignments based on the selected date
    final filteredAssignments = assignments.where((assignment) {
      final deadline = assignment.deadline;
      return selectedDate.isBefore(deadline.add(Duration(days: 1)));
    }).toList();

    // Group assignments by subject
    final Map<String, List<AssignmentData>> groupedAssignments = {};
    for (var assignment in filteredAssignments) {
      groupedAssignments.putIfAbsent(assignment.subjectName, () => []);
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
          // Show bottom sheet to add a new assignment
          final result = await showModalBottomSheet<AssignmentData>(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(subjectNames: subjectNames),
            isScrollControlled: true,
          );
          if (result != null) {
            await _addAssignment(result);
          }
        },
        backgroundColor: PRIMARY_COLOR,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Calendar at the top
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: _onDaySelected,
            ),
            SizedBox(height: 8.0),
            // Banner showing the number of assignments
            TodayBanner(
              selectedDate: selectedDate,
              count: filteredAssignments.length,
            ),
            SizedBox(height: 8.0),
            // Assignment list grouped by subject
            Expanded(
              child: groupedAssignments.isEmpty
                  ? Center(
                child: Text(
                  'No assignments for today.',
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
                      // Subject header
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
                      // Assignment cards
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
                                color: assignment.isCompleted
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'Deadline: ${_formatDate(assignment.deadline)}',
                              style: TextStyle(
                                decoration: assignment.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Checkbox for marking completion
                                Checkbox(
                                  value: assignment.isCompleted,
                                  onChanged: (value) {
                                    setState(() {
                                      assignment.isCompleted = value!;
                                    });
                                    DataManager.saveAssignments(assignments);
                                  },
                                ),
                                // Delete button
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteAssignment(
                                      assignments.indexOf(assignment)),
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

  // Updates the selected date
  void _onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  // Formats a date as YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
