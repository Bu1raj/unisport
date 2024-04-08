import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/constants/sport_code_icon_generator.dart';
import 'package:sports_complex_ms/staff_side_app/models/tournament_section/tournament.dart';
import 'package:sports_complex_ms/staff_side_app/screens/tournament_section/details_screen.dart';

class TournamentCard extends StatelessWidget {
  const TournamentCard({
    super.key,
    required this.tournament,
  });

  final Tournament tournament;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String dateFormatter(DateTime date) {
      final formatter = DateFormat.yMMMMEEEEd();
      return formatter.format(date);
    }

    void presentTournamentDetails() {
      showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          constraints: BoxConstraints(
            minWidth: screenWidth,
            maxHeight: screenHeight * 0.68,
          ),
          context: context,
          builder: (ctx) => TournamentDetailsScreen(tournament: tournament));
    }

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      iconGenerator(tournament.sport),
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      tournament.sport.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Start Date',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  dateFormatter(
                    tournament.startDate.toDate(),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tournament Id',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  tournament.id,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    presentTournamentDetails();
                  },
                  icon: const Icon(
                    Icons.visibility,
                    size: 20,
                  ),
                  label: Text(
                    'View Details',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
