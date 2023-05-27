import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:score_app/screens/homeScreen.dart';
import 'package:score_app/screens/splashScreen.dart';

import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Score App',
      theme: ThemeData(
        fontFamily: 'RobotoSlab',
        primarySwatch: Colors.amber,
      ),
      home: const SplashScreen(),
    );
  }
}
