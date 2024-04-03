import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_complex_ms/staff_side_app/models/student.dart';

class StudentMainDrawer extends StatelessWidget {
  const StudentMainDrawer({
    super.key,
    required this.studentDetails,
  });
  final Student studentDetails;
  @override
  Widget build(BuildContext context) {
    final sectionList = [
      studentDetails.usn,
      studentDetails.emailId,
      studentDetails.phNo,
    ];
    const iconList = [
      Icon(Icons.person),
      Icon(Icons.email),
      Icon(Icons.call),
    ];
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.only(top: 55, left: 17),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 86, 97, 114),
            ),
            child: Row(
              children: [
                SizedBox(
                  child: Text(
                    studentDetails.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white, fontSize: 27),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          for (int i = 0; i < 3; i++)
            ListTile(
              /*shape: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.black26,
                ),
              ),*/
              leading: iconList[i],
              title: Text(
                sectionList[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 17),
              ),
            ),
          const Spacer(),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 50, 40),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: const Color.fromARGB(255, 199, 15, 2),
                    fontSize: 17,
                  ),
            ),
            leading: const Icon(
              Icons.logout_rounded,
              color: Color.fromARGB(255, 199, 15, 2),
            ),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
