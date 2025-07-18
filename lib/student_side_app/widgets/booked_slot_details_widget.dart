import 'package:flutter/material.dart';

class BookedSlotDetailsWidget extends StatefulWidget {
  const BookedSlotDetailsWidget({
    super.key,
    required this.usn,
    required this.onBookingCancelled,
    required this.bookedSlotDetails,
  });

  final String usn;
  final Map<String, String?> bookedSlotDetails;
  final VoidCallback onBookingCancelled;

  @override
  State<BookedSlotDetailsWidget> createState() =>
      _BookedSlotDetailsWidgetState();
}

class _BookedSlotDetailsWidgetState extends State<BookedSlotDetailsWidget> {
  /*Future<void> loadDetails(String usn) async {
    bookedSlotDetails = await ArenaServices().getDetailsOfBookedSlots(usn);
    setState(() {
      _isLoadingDetails = false;
    });
  }*/

  @override
  void initState() {
    //loadDetails(widget.usn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Details',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
        ),
        const Divider(
          color: Colors.black38,
          height: 20,
          endIndent: 7,
          thickness: 0.5,
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1), // subtle shadow
                blurRadius: 1.0, // soft blur
                offset: Offset(0, 1), // slight downward shift
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.stadium),
                      const SizedBox(width: 5.0),
                      Text(
                        '${widget.bookedSlotDetails['arenaId']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Text(
                    'Slot Number - ${widget.bookedSlotDetails['slotNo']!.substring(widget.bookedSlotDetails['slotNo']!.length - 1)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.hourglass_bottom_outlined),
                      const SizedBox(width: 5.0),
                      Text(
                        '${widget.bookedSlotDetails['slotStartTime']} - ${widget.bookedSlotDetails['slotEndTime']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onBookingCancelled();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text(
                      'Cancel Booking',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
