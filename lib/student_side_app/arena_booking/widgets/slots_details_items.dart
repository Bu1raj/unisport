import 'package:flutter/material.dart';
import 'package:sports_complex_ms/staff_side_app/services/arena_management_query.dart';
import 'package:sports_complex_ms/student_side_app/global_constants/global_constants.dart';

class SlotsDetailsItem extends StatefulWidget {
  const SlotsDetailsItem({
    super.key,
    required this.slotDetails,
    required this.index,
    required this.parentContext,
  });

  final Map<String, String?> slotDetails;
  final int index;
  final BuildContext parentContext;
  @override
  State<SlotsDetailsItem> createState() {
    return _SlotsDetailsItemState();
  }
}

class _SlotsDetailsItemState extends State<SlotsDetailsItem> {
  Future<void> bookASlot() async {
    await ArenaManagementQuery().bookASlot(widget.slotDetails['slotNo']!,
        widget.slotDetails['arenaId']!, studentUsn, context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.slotDetails['bookedBy'] == null) {
          showDialog(
            context: context,
            builder: (ctx) => StatefulBuilder(
              builder: (ctx, setState) {
                bool isBooking = false;
                return SimpleDialog(
                  contentPadding:
                      const EdgeInsets.fromLTRB(25.0, 10.0, 20.0, 20.0),
                  title: const Text('Free Slot'),
                  children: [
                    const Text('Book this slot ??'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            setState(() {
                              isBooking = true;
                            });
                            await bookASlot();
                            setState(() {
                              isBooking = false;
                            });
                            if (ctx.mounted) {
                              Navigator.of(ctx).pop();
                              Navigator.of(widget.parentContext).pop(
                                {"slotDetails": widget.slotDetails},
                              );
                            }
                          },
                          child: isBooking
                              // ignore: dead_code
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Yes'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (ctx) => SimpleDialog(
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
              title: const Text('This slot is not free'),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Okay'),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Slot ${widget.index + 1}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 35),
              Row(
                children: [
                  Icon(
                    Icons.hourglass_bottom_rounded,
                    size: 30,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Slot timings',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                      ),
                      //const SizedBox(height: 2),
                      Text(
                        '${widget.slotDetails['slotStartTime']!} - ${widget.slotDetails['slotEndTime']}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 40),
              widget.slotDetails['bookedBy'] == null
                  ? Row(
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          size: 30,
                          color: Colors.green.shade800,
                        ),
                        Text(
                          'Free',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.green.shade800,
                                  ),
                        ),
                      ],
                    )
                  : Icon(
                      Icons.event_busy_rounded,
                      size: 30,
                      color: Colors.red.shade800,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/*String timeFormatter(TimeOfDay tod, BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    final formattedTod = localizations.formatTimeOfDay(
      tod,
      alwaysUse24HourFormat: true,
    );

    return formattedTod;
  }*/
