import 'package:flutter/material.dart';

class IssuedItemsTableWidget extends StatelessWidget {
  const IssuedItemsTableWidget({
    super.key,
    required this.equipmentsMap,
  });
  final Map<String, String> equipmentsMap;
  @override
  Widget build(BuildContext context) {
    final entries = equipmentsMap.entries.toList();

    Widget buildCell(String text,
        {bool isHeader = false, bool isLast = false, isOdd = false}) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isOdd
              ? Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.2)
              : Colors.transparent,
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
          style: isHeader
              ? const TextStyle(
                  fontWeight: FontWeight.bold,
                )
              : null,
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
                buildCell('Equipment', isHeader: true, isOdd: true),
                buildCell('ID', isHeader: true, isOdd: true),
              ],
            ),
            for (int i = 0; i < entries.length; i++)
              TableRow(
                children: [
                  buildCell(entries[i].value,
                      isLast: i == entries.length - 1, isOdd: i.isOdd),
                  buildCell(entries[i].key,
                      isLast: i == entries.length - 1, isOdd: i.isOdd),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
