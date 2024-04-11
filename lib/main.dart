import 'package:aquaboost/screens/auth/login.dart';
import 'package:aquaboost/screens/main/main_screen.dart';
import 'package:aquaboost/screens/splash/splash_screen.dart';
import 'package:aquaboost/utilities/scrollBehaviour.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,scrollBehavior: MyCustomScrollBehavior(),
      title: 'Aqua Boost',
      theme: ThemeData(

        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
