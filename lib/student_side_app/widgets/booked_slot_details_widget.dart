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
    return Card(
      elevation: 5,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
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
            Row(
              children: [
                const Icon(Icons.stadium),
                const SizedBox(width: 10),
                Text(
                  'Arena ID - ${widget.bookedSlotDetails['arenaId']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Slot Number - ${widget.bookedSlotDetails['slotNo']!.substring(widget.bookedSlotDetails['slotNo']!.length - 1)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.hourglass_bottom_outlined),
                const SizedBox(width: 10),
                Text(
                  'Slot Timings - ${widget.bookedSlotDetails['slotStartTime']} - ${widget.bookedSlotDetails['slotEndTime']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onBookingCancelled();
                  },
                  child: const Text(
                    'Cancel Booking',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
