import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.changeSection,
  });
  final void Function(int) changeSection;
  @override
  Widget build(BuildContext context) {
    final sectionList = [
      'Issue Return',
      'Arena Management',
      'Inventory Management',
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
                Text(
                  'Sections',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white, fontSize: 27),
                ),
                const Spacer(),
              ],
            ),
          ),
          for (int i = 0; i < 3; i++)
            ListTile(
              shape: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.black26,
                ),
              ),
              title: Text(
                sectionList[i],
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 17),
              ),
              onTap: () {
                changeSection(i);
              },
            ),
          const Spacer(),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 150, 40),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: const Color.fromARGB(255, 199, 15, 2),
                    fontSize: 17,
                  ),
            ),
            trailing: const Icon(
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
