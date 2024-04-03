import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_complex_ms/staff_side_app/screens/auth.dart';
import 'package:sports_complex_ms/staff_side_app/screens/splash_screen.dart';
import 'package:sports_complex_ms/staff_side_app/screens/tabs_screen.dart';
import 'package:sports_complex_ms/student_side_app/student_main_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportsComplexManager',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          primary: const Color.fromARGB(255, 14, 80, 96),
          tertiary: const Color.fromARGB(255, 1, 86, 52),
          brightness: Brightness.light,
          seedColor: const Color.fromARGB(255, 86, 97, 114),
        ),
        //scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.openSansTextTheme(),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 86, 97, 114),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 14, 80, 96),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            const SplashScreen();
          }

          if (snapshot.hasData) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      userSnapshot) {
                if (userSnapshot.hasData) {
                  final userData = userSnapshot.data!.data()!;
                  if (userData['userType'] == 'staff') {
                    return const TabScreen();
                  }
                  return StudentMainScreen(userId : userSnapshot.data!.id);
                }
                return const SplashScreen();
              },
            );
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
