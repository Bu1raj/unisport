import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/custom/widgets/custom_container_1.dart';
import 'package:sports_complex_ms/staff_side_app/models/student.dart';
import 'package:sports_complex_ms/student_side_app/services/issued_items_services.dart';

class IssuedItemsWidget extends StatefulWidget {
  const IssuedItemsWidget({
    super.key,
    required this.studentDetails,
  });

  final Student studentDetails;

  @override
  State<IssuedItemsWidget> createState() => _IssuedItemsWidgetState();
}

class _IssuedItemsWidgetState extends State<IssuedItemsWidget> {
  Map<String, String> eqpNamesIdsMap = {};

  Future<void> loadEquipmentNames(List<String> idList) async {
    final eqpService = IssuedItemsServices();
    eqpNamesIdsMap = await eqpService.fetchCorrespondingEquipmentNames(idList);
  }

  String dateTimeFormatter(DateTime time) {
    final dateTimeFormatter = DateFormat.Hm().add_yMMMd();
    return dateTimeFormatter.format(time);
  }

  bool _isDeadlineCrossed(DateTime deadline) {
    final now = DateTime.now();
    return now.isAfter(deadline);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Issued Equipments',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const Divider(
            color: Colors.black38,
            height: 30,
            endIndent: 7,
            thickness: 0.5,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('issuedEquipments')
                .doc(widget.studentDetails.usn)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error loading data"),
                );
              }
              if (snapshot.hasData) {
                final document = snapshot.data!;
                if (document.exists) {
                  final details = document.data()!;
                  DateTime deadline = details['issuedTime'].toDate().add(
                        const Duration(hours: 5),
                      );
                  final eqpIds = List<String>.from(details['equipmentIds']);
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomContainerOne(
                            width: 165,
                            height: 165,
                            content: FutureBuilder(
                              future: loadEquipmentNames(eqpIds),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${details['sport']}'.toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Equipments',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  color: Colors.white,
                                                ),
                                          ),
                                          const SizedBox(height: 3),
                                          for (final e
                                              in eqpNamesIdsMap.entries)
                                            Text('${e.value} - ${e.key}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    )),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              CustomContainerOne(
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Issued on',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    Text(
                                      dateTimeFormatter(
                                        details['issuedTime'].toDate(),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomContainerOne(
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Deadline',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    Text(
                                      dateTimeFormatter(deadline),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black38,
                        height: 30,
                        endIndent: 7,
                        thickness: 0.5,
                      ),
                      if (_isDeadlineCrossed(deadline))
                        Row(
                          children: [
                            const Icon(
                              Icons.warning,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'You have crossed the deadline',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      if (!_isDeadlineCrossed(deadline))
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_outlined,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'You are within deadline',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.black,
                            size: 17,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Please return the equipments before the deadline',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Text('You have not taken any equipments'),
                    ),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
