import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/models/tournament_section/tournament.dart';
import 'package:sports_complex_ms/staff_side_app/providers/tournament_provider.dart';
import 'package:sports_complex_ms/staff_side_app/widgets/tournament_section/tournament_details_widget.dart';

class TournamentDetailsScreen extends ConsumerStatefulWidget {
  const TournamentDetailsScreen({
    super.key,
    required this.tournament,
  });

  final Tournament tournament;
  @override
  ConsumerState<TournamentDetailsScreen> createState() =>
      _TournamentDetailsScreenState();
}

class _TournamentDetailsScreenState
    extends ConsumerState<TournamentDetailsScreen> {
  bool _isCancelling = false;
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isCancelling
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title: const Text('Cancel Tournament'),
                                    content: const Text(
                                        'Are you sure you want to cancel this tournament?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(ctx).pop();
                                          setState(() {
                                            _isCancelling = true;
                                          });
                                          await ref
                                              .read(
                                                  tournamentsProvider.notifier)
                                              .cancelTournament(
                                                widget.tournament,
                                                context,
                                              );
                                          setState(() {
                                            _isCancelling = false;
                                          });

                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                      child: _isCancelling
                          ? const Padding(
                              padding: EdgeInsets.all(3),
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Cancel Tournament'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: _isCancelling
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      child: _isCancelling
                          ? const Padding(
                              padding: EdgeInsets.all(3),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Okay'),
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
