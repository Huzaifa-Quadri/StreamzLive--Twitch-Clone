import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:streamzlive/widgets/customButton.dart';
import 'package:streamzlive/widgets/custom_textfiled.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  static const routname = './login';

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _usernamecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Center(
          child: Text(
            'Log in',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(size.height * 0.2),
              const Text(
                'Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              CustomTextField(emailcontroller: _emailcontroller),
              const Gap(20),
              const Text(
                'Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              CustomTextField(emailcontroller: _passwordcontroller),
              const Gap(30),
              CustomButton(text: 'Sign up', onTap: () {})
            ],
          ),
        ),
      ),
    );
  }
}
