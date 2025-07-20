import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/providers/tournament_provider.dart';
import 'package:sports_complex_ms/student_side_app/widgets/tournament_student_card.dart';

class AvailableTournamentsList extends ConsumerStatefulWidget {
  const AvailableTournamentsList({super.key});

  @override
  ConsumerState<AvailableTournamentsList> createState() =>
      _AvailableTournamentsListState();
}

class _AvailableTournamentsListState
    extends ConsumerState<AvailableTournamentsList> {
  @override
  Widget build(BuildContext context) {
    final screenWdith = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final list = ref.watch(tournamentsProvider);
    Widget content = const Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: CircularProgressIndicator(),
      ),
    );

    if (list != null && list.isEmpty) {
      content = const Center(
        child: Text(
          'No tournaments available',
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    if (list != null && list.isNotEmpty) {
      content = ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TournamentStudentCard(
              tournament: list[index],
            ),
          );
        },
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available tournaments',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const Divider(
          color: Colors.black38,
          height: 20,
          endIndent: 7,
          thickness: 0.5,
        ),
        content,
      ],
    );
  }
}
