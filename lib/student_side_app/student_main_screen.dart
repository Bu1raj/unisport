import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/staff_side_app/models/student.dart';
//import 'package:sports_complex_ms/student_side_app/arena_booking/arena_main_screen.dart';
import 'package:sports_complex_ms/student_side_app/global_constants/global_constants.dart';
import 'package:sports_complex_ms/student_side_app/widgets/student_main_drawer.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key, required this.userId});

  final String userId;
  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  late final Student studentDetails;
  bool _isLoadingDetails = true;

  Future<void> loadStudentDetails() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final s = snapshot.docs.firstWhere((doc) => doc.id == widget.userId);
    studentUsn = s.data()['usn'];
    studentDetails = Student(
        usn: s.data()['usn'],
        phNo: s.data()['contactNumber'],
        emailId: s.data()['email'],
        name: s.data()['fullName']);
    setState(() {
      _isLoadingDetails = false;
    });
  }

  String dateTimeFormatter(DateTime time) {
    final dateTimeFormatter = DateFormat.Hm().add_yMMMd();
    return dateTimeFormatter.format(time);
  }

  @override
  void initState() {
    loadStudentDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingDetails
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Hi, ${studentDetails.name}'),
              toolbarHeight: 75,
            ),
            drawer: StudentMainDrawer(studentDetails: studentDetails),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Issued Equipments',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('issuedEquipments')
                              .doc(studentDetails.usn)
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
                                DateTime deadline =
                                    details['issuedTime'].toDate().add(
                                          const Duration(hours: 5),
                                        );
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
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
                                      child: Row(
                                        children: [
                                          Column(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                height: 105,
                                                width: 130,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            for (final e in details[
                                                                'equipmentIds'])
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    e,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                  /*const Icon(
                                                                    Icons
                                                                        .arrow_right_alt_rounded,
                                                                    size: 25,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  Text(
                                                                    e,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                            color: Colors
                                                                                .white),
                                                                  )*/
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
                                          const SizedBox(width: 10),
                                          Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      dateTimeFormatter(
                                                        details['issuedTime']
                                                            .toDate(),
                                                      ),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .copyWith(
                                                            color: Colors.white,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      dateTimeFormatter(
                                                          deadline),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .copyWith(
                                                            color: Colors.white,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ], // row
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(30.0),
                                    child: Text(
                                        'You have not taken any equipments'),
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
                  ),
                  /*const SizedBox(height: 40),
                  InkWell(
                    onTap: () async {
                      final Map? details = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const ArenaMainScreen(),
                        ),
                      );
                      if(details != null){

                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Book an arena',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          );
  }
}
