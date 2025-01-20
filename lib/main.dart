import 'package:flutter/material.dart';
import 'package:streamzlive/screens/home.dart';
import 'package:streamzlive/screens/loginScreen.dart';
import 'package:streamzlive/screens/onboardingScreen.dart';
import 'package:streamzlive/screens/signupScreen.dart';
import 'package:streamzlive/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamZ Live',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: backgroundColor,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: primaryColor),
        ),
      ),
      routes: {
        OnBoardingScreen.routName: (context) => const OnBoardingScreen(),
        Loginscreen.routname: (context) => const Loginscreen(),
        SignUpScreen.routname: (context) => const SignUpScreen(),
        HomeScreen.routename: (context) => const HomeScreen()
      },
      home: const OnBoardingScreen(),
    );
  }
}
