/* Local Storage Management */
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:term_project/inapp_algorithm/SubjectData.dart';
import 'package:term_project/inapp_algorithm/AssignmentData.dart';

class DataManager {
  // Save subjects to local JSON file
  static Future<File> saveSubjects(List<SubjectData> subjects) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/subjects.json');

    // Convert SubjectData list to JSON
    List<Map<String, dynamic>> jsonData =
    subjects.map((subject) => subject.toJson()).toList();

    // Write JSON data to file
    return file.writeAsString(jsonEncode(jsonData));
  }

  // Load subjects from local JSON file
  static Future<List<SubjectData>> loadSubjects() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/subjects.json');

    if (await file.exists()) {
      // Read file content
      String content = await file.readAsString();

      // Decode JSON data and convert to SubjectData list
      List<dynamic> jsonData = jsonDecode(content);
      return jsonData.map((item) => SubjectData.fromJson(item)).toList();
    } else {
      return []; // Return empty list if file does not exist
    }
  }

  // Save assignments to local JSON file
  static Future<void> saveAssignments(List<AssignmentData> assignments) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/assignments.json');

    // Convert AssignmentData list to JSON
    List<Map<String, dynamic>> jsonData =
    assignments.map((assignment) => assignment.toJson()).toList();

    // Write JSON data to file
    await file.writeAsString(jsonEncode(jsonData));
  }

  // Load assignments from local JSON file
  static Future<List<AssignmentData>> loadAssignments() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/assignments.json');

    if (await file.exists()) {
      // Read file content
      final content = await file.readAsString();

      // Decode JSON data and convert to AssignmentData list
      final List<dynamic> jsonData = jsonDecode(content);
      return jsonData.map((json) => AssignmentData.fromJson(json)).toList();
    } else {
      return []; // Return empty list if file does not exist
    }
  }
}
