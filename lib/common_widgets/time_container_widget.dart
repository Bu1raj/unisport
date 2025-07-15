import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeContainer extends StatelessWidget {
  const TimeContainer({super.key, required this.text, required this.time});
  final String text;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    String dateTimeFormatter(DateTime time) {
      final dateTimeFormatter = DateFormat.Hm().add_yMMMd();
      return dateTimeFormatter.format(time);
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 5),
          Text(dateTimeFormatter(time),
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
              )),
        ],
      ),
    );
  }
}
