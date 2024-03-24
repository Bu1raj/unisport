import 'package:flutter/material.dart';
import 'package:sports_complex_ms/student_side_app/arena_booking/slot_details.dart';

class ArenaItem extends StatelessWidget {
  const ArenaItem({
    super.key,
    required this.nameId,
    required this.sport,
    required this.slotDetails,
    required this.parentContext,
  });

  final String sport;
  final Map<String, String> nameId;
  final List<Map<String, String?>> slotDetails;
  final BuildContext parentContext;

  String checkForFreeSlots() {
    final temp = slotDetails.where((e) => e['bookedBy'] == null).toList();

    if (temp.isEmpty) {
      return 'Fully Booked';
    }
    return 'Free slots available';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 10.0),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                nameId['arenaName']!,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () async {
                final Map? details = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => SlotsDetailsScreen(
                      slotsDetails: slotDetails,
                      arenaName: nameId['arenaName']!,
                      sport: sport,
                    ),
                  ),
                );
                if (details != null) {
                  details['arenaName'] = nameId['arenaName'];
                  if(context.mounted){
                    Navigator.of(parentContext).pop(
                      details,
                  );
                  }
                }
              },
              splashColor: Colors.black12,
              borderRadius: BorderRadius.circular(16.0),
              child: Card(
                //margin: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.hardEdge,
                elevation: 2,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets\\arena_images\\$sport.jpg',
                      fit: BoxFit.cover,
                      height: 250,
                      width: double.infinity,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              checkForFreeSlots(),
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
