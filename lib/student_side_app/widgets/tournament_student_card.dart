import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/constants/sport_code_icon_generator.dart';
import 'package:sports_complex_ms/staff_side_app/models/tournament_section/tournament.dart';
import 'package:sports_complex_ms/student_side_app/screens/overlay_screen.dart';

class TournamentStudentCard extends StatelessWidget {
  const TournamentStudentCard({
    super.key,
    required this.tournament,
  });

  final Tournament tournament;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String dateFormatter(DateTime date) {
      final formatter = DateFormat('EEE, MMM d, y');
      return formatter.format(date);
    }

    void presentTournamentDetails() {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          minWidth: screenWidth,
          minHeight: screenHeight * 0.3,
        ),
        context: context,
        builder: (ctx) => SafeArea(
          child: TournamentStudentDetailsScreen(tournament: tournament),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 1.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      clipBehavior: Clip.hardEdge,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              TextButton.icon(
                onPressed: () {
                  presentTournamentDetails();
                },
                icon: const Icon(
                  Icons.visibility,
                  size: 20,
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                label: Text(
                  'Details',
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
    );
  }
}
