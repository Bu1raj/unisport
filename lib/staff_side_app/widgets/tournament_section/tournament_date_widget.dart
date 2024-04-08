import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/custom/widgets/custom_container_2.dart';

class TournamentDateWidget extends StatefulWidget {
  const TournamentDateWidget({
    super.key,
    required this.onDateSelected,
  });

  final Function(DateTime tournamentStartDate, DateTime regStartDate,
      DateTime regEndDate) onDateSelected;
  @override
  State<TournamentDateWidget> createState() => _TournamentDateWidgetState();
}

class _TournamentDateWidgetState extends State<TournamentDateWidget> {
  DateTime? _selectedStartDate;
  DateTime? _selectedRegStartDate;
  DateTime? _selectedRegEndDate;

  void determineRegStartEndDate(DateTime startDate) {
    final diff = startDate.difference(DateTime.now()).inDays;
    final now = DateTime.now();
    int days = (diff * 0.75).round();
    _selectedRegStartDate = now.add(const Duration(days: 1));
    _selectedRegEndDate = _selectedRegStartDate!.add(Duration(days: days));
  }

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 14),
      ),
      firstDate: DateTime.now().add(
        const Duration(days: 14),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 40),
      ),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedStartDate = pickedDate;
        determineRegStartEndDate(pickedDate);
        widget.onDateSelected(
          _selectedStartDate!,
          _selectedRegStartDate!,
          _selectedRegEndDate!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tournament start date',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 15,
              ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                _presentDatePicker();
              },
              icon: const Icon(
                Icons.calendar_month,
                size: 30,
              ),
            ),
            const SizedBox(width: 10),
            CustomContainer2(
              content: Text(
                _selectedStartDate == null
                    ? 'No date selected'
                    : DateFormat.yMMMMEEEEd().format(_selectedStartDate!),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 15,
                    ),
              ),
            ),
          ],
        ),
        const Divider(
          height: 30,
          color: Colors.black26,
          thickness: 0.5,
        ),
        Text(
          'Registrations',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 15,
              ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2,
          children: [
            CustomContainer2(
              content: Column(
                children: [
                  Text(
                    'Start date',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 15,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _selectedRegStartDate == null
                        ? 'No date selected'
                        : DateFormat.yMMMEd().format(_selectedRegStartDate!),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        //fontSize: 15,
                        color: const Color.fromARGB(255, 0, 145, 5)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CustomContainer2(
              content: Column(
                children: [
                  Text(
                    'End date',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 15,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _selectedRegEndDate == null
                        ? 'No date selected'
                        : DateFormat.yMMMEd().format(_selectedRegEndDate!),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          //fontSize: 15,
                          color: const Color.fromARGB(255, 235, 1, 1),
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//const SizedBox(height: 10),
        /*Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.tertiary,
              size: 20,
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: 290,
              child: Text(
                'The registration dates are auto generated based on the tournament start date.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),*/
