import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:streamzlive/screens/home.dart';
import 'package:streamzlive/widgets/customButton.dart';
import 'package:streamzlive/widgets/custom_textfiled.dart';
import 'package:streamzlive/resources/auth_Methods.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routname = './signup';

  @override
  State<SignUpScreen> createState() => _SigUpScreenState();
}

class _SigUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();

  final AuthMethods _authMethods = AuthMethods();

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
            'Sign Up',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(size.height * 0.1),
              const Text(
                'Username',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              CustomTextField(emailcontroller: _usernamecontroller),
              const Gap(20),
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
