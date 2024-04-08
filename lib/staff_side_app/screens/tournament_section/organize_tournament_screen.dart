import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/models/tournament_section/tournament.dart';
import 'package:sports_complex_ms/staff_side_app/providers/tournament_provider.dart';
import 'package:sports_complex_ms/staff_side_app/services/tournament_services.dart';
import 'package:sports_complex_ms/staff_side_app/widgets/tournament_section/tournament_date_widget.dart';

class CreateTournamentScreen extends ConsumerStatefulWidget {
  const CreateTournamentScreen({
    super.key,
    required this.switchTab,
  });

  final VoidCallback switchTab;

  @override
  ConsumerState<CreateTournamentScreen> createState() =>
      _CreateTournamentScreenState();
}

class _CreateTournamentScreenState
    extends ConsumerState<CreateTournamentScreen> {
  late final List<String> tournamentSports;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  String _selectedSport = '';
  final List<int> _fee = [100, 200, 300, 400, 500];
  DateTime? _selectedStartDate;
  DateTime? _selectedRegStartDate;
  DateTime? _selectedRegEndDate;
  int _selectedFee = 100;
  bool _isCreating = false;

  Future<void> loadDetails() async {
    tournamentSports = await TournamentServices().getTournamentSports();
    _selectedSport = tournamentSports[0];
    setState(() {
      _isLoading = false;
    });
  }

  void onDateSelected(
    DateTime tournamentStartDate,
    DateTime regStartDate,
    DateTime regEndDate,
  ) {
    _selectedStartDate = tournamentStartDate;
    _selectedRegStartDate = regStartDate;
    _selectedRegEndDate = regEndDate;

    print(_selectedStartDate);
    print(_selectedRegStartDate);
    print(_selectedRegEndDate);
  }

  Future<bool> validTournamentChecker(Tournament tournament) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('availableTournaments')
        .get();
    final tournamentList = snapshot.docs
        .map(
          (doc) => Tournament(
            sport: doc.data()['sport'],
            startDate: doc.data()['startDate'],
            regStartDate: doc.data()['regStartDate'],
            regEndDate: doc.data()['regEndDate'],
            regClosed: doc.data()['regClosed'],
            entryFee: doc.data()['entryFee'],
            id: doc.id,
          ),
        )
        .toList();
    for (var i = 0; i < tournamentList.length; i++) {
      if (tournamentList[i].sport == tournament.sport) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Error'),
              content: const Text('A tournament already exists for this sport'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        }
        return false;
      }
    }
    return true;
  }

  void createTournament(WidgetRef ref) async {
    if (_selectedStartDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please select the tournament start date'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text(
            'Double check the details before creating the tournament'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              setState(() {
                _isCreating = true;
              });
              final tournament = Tournament(
                sport: _selectedSport.toLowerCase(),
                startDate: Timestamp.fromDate(_selectedStartDate!),
                regStartDate: Timestamp.fromDate(_selectedRegStartDate!),
                regEndDate: Timestamp.fromDate(_selectedRegEndDate!),
                regClosed: false,
                entryFee: _selectedFee,
              );
              final isValid = await validTournamentChecker(tournament);
              if (isValid && context.mounted) {
                await ref.read(tournamentsProvider.notifier).addTournament(
                      tournament,
                      context,
                    );
                setState(() {
                  _isCreating = false;
                });
                widget.switchTab();
              }

              setState(() {
                _isCreating = false;
              });
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    loadDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWdith = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                shadowColor: Colors.black,
                clipBehavior: Clip.hardEdge,
                elevation: 5,
                child: Image(
                  image: const AssetImage("assets\\tour_final_1.png"),
                  height: screenHeight * 0.2,
                  width: screenWdith * 0.85,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: screenWdith * 0.85,
                height: screenHeight * 0.65,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 3,
                      offset: const Offset(0.4, 0.4),
                    ),
                  ],
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fill up the details',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Sport',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 15,
                                  ),
                            ),
                            const SizedBox(height: 5),
                            DropdownButtonFormField(
                              padding:
                                  const EdgeInsets.only(right: 150, left: 0),
                              dropdownColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              value: _selectedSport,
                              items: tournamentSports
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.toUpperCase()),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSport = value!;
                                });
                              },
                            ),
                            const Divider(
                              height: 30,
                              color: Colors.black26,
                              thickness: 0.5,
                            ),
                            TournamentDateWidget(
                                onDateSelected: onDateSelected),
                            const Divider(
                              height: 30,
                              color: Colors.black26,
                              thickness: 0.5,
                            ),
                            Text(
                              'Entry fee',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 15,
                                  ),
                            ),
                            const SizedBox(height: 5),
                            DropdownButtonFormField(
                              padding:
                                  const EdgeInsets.only(right: 200, left: 0),
                              dropdownColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              value: _selectedFee,
                              items: _fee
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text('₹ $e'),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedFee = value as int;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: _isCreating
                                      ? null
                                      : () {
                                          _selectedStartDate = null;
                                          _selectedRegStartDate = null;
                                          _selectedRegEndDate = null;
                                          widget.switchTab();
                                        },
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    createTournament(ref);
                                  },
                                  child: _isCreating
                                      ? const Padding(
                                          padding: EdgeInsets.all(3),
                                          child: CircularProgressIndicator(),
                                        )
                                      : const Text('Create'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
