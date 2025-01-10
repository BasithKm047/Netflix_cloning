import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:netflix/widgets/bottom_navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), (){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavbar()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Lottie.asset('assets/Animation - 1736315598539.json'),
    );
  }
}