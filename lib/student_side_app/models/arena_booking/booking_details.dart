class BookingDetails {
  BookingDetails({
    required this.slotNo,
    required this.arenaId,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.bookedBy,
  });

  final String slotNo;
  final String arenaId;
  final String slotStartTime;
  final String slotEndTime;
  final String bookedBy;
}
