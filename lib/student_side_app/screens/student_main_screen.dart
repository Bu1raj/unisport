import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/student_side_app/providers/student_details_provider.dart';
import 'package:sports_complex_ms/student_side_app/widgets/arena_booking_widget.dart';
import 'package:sports_complex_ms/student_side_app/widgets/issued_items_widget.dart';
import 'package:sports_complex_ms/student_side_app/widgets/student_main_drawer.dart';
import 'package:sports_complex_ms/student_side_app/widgets/tournament_list_widget.dart';

class StudentMainScreen extends ConsumerStatefulWidget {
  const StudentMainScreen({super.key, required this.userId});

  final String userId;
  @override
  ConsumerState<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends ConsumerState<StudentMainScreen> {
  //late final Student studentDetails;
  //bool _isLoadingDetails = true;
  Map<String, String> eqpNames = {};

  /*Future<void> loadStudentDetails() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final s = snapshot.docs.firstWhere((doc) => doc.id == widget.userId);
    //studentUsn = s.data()['usn'];
    studentDetails = Student(
        usn: s.data()['usn'],
        phNo: s.data()['contactNumber'],
        emailId: s.data()['email'],
        name: s.data()['fullName']);
    setState(() {
      _isLoadingDetails = false;
    });
  }*/

  @override
  void initState() {
    //loadStudentDetails();
    ref
        .read(studentDetailsProvider.notifier)
        .fetchStudentDetails(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final studentDetails = ref.watch(studentDetailsProvider);

    return studentDetails == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Text('Hi, ${studentDetails.name}'),
                toolbarHeight: 75,
              ),
              drawer: StudentMainDrawer(studentDetails: studentDetails),
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IssuedItemsWidget(studentDetails: studentDetails),
                      const SizedBox(height: 20),
                      ArenaBookingWidget(
                        studentUsn: studentDetails.usn,
                      ),
                      const SizedBox(height: 20),
                      const AvailableTournamentsList(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
        );
  }
}
