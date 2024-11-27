import 'package:flutter/material.dart';
import 'package:term_project/cons/colors.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate; // The selected date to display
  final int count; // Number of schedules for the selected date

  const TodayBanner({
    required this.selectedDate,
    required this.count,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adds padding around the banner
      color: LIGHT_PRIMARY_COLOR, // Background color lighter than PRIMARY_COLOR
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns text at both ends
        children: [
          Text(
            '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}', // Displays the selected date
            style: TextStyle(
              fontWeight: FontWeight.bold, // Bold font for emphasis
              fontSize: 16.0, // Font size
              color: DARK_GREY_COLOR, // Dark grey text color
            ),
          ),
          Text(
            '$count assignments', // Displays the number of schedules
            style: TextStyle(
              fontWeight: FontWeight.bold, // Bold font for emphasis
              fontSize: 16.0, // Font size
              color: DARK_GREY_COLOR, // Dark grey text color
            ),
          ),
        ],
      ),
    );
  }
}
