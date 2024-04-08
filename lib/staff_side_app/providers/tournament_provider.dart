import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/models/tournament_section/tournament.dart';

final _firestore = FirebaseFirestore.instance;

class TournamentsProviderNotifier extends StateNotifier<List<Tournament>?> {
  TournamentsProviderNotifier() : super(null);

  Future<void> fetchTournaments() async {
    final snapshot = await _firestore
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
    state = tournamentList;
  }

  Future<void> addTournament(Tournament tournament, BuildContext context) async{
    state = [...state!, tournament];
    try {
      await _firestore
          .collection('availableTournaments')
          .doc(tournament.id)
          .set(tournament.toJson());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tournament created successfully'),
          ),
        );
      }
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err.toString(),
            ),
          ),
        );

        state = List.from(
          state!.where((e) => e.id != tournament.id),
        );
      }
    }
  }

  Future<void> cancelTournament(Tournament tournament, BuildContext context) async{
    try{
      await _firestore.collection('availableTournaments').doc(tournament.id).delete();
      state = List.from(
        state!.where((e) => e.id != tournament.id),
      );
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tournament cancelled successfully'),
          ),
        );
      }
    } catch (err){
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err.toString(),
            ),
          ),
        );
      }
    }
  }
}

final tournamentsProvider =
    StateNotifierProvider<TournamentsProviderNotifier, List<Tournament>?>(
  (ref){
    final notifier = TournamentsProviderNotifier();
    notifier.fetchTournaments();
    return notifier;
  } ,
);
