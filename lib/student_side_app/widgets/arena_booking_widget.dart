import 'package:flutter/material.dart';
//import 'package:sports_complex_ms/staff_side_app/models/arena_management_section/arena.dart';
import 'package:sports_complex_ms/student_side_app/screens/arena_booking_screen1.dart';
import 'package:sports_complex_ms/student_side_app/services/arena_services.dart';
import 'package:sports_complex_ms/student_side_app/widgets/booked_slot_details_widget.dart';

class ArenaBookingWidget extends StatefulWidget {
  const ArenaBookingWidget({
    super.key,
    required this.studentUsn,
  });

  final String studentUsn;

  @override
  State<ArenaBookingWidget> createState() => _ArenaBookingWidgetState();
}

class _ArenaBookingWidgetState extends State<ArenaBookingWidget> {
  bool _isLoading = true;
  bool _toggle = false;
  Map<String, String?>? bookingDetails;
  late List<String> _sportsList;

  Future<void> _loadDetails() async {
    final arenaServices = ArenaServices();
    _sportsList = await arenaServices.getSports();
    checkUserHasBooked();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> checkUserHasBooked() async {
    final res =
        await ArenaServices().getDetailsOfBookedSlots(widget.studentUsn);
    setState(() {
      _isLoading = false;
      bookingDetails = res;
    });
  }

  Future<void> _cancelBooking() async {
    await ArenaServices().cancelBooking(widget.studentUsn, context);
    setState(() {
      bookingDetails = null;
    });
  }

  @override
  void initState() {
    _loadDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    content = const Center(
      child: CircularProgressIndicator(),
    );

    if (!_isLoading) {
      if (bookingDetails != null) {
        content = BookedSlotDetailsWidget(
            onBookingCancelled: _cancelBooking,
            usn: widget.studentUsn,
            bookedSlotDetails: bookingDetails!);
      } else if (bookingDetails == null || bookingDetails!.isEmpty) {
        content = Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _toggle = !_toggle;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Row(
                  children: [
                    Text(
                      'Book Arena',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const Spacer(),
                    Icon(
                      _toggle
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),
            if (_toggle)
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _sportsList.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      _sportsList[index].toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () async {
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => AvailableArenasScreen(
                            sport: _sportsList[index],
                          ),
                        ),
                      );

                      if (res == 1) {
                        setState(() {
                          _isLoading = true;
                          checkUserHasBooked();
                        });
                      }
                    },
                  ),
                ),
              ),
          ],
        );
      }
    }
    return content;
  }
}
