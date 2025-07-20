import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/staff_side_app/models/tournament_section/tournament.dart';

class TournamentDetailsTable extends StatelessWidget {
  const TournamentDetailsTable({super.key, required this.tournamentDetails});

  final Tournament tournamentDetails;

  @override
  Widget build(BuildContext context) {
    String dateFormatter(DateTime date) {
      final formatter = DateFormat('EEE, MMM d, y');
      return formatter.format(date);
    }

    Widget buildCell(String text, {bool isLast = false, isEven = false}) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isEven ? Colors.grey.shade200 : Colors.transparent,
          border: !isLast
              ? Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                )
              : null,
        ),
        child: Text(
          text,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            // table heading
            TableRow(
              children: [
                buildCell('Start Date'),
                buildCell(dateFormatter(tournamentDetails.startDate.toDate())),
              ],
            ),
            TableRow(
              children: [
                buildCell('Registration Start', isEven: true),
                buildCell(
                    dateFormatter(tournamentDetails.regStartDate.toDate()),
                    isEven: true),
              ],
            ),
            TableRow(
              children: [
                buildCell('Registration End'),
                buildCell(dateFormatter(tournamentDetails.regEndDate.toDate())),
              ],
            ),
            TableRow(
              children: [
                buildCell('Entry Fee', isLast: true, isEven: true),
                buildCell('Rs. ${tournamentDetails.entryFee.toString()}',
                    isLast: true, isEven: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
