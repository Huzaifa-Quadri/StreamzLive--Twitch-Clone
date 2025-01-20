import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamzlive/resources/userprovider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routename = './home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Current username')),
    );
  }
}
