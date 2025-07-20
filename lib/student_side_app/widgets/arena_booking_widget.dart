import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/student_side_app/models/arena_booking/booking_details.dart';
import 'package:sports_complex_ms/student_side_app/providers/arena_details_provider.dart';
import 'package:sports_complex_ms/student_side_app/screens/arena_booking_screen1.dart';
import 'package:sports_complex_ms/student_side_app/services/arena_services.dart';
import 'package:sports_complex_ms/student_side_app/widgets/booked_slot_details_widget.dart';

class ArenaBookingWidget extends ConsumerStatefulWidget {
  const ArenaBookingWidget({
    super.key,
    required this.studentUsn,
  });

  final String studentUsn;

  @override
  ConsumerState<ArenaBookingWidget> createState() => _ArenaBookingWidgetState();
}

class _ArenaBookingWidgetState extends ConsumerState<ArenaBookingWidget> {
  bool _isLoading = true;
  bool _toggle = false;
  late List<String> _sportsList;

  Future<void> _loadDetails() async {
    final arenaServices = ArenaServices();
    _sportsList = await arenaServices.getSports();
    await ref
        .read(bookedArenaDetailsProvider.notifier)
        .fetchUserBookingDetails(widget.studentUsn);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _loadDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BookingDetails? bookingDetails =
        ref.watch(bookedArenaDetailsProvider);
    Widget content;

    content = const Center(
      child: CircularProgressIndicator(),
    );

    if (!_isLoading) {
      if (bookingDetails != null) {
        content = BookedSlotDetailsWidget(
            usn: widget.studentUsn, bookedSlotDetails: bookingDetails);
      } else {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "You have not booked any arena yet",
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  ),
                  onPressed: () {
                    setState(() {
                      _toggle = !_toggle;
                    });
                  },
                  icon: Icon(
                    _toggle
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  label: Text("Book Arena"),
                ),
                const SizedBox(width: 10)
              ],
            ),
            if (_toggle)
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  for (final sport in _sportsList)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AvailableArenasScreen(
                              sport: sport,
                            ),
                          ),
                        );
                        setState(() {
                          _toggle = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 1.0,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(sport),
                            Icon(Icons.arrow_right_rounded),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            _toggle ? const SizedBox(height: 17) : const SizedBox.shrink(),
          ],
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Details',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const Divider(
          color: Colors.black38,
          height: 20,
          endIndent: 7,
          thickness: 0.5,
        ),
        content,
        bookingDetails != null ? const SizedBox(height: 17) : const SizedBox(),
      ],
    );
  }
}
