import 'package:flutter/material.dart';

import 'dart:async';

import 'package:myapp/pages/loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
               Colors.blue, Color.fromARGB(255, 114, 149, 243)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              //tileMode: TileMode.clamp,
              //stops: [0.0, 1.0],
            ),
          ),
        ),
        const Center(
          child: Text("YIGUI",
              style: TextStyle(
                fontSize: 30.0,
              )),
        )
      ],
    ));
  }
}