import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/student_side_app/models/arena_booking/booking_details.dart';
import 'package:sports_complex_ms/student_side_app/services/arena_services.dart';

class BookedArenaDetailsNotifier extends StateNotifier<BookingDetails?> {
  BookedArenaDetailsNotifier() : super(null);

  Future<void> fetchUserBookingDetails(String studentUsn) async {
    final arenaServices = ArenaServices();
    final res = await arenaServices.getDetailsOfBookedSlots(studentUsn);
    state = res;
  }

  Future<void> bookASlot(
    String studentUsn,
    String arenaId,
    String slotNo,
  ) async {
    final arenaServices = ArenaServices();
    await arenaServices.bookASlot(slotNo, arenaId, studentUsn);
    await fetchUserBookingDetails(studentUsn);
  }

  Future<void> cancelBooking(String studentUsn, BuildContext context) async {
    await ArenaServices().cancelBooking(studentUsn, context);
    state = null;
  }
}

final bookedArenaDetailsProvider =
    StateNotifierProvider<BookedArenaDetailsNotifier, BookingDetails?>(
        (ref) => BookedArenaDetailsNotifier());
