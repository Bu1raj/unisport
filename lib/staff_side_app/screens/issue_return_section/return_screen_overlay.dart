import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/common_widgets/issued_items_table_widget.dart';
import 'package:sports_complex_ms/common_widgets/time_container_widget.dart';
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
        return Padding(
          padding: EdgeInsets.only(
            top: 30,
            left: 25,
            right: 25,
            bottom: 8,
          ),
          child: _isLoading
              ? SizedBox(
                  height: constraints.minHeight,
                  width: constraints.minWidth,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
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
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 0.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Issued items",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    )),
                            Text(
                                "Sport: ${widget.issuedEquipmentsReturnData.sport}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    )),
                          ]),
                    ),
                    IssuedItemsTableWidget(
                      equipmentsMap: equipmentNames,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                            child: TimeContainer(
                          text: 'Issued Time',
                          time: widget.issuedEquipmentsReturnData.issuedTime
                              .toDate(),
                        )),
                        const SizedBox(width: 5),
                        Expanded(
                            child: TimeContainer(
                          text: 'Deadline',
                          time: deadline,
                        )),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Theme.of(context).colorScheme.primaryContainer,
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
                      height: 8,
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
        );
      },
    );
  }
}
