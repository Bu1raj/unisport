import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/staff_side_app/models/issue_return_section/issued_equipments.dart';
import 'package:sports_complex_ms/staff_side_app/models/student.dart';
import 'package:sports_complex_ms/staff_side_app/providers/issued_items_provider.dart';
import 'package:sports_complex_ms/staff_side_app/services/get_free_equipments.dart';

class ReturnScreenOverlay extends ConsumerStatefulWidget {
  const ReturnScreenOverlay({
    super.key,
    required this.issuedEquipmentsReturnData,
    required this.parentContext,
  });

  final IssuedEquipments issuedEquipmentsReturnData;
  final BuildContext parentContext;

  @override
  ConsumerState<ReturnScreenOverlay> createState() {
    return _ReturnScreenOverlayState();
  }
}

class _ReturnScreenOverlayState extends ConsumerState<ReturnScreenOverlay> {
  Student studentDetails = Student(usn: '', phNo: '', emailId: '', name: '');
  Map<String, String> equipmentNames = {};
  bool _isLoading = true;
  bool _isReturning = false;

  Future<void> getEmailIdPhoneNumber(String usn) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final s = snapshot.docs.firstWhere((doc) =>
        doc.data()['userType'] == 'student' && doc.data()['usn'] == usn);

    studentDetails = Student(
        usn: s.data()['usn'],
        phNo: s.data()['contactNumber'],
        emailId: s.data()['email'],
        name: s.data()['fullName']);
  }

  Future<void> getEquipmentNames(List<String> ids) async {
    equipmentNames =
        await EquipmentQuery().fetchCorrespondingEquipmentNames(ids);
  }

  String dateTimeFormatter(DateTime time) {
    final dateTimeFormatter = DateFormat.Hm().add_yMMMd();
    return dateTimeFormatter.format(time);
  }

  Future<void> loadDetails() async {
    await getEmailIdPhoneNumber(widget.issuedEquipmentsReturnData.usn);
    await getEquipmentNames(
        widget.issuedEquipmentsReturnData.issuedEquipmentsIds);

    if (studentDetails.usn.isNotEmpty && equipmentNames.isNotEmpty) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> confirmReturn(List<String> idsToBeFreed) async {
    await ref.read(issuedEquipmentsDetailsProvider.notifier).freeEquipments(
        widget.issuedEquipmentsReturnData.usn, widget.parentContext);
    await EquipmentQuery().freeIssued(idsToBeFreed);

    setState(() {
      _isReturning = false;
    });
  }

  @override
  void initState() {
    loadDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime deadline =
        widget.issuedEquipmentsReturnData.issuedTime.toDate().add(
              const Duration(hours: 5),
            );

    bool deadLineCrossed = DateTime.now().isAfter(deadline);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.minWidth,
            maxHeight: constraints.maxHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 30,
                                  ),
                                  Text(
                                    studentDetails.usn,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.call,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    studentDetails.phNo,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    studentDetails.emailId,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.primaryContainer,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 1.0),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, bottom: 10),
                                child: Text(
                                  equipmentList.first.sport,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 5),*/
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 1.0),
                                            blurRadius: 3.0,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Issued Items',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            height: 105,
                                            width: 130,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        for (final e
                                                            in equipmentNames
                                                                .entries)
                                                          Row(
                                                            children: [
                                                              Text(
                                                                e.value,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .white),
                                                              ),
                                                              const Icon(
                                                                Icons
                                                                    .arrow_right_alt_rounded,
                                                                size: 25,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              Text(
                                                                e.key,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .white),
                                                              )
                                                            ],
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(0.0, 1.0),
                                                blurRadius: 3.0,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Issued Time',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                dateTimeFormatter(
                                                  widget
                                                      .issuedEquipmentsReturnData
                                                      .issuedTime
                                                      .toDate(),
                                                ),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                offset: Offset(0.0, 1.0),
                                                blurRadius: 3.0,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Deadline',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                dateTimeFormatter(deadline),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.primaryContainer,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 1.0),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: deadLineCrossed
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    'deadline crossed',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.red),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    'within deadline',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.green),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          deadLineCrossed
                              ? TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Penalize',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                )
                              : Container(),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: () {
                              setState(() {
                                _isReturning = true;
                              });
                              confirmReturn(widget.issuedEquipmentsReturnData
                                  .issuedEquipmentsIds);
                              Navigator.of(context).pop();
                            },
                            child: _isReturning
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Returned'),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
