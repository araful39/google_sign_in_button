import 'package:flutter/material.dart';
import 'package:google_button/src/home.dart';
import 'package:google_button/src/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    checking();
    super.initState();
  }

  checking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogIn = prefs.getBool('isLogIn');
    if (isLogIn == true) {
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Welcome",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
