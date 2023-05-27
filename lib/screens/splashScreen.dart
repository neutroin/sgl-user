import 'package:flutter/material.dart';
import 'package:score_app/screens/homeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _navigateTo() async {
    await Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => HomeScreen())));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateTo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Image.asset('assets/images/SGL-SPLASH-SCREEN.gif')),
      ),
    );
  }
}
