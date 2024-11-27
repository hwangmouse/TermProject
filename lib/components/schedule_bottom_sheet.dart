import 'package:flutter/material.dart';
import 'package:term_project/inapp_algorithm/AssignmentData.dart'; // Model for assignment data
import 'package:term_project/DataManager.dart'; // Handles data storage and retrieval
import 'package:term_project/inapp_algorithm/FinalPriority.dart'; // For priority calculation
import 'package:intl/intl.dart'; // Date formatting utility

class ScheduleBottomSheet extends StatefulWidget {
  final List<String> subjectNames; // List of subjects loaded from local storage

  ScheduleBottomSheet({required this.subjectNames, Key? key}) : super(key: key);

  @override
  _ScheduleBottomSheetState createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  String? selectedSubject; // Selected subject name
  final TextEditingController assignmentNameController = TextEditingController();
  final TextEditingController currentRatioController = TextEditingController();
  final TextEditingController latePenaltyController = TextEditingController();
  final TextEditingController expectedPeriodController = TextEditingController();
  DateTime? deadline; // Deadline for the assignment

  // Method to save assignment to local storage
  Future<void> _saveAssignment() async {
    if (selectedSubject == null ||
        assignmentNameController.text.isEmpty ||
        deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')), // Validation feedback
      );
      return;
    }

    // Create a new assignment data object
    final newAssignment = AssignmentData(
      subjectName: selectedSubject!,
      assignmentName: assignmentNameController.text.trim(),
      currentRatio: double.parse(currentRatioController.text.trim()),
      latePenalty: double.parse(latePenaltyController.text.trim()),
      isAlter: 0.0,
      deadline: deadline!,
      expectedPeriod: double.parse(expectedPeriodController.text.trim()),
    );

    // Load subject data
    final subjects = await DataManager.loadSubjects();
    final relatedSubject = subjects.firstWhere(
          (subject) => subject.subjectName == selectedSubject,
      orElse: () => throw Exception('Subject not found.'),
    );

    // Calculate importance value for the assignment
    newAssignment.calculateImportance(
      relatedSubject.assignmentRatio,
      newAssignment.isAlter.toDouble(),
    );

    // Calculate priority using FinalPriority
    final priorityCalculator = FinalPriority([relatedSubject], [newAssignment], []);
    priorityCalculator.calcPriority();

    // Load current assignments
    final currentAssignments = await DataManager.loadAssignments();

    // Add the new assignment to the list and save
    currentAssignments.add(newAssignment);
    await DataManager.saveAssignments(currentAssignments);

    // Close the bottom sheet and return the new assignment
    Navigator.pop(context, newAssignment);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView( // Makes the content scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown to select subject
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
                labelText: 'Select Subject',
                prefixIcon: Icon(Icons.book, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // TextField for assignment name
            TextField(
              controller: assignmentNameController,
              decoration: InputDecoration(
                labelText: 'Assignment Name',
                prefixIcon: Icon(Icons.assignment, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // TextField for current assignment ratio
            TextField(
              controller: currentRatioController,
              decoration: InputDecoration(
                labelText: 'Current Ratio (0 ~ 1)',
                prefixIcon: Icon(Icons.percent, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            // TextField for late penalty
            TextField(
              controller: latePenaltyController,
              decoration: InputDecoration(
                labelText: 'Late Penalty (0 if not allowed)',
                prefixIcon: Icon(Icons.warning, color: Colors.redAccent),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            // TextField for expected time required
            TextField(
              controller: expectedPeriodController,
              decoration: InputDecoration(
                labelText: 'Expected Period (in hours)',
                prefixIcon: Icon(Icons.timer, color: Colors.blueAccent),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            // Button to select deadline
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
                  ? 'Select Deadline'
                  : 'Deadline: ${DateFormat("yyyy-MM-dd HH:mm").format(DateTime(deadline!.year, deadline!.month, deadline!.day, 23, 59))}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Save button
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
                  'Save',
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
