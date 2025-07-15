import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/providers/tournament_provider.dart';
import 'package:sports_complex_ms/student_side_app/widgets/tournamentStudentCard.dart';

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
        child: Text('No tournaments available'),
      );
    }

    if (list != null && list.isNotEmpty) {
      content = Expanded(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return TournamentStudentCard(
              tournament: list[index],
            );
          },
        ),
      );
    }
    return Container(
      width: screenWdith * 0.96,
      height: screenHeight * 0.50,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 3,
            //offset: const Offset(0.4, 0.4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available tournaments',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
          ),
          const SizedBox(
            height: 5,
          ),
          content,
        ],
      ),
    );
  }
}
