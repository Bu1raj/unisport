import 'package:flutter/material.dart';
import 'package:sports_complex_ms/models/arena_management_section/slots_details.dart';

class Arena {
  Arena({
    required this.sport,
    required this.arenaName,
    required this.arenaId,
    required this.slotsInfo,
    required this.arenaImagePath,
  });

  final MapEntry<String, IconData> sport;
  final String arenaName;
  final String arenaId;
  final Map<Enum, SlotDetails> slotsInfo;
  final String arenaImagePath;
}
