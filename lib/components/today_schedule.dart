import 'package:flutter/material.dart';
import 'package:term_project/cons/colors.dart';

class ScheduleCard extends StatelessWidget {
  final DateTime? endDate; // End date of the schedule
  final String content; // Content of the schedule
  final bool isCompleted; // Completion status
  final VoidCallback? onToggleComplete; // Callback to toggle completion
  final VoidCallback? onEdit; // Callback to edit the schedule

  const ScheduleCard({
    this.endDate,
    required this.content,
    required this.isCompleted,
    this.onToggleComplete,
    this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentColor = isCompleted ? Colors.grey : Colors.black; // Text color based on completion
    final dateColor = isCompleted ? Colors.grey : PRIMARY_COLOR; // Date color based on completion

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: PRIMARY_COLOR, // Border color
        ),
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Padding inside the card
      margin: EdgeInsets.only(bottom: 8.0), // Margin below the card
      child: Row(
        children: [
          // Checkbox for completion
          GestureDetector(
            onTap: onToggleComplete, // Toggles completion state
            child: Container(
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: isCompleted ? PRIMARY_COLOR : Colors.grey, // Border color changes on completion
                  width: 2.0,
                ),
                color: isCompleted ? PRIMARY_COLOR : Colors.transparent, // Fill color changes on completion
              ),
              child: isCompleted
                  ? Icon(Icons.check, size: 12.0, color: Colors.white) // Check icon for completed state
                  : null,
            ),
          ),
          SizedBox(width: 12.0), // Spacing between checkbox and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (endDate != null)
                  Text(
                    'End Date: ${endDate!.year}-${endDate!.month}-${endDate!.day}', // Display end date
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: dateColor,
                      fontSize: 14.0,
                    ),
                  ),
                SizedBox(height: 4.0), // Spacing between date and content
                Text(
                  content, // Schedule content
                  style: TextStyle(
                    fontSize: 12.0,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            TextButton(
              onPressed: onEdit, // Edit button action
              child: Text(
                'Edit', // Edit button label
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
