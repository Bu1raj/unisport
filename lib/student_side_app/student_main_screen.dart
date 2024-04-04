import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_complex_ms/staff_side_app/models/student.dart';
import 'package:sports_complex_ms/student_side_app/widgets/issued_items_widget.dart';
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
  Map<String, String> eqpNames = {};

  Future<void> loadStudentDetails() async {
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IssuedItemsWidget(studentDetails: studentDetails),
                ],
              ),
            ),
          );
  }
}
