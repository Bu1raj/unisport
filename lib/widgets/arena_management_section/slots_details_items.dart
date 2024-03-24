import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_complex_ms/models/student.dart';

class SlotsDetailsItem extends StatefulWidget {
  const SlotsDetailsItem({
    super.key,
    required this.slotDetails,
    required this.index,
  });

  final Map<String, String?> slotDetails;
  final int index;
  @override
  State<SlotsDetailsItem> createState() {
    return _SlotsDetailsItemState();
  }
}

class _SlotsDetailsItemState extends State<SlotsDetailsItem> {
  Future<Student> loadStudentDetails(String usn) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final s = snapshot.docs.firstWhere((doc) =>
        doc.data()['userType'] == 'student' && doc.data()['usn'] == usn);

    final studentDetails = Student(
        usn: s.data()['usn'],
        phNo: s.data()['contactNumber'],
        emailId: s.data()['email'],
        name: s.data()['fullName']);
    return studentDetails;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.slotDetails['bookedBy'] == null ||
            widget.slotDetails['bookedBy']!.isEmpty) {
          showDialog(
            context: context,
            builder: (ctx) => SimpleDialog(
              contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 20.0, 20.0),
              title: const Text('Free Slot'),
              children: [
                const Text('No one has booked this slot...'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Okay'),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (ctx) => FutureBuilder(
                future: loadStudentDetails(widget.slotDetails['bookedBy']!),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return const SimpleDialog(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    );
                  }

                  return SimpleDialog(
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                    title: const Text('Slot booked by'),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            snapshot.data!.name,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 20,
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(width: 5),
                              Text(snapshot.data!.usn),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.call),
                              const SizedBox(width: 5),
                              Text(snapshot.data!.phNo),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.email_outlined),
                              const SizedBox(width: 5),
                              Text(snapshot.data!.emailId),
                            ],
                          ),
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
                          ),
                        ],
                      ),
                    ],
                  );
                }),
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
