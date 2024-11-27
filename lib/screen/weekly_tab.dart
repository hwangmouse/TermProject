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
  TaskQueue taskQueue = TaskQueue(); // TaskQueue object for managing tasks
  List<AssignmentData> assignments = []; // List of all assignments

  @override
  void initState() {
    super.initState();
    _loadAssignments(); // Load assignments on initialization
  }

  // Load all assignments from JSON and add to TaskQueue
  Future<void> _loadAssignments() async {
    final loadedAssignments = await DataManager.loadAssignments();

    for (var assignment in loadedAssignments) {
      // Debugging output for loaded assignments
      print(
          "Loaded Assignment: ${assignment.assignmentName}, Priority: ${assignment.priority}, Importance: ${assignment.importance}");
      taskQueue.addTask(assignment); // Add to TaskQueue
      print(
          "Added to TaskQueue: ${assignment.assignmentName}, Priority: ${assignment.priority}, Importance: ${assignment.importance}");
    }

    // Update state with sorted assignments
    setState(() {
      assignments = taskQueue.queue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment List', style: TextStyle(color: Colors.white)),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'All Assignments List',
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
                  'No Assignments',
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
                          DataManager.saveAssignments(assignments); // Save changes locally
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

  // Format a DateTime as YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
