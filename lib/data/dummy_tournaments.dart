import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sports_complex_ms/staff_side_app/models/tournament_section/tournament.dart';

List<Tournament> tournamentList = [
  Tournament(
    sport: 'basketball',
    startDate: Timestamp.fromDate(
      DateTime(2024, 4, 27),
    ),
    regStartDate: Timestamp.fromDate(
      DateTime(2024, 4, 6),
    ),
    regEndDate: Timestamp.fromDate(
      DateTime(2024, 4, 16),
    ),
    regClosed: false,
    entryFee: 100,
  )
];
