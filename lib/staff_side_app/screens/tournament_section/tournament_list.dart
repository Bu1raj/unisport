import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/providers/tournament_provider.dart';
import 'package:sports_complex_ms/staff_side_app/widgets/tournament_section/tournament_card.dart';

class OrganizedTournaments extends ConsumerStatefulWidget {
  const OrganizedTournaments({super.key});

  @override
  ConsumerState<OrganizedTournaments> createState() =>
      _OrganizedTournamentsState();
}

class _OrganizedTournamentsState extends ConsumerState<OrganizedTournaments> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(tournamentsProvider);
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );

    if (list != null && list.isEmpty) {
      content = Center(
        child: Text(
          'No tournaments organized',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
        ),
      );
    }

    if (list != null && list.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Text(
              'Tournament List',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
            ),*/
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: list.length,
                itemBuilder: (context, index) => TournamentCard(
                  tournament: list[index],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return content;
  }
}
