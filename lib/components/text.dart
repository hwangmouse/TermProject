import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:term_project/cons/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label; // Label for the text field
  final bool isTime; // Indicates if this is a time-specific text field

  const CustomTextField({
    required this.label,
    required this.isTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column( // Arranges label and text field vertically
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the start
      children: [
        Text(
          label, // Display label text
          style: TextStyle(
            color: PRIMARY_COLOR, // Primary color for label text
            fontWeight: FontWeight.w600, // Semi-bold font
          ),
        ),
        Expanded(
          flex: isTime ? 0 : 1, // Adjusts the size based on whether it's a time field
          child: TextFormField(
            cursorColor: Colors.grey, // Sets cursor color to grey
            maxLines: isTime ? 1 : null, // Single line for time field, multi-line otherwise
            expands: !isTime, // Expands field fully if not a time field
            keyboardType: isTime ? TextInputType.number : TextInputType.multiline, // Numeric keyboard for time fields
            inputFormatters: isTime
                ? [
              FilteringTextInputFormatter.digitsOnly, // Restricts input to digits for time fields
            ]
                : [], // No input restrictions for non-time fields
            decoration: InputDecoration(
              border: InputBorder.none, // Removes field border
              filled: true, // Enables background color
              fillColor: Colors.grey[300], // Sets light grey background color
              suffixText: isTime ? 'h' : null, // Adds 'h' suffix for time fields
            ),
          ),
        ),
      ],
    );
  }
}
