import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sports_complex_ms/constants/sport_code_icon_generator.dart';

class Tournament {
  Tournament({
    required this.sport,
    required this.startDate,
    required this.regStartDate,
    required this.regEndDate,
    required this.regClosed,
    required this.entryFee,
    String? id,
  }) : id = id ?? tournamentIdGenerator(sport, startDate);

  final String sport;
  final String id;
  final Timestamp startDate;
  final Timestamp regStartDate;
  final Timestamp regEndDate;
  final bool regClosed;
  final int entryFee;

  static String tournamentIdGenerator(String sport, Timestamp startDate) {
    final code = codeGenerator(sport);
    final date = startDate.toDate();
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return 'TR$code$day$month$year';
  }

  Map<String, dynamic> toJson() {
    return {
      'sport': sport,
      'id': id,
      'startDate': startDate,
      'regStartDate': regStartDate,
      'regEndDate': regEndDate,
      'regClosed': regClosed,
      'entryFee': entryFee
    };
  }
}
