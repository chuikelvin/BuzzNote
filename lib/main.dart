import 'package:BuzzNote/controllers/usercontroller.dart';
import 'package:BuzzNote/views/sign_in_or_sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:BuzzNote/views/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox("notes");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        // title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialBinding: UserBinding(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Kanit-Light",
        ),

        // home: const SettingsPage(),
        home: Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const MyHomePage();
                } else {
                  return const SignInOrUpPage();
                }
              }),
        ));
  }
}
