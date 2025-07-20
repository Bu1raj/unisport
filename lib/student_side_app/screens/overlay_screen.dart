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
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TournamentDetailsWidget(tournament: widget.tournament),
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      'Please contact the sports department for registering',
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
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
        );
      },
    );
  }
}
