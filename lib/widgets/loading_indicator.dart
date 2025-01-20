import 'package:flutter/material.dart';

class Loadingindicator extends StatelessWidget {
  const Loadingindicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
