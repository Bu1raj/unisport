import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/models/tournament_section/tournament.dart';
import 'package:sports_complex_ms/staff_side_app/widgets/tournament_section/tournament_details_widget.dart';

class TournamentStudentDetailsScreen extends ConsumerStatefulWidget {
  const TournamentStudentDetailsScreen({
    super.key,
    required this.tournament,
  });

  final Tournament tournament;
  @override
  ConsumerState<TournamentStudentDetailsScreen> createState() =>
      _TournamentStudentDetailsScreenState();
}

class _TournamentStudentDetailsScreenState
    extends ConsumerState<TournamentStudentDetailsScreen> {
  //bool _isCancelling = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight,
            maxWidth: constraints.maxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              children: [
                TournamentDetailsWidget(tournament: widget.tournament),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.info,
                      size: 15,
                    ),
                    Text(
                      'Please contact the sports department for registering',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Okay'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
