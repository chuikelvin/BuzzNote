import 'package:BuzzNote/controllers/usercontroller.dart';
import 'package:BuzzNote/views/sign_in_or_sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:BuzzNote/views/homepage.dart';
import 'package:BuzzNote/views/homepage copy.dart';
// import 'controllers/usercontroller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox("notes");
  await Hive.openBox("startup");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Box startup;
  // final userController = Get.find<UserController>();
  bool existLocal = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startup = Hive.box("startup");
    startup.isEmpty ? null : useValues();
  }

  useValues() {
    // print(startup.length);

    // for (var item in startup.values) {
    //   userController.updateDisplayName(item);
    // }
    setState(() {
      existLocal = true;
    });
  }

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
        routes: <String, WidgetBuilder>{
          '/screen1': (BuildContext context) => SignInOrUpPage(),
          // '/screen2' : (BuildContext context) => Screen2(),
          // '/screen3' : (BuildContext context) => Screen3(),
          // '/screen4' : (BuildContext context) => Screen4()
        },
        home: Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const MyHomePage();
                } else {
                  return SignInOrUpPage(
                    isLocal: existLocal,
                  );
                }
              }),
        ));
  }
}
