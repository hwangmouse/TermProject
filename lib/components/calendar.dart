import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:term_project/cons/colors.dart'; // Import for color constants
import 'package:term_project/cons/schedule_provider.dart'; // Import for schedule provider

class MainCalendar extends StatelessWidget {
  final DateTime selectedDate; // Selected date to highlight
  final Function(DateTime, DateTime) onDaySelected; // Callback for day selection

  MainCalendar({required this.selectedDate, required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);

    // Generate markers for days with schedules
    final markers = <DateTime, List>{};
    for (var schedule in scheduleProvider.schedules) {
      final date = schedule['selectedDate'] as DateTime; // Retrieve date from schedule
      markers[date] = (markers[date] ?? [])..add(schedule); // Add schedule to the marker list
    }

    DateTime today = DateTime.now(); // Current date

    return TableCalendar(
      focusedDay: selectedDate, // Initial focused day
      firstDay: DateTime(2000), // Earliest selectable date
      lastDay: DateTime(2100), // Latest selectable date
      selectedDayPredicate: (day) =>
      isSameDay(selectedDate, day) && !isSameDay(day, today), // Highlight selected day if not today
      onDaySelected: onDaySelected, // Handle day selection
      calendarStyle: CalendarStyle(
        // Style for today's date
        todayDecoration: BoxDecoration(
          color: PRIMARY_COLOR, // Solid mint color for today
          shape: BoxShape.circle, // Circular shape
        ),
        todayTextStyle: TextStyle(
          color: Colors.white, // White text for today
          fontWeight: FontWeight.bold, // Bold font for emphasis
        ),

        // Style for selected date (when not today)
        selectedDecoration: BoxDecoration(
          color: LIGHT_PRIMARY_COLOR, // Light mint color for selection
          shape: BoxShape.circle, // Circular shape
        ),
        selectedTextStyle: TextStyle(
          color: DARK_GREY_COLOR, // Gray text for selected date
        ),

        // Style for default dates
        defaultDecoration: BoxDecoration(
          shape: BoxShape.circle, // Circular shape for default days
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.circle, // Circular shape for weekends
        ),

        // Marker style for events
        markersMaxCount: 1, // Maximum markers per day
        markerDecoration: BoxDecoration(
          color: Colors.grey, // Gray color for markers
          shape: BoxShape.circle, // Circular shape for markers
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false, // Hide format button
        titleCentered: true, // Center-align the calendar title
      ),
      eventLoader: (day) => markers[day] ?? [], // Load events for the selected day
    );
  }
}
