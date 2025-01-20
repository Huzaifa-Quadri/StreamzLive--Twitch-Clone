import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:streamzlive/widgets/customButton.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  // static const routName = '.login/';

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome  to \nStreamzyLive",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const Gap(25),
            CustomButton(text: 'Log in', onTap: () {}),
            const Gap(8),
            CustomButton(
              text: 'Sign up',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
