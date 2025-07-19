import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/student_side_app/models/arena_booking/booking_details.dart';
import 'package:sports_complex_ms/student_side_app/providers/arena_details_provider.dart';

class BookedSlotDetailsWidget extends ConsumerWidget {
  const BookedSlotDetailsWidget({
    super.key,
    required this.usn,
    required this.bookedSlotDetails,
  });

  final String usn;
  final BookingDetails bookedSlotDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 1.0,
            offset: Offset(0, 1),
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
                    bookedSlotDetails.arenaId,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Text(
                'Slot Number - ${bookedSlotDetails.slotNo.substring(bookedSlotDetails.slotNo.length - 1)}',
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
                    '${bookedSlotDetails.slotStartTime} - ${bookedSlotDetails.slotEndTime}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text(
                          'Cancel Booking',
                          style: TextStyle(
                              color: Theme.of(ctx).colorScheme.primary),
                        ),
                        content: const Text(
                            'Are you sure you want to cancel this booking?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('No'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await ref
                                  .read(bookedArenaDetailsProvider.notifier)
                                  .cancelBooking(usn, context);
                              if (ctx.mounted) {
                                Navigator.of(ctx).pop();
                              }
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
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
    );
  }
}
