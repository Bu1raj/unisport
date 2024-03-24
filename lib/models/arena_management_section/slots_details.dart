import 'package:flutter/material.dart';
import 'package:sports_complex_ms/models/student.dart';

enum Slots {
  slot1,
  slot2,
  slot3,
  slot4,
}

class SlotDetails {
  SlotDetails({
    required this.slotStartTime,
    required this.slotEndTime,
    required this.bookedBy,
  });

  final TimeOfDay slotStartTime;
  final TimeOfDay slotEndTime;
  final Student? bookedBy;
}
