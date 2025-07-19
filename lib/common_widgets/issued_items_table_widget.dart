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
        {bool isHeader = false, bool isLast = false}) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                )
              : null,
        ),
        child: Text(
          text,
          style: isHeader ? const TextStyle(fontWeight: FontWeight.bold) : null,
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
              buildCell('Equipment', isHeader: true),
              buildCell('ID', isHeader: true),
            ],
          ),
          for (int i = 0; i < entries.length; i++)
            TableRow(
              children: [
                buildCell(entries[i].value, isLast: i == entries.length - 1),
                buildCell(entries[i].key, isLast: i == entries.length - 1),
              ],
            ),
        ],
      ),
    );
  }
}
