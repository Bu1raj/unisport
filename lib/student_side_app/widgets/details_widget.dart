import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/constants/sport_code_icon_generator.dart';
import 'package:sports_complex_ms/custom/widgets/custom_container_1.dart';
import 'package:sports_complex_ms/custom/widgets/custom_container_2.dart';
import 'package:sports_complex_ms/staff_side_app/models/tournament_section/tournament.dart';

class TournamentStudentDetails extends StatefulWidget {
  const TournamentStudentDetails({
    super.key,
    required this.tournament,
  });

  final Tournament tournament;
  @override
  State<TournamentStudentDetails> createState() =>
      TournamentStudentDetailsState();
}

class TournamentStudentDetailsState extends State<TournamentStudentDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sport',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      iconGenerator(widget.tournament.sport),
                      size: 30,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.tournament.sport.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tournament ID',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.tournament.id,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Tournament Start Date',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
        ),
        const SizedBox(
          height: 5,
        ),
        CustomContainerOne(
          content: Text(
            DateFormat.yMMMMEEEEd().format(
              widget.tournament.startDate.toDate(),
            ),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Registrations',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            CustomContainerOne(
              content: Column(
                children: [
                  Text(
                    'Start Date',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    DateFormat.yMMMEd().format(
                      widget.tournament.regStartDate.toDate(),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            CustomContainerOne(
              content: Column(
                children: [
                  Text(
                    'End Date',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    DateFormat.yMMMEd().format(
                      widget.tournament.regEndDate.toDate(),
                    ),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        CustomContainer2(
          content: widget.tournament.regClosed
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Registrations Closed',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Registrations Open',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.green,
                          ),
                    ),
                  ],
                ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(
              'Entry Fee',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
            ),
            const SizedBox(
              width: 10,
            ),
            CustomContainerOne(
              content: Text(
                '₹ ${widget.tournament.entryFee}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
