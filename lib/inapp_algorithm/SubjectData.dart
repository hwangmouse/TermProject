import 'dart:convert';

class SubjectData {
  String subjectName; // Name of the subject
  double midtermRatio; // Midterm ratio in the subject's grading
  double finalRatio; // Final exam ratio in the subject's grading
  double assignmentRatio; // Assignment ratio in the subject's grading
  double attendanceRatio; // Attendance ratio in the subject's grading
  int creditHours; // Credit hours for the subject
  bool isMajor; // Whether the subject is a major or not
  int preferenceLevel; // User's preference level for the subject
  double importance; // Calculated importance score for the subject

  SubjectData({
    required this.subjectName,
    required this.midtermRatio,
    required this.finalRatio,
    required this.assignmentRatio,
    required this.attendanceRatio,
    required this.creditHours,
    required this.isMajor,
    required this.preferenceLevel,
    this.importance = 0.0, // Default importance is 0
  });

  // Calculates the importance of the subject
  void calculateImportance(int maxCreditHours) {
    double creditScore = creditHours / maxCreditHours; // Credit hours importance
    double preferenceScore = 1.0;

    // Adjust preference score based on preference level
    switch (preferenceLevel) {
      case 1:
        preferenceScore = 0.8;
        break;
      case 2:
        preferenceScore = 0.85;
        break;
      case 3:
        preferenceScore = 0.9;
        break;
      case 4:
        preferenceScore = 0.95;
        break;
      case 5:
        preferenceScore = 1.0;
        break;
      default:
        print("Error value");
    }

    double majorScore = isMajor ? 1.0 : 0.8; // Higher score for major subjects
    double assignmentScore = assignmentRatio * 4.0; // Amplify assignment ratio

    // Calculate overall importance
    importance = (creditScore * majorScore) + preferenceScore + assignmentScore;
  }

  // Converts the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'midtermRatio': midtermRatio,
      'finalRatio': finalRatio,
      'assignmentRatio': assignmentRatio,
      'attendanceRatio': attendanceRatio,
      'creditHours': creditHours,
      'isMajor': isMajor,
      'preferenceLevel': preferenceLevel,
      'importance': importance,
    };
  }

  // Creates an object from JSON
  factory SubjectData.fromJson(Map<String, dynamic> json) {
    return SubjectData(
      subjectName: json['subjectName'],
      midtermRatio: json['midtermRatio'],
      finalRatio: json['finalRatio'],
      assignmentRatio: json['assignmentRatio'],
      attendanceRatio: json['attendanceRatio'],
      creditHours: json['creditHours'],
      isMajor: json['isMajor'],
      preferenceLevel: json['preferenceLevel'],
      importance: json['importance'] ?? 0.0,
    );
  }
}
