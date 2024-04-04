import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/models/student.dart';

class StudentDetailsNotifier extends StateNotifier<Student?> {
  StudentDetailsNotifier() : super(null);

  Future<void> fetchStudentDetails(userId) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final s = snapshot.docs.firstWhere((doc) => doc.id == userId);

    final studentDetails = Student(
        usn: s.data()['usn'],
        phNo: s.data()['contactNumber'],
        emailId: s.data()['email'],
        name: s.data()['fullName']);
    state = studentDetails;
  }
}

final studentDetailsProvider =
    StateNotifierProvider<StudentDetailsNotifier, Student?>(
  (ref) => StudentDetailsNotifier(),
);
