import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:streamzlive/screens/home.dart';
import 'package:streamzlive/widgets/customButton.dart';
import 'package:streamzlive/widgets/custom_textfiled.dart';
import 'package:streamzlive/resources/auth_Methods.dart';
import 'package:streamzlive/widgets/loading_indicator.dart';

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
  bool _isloading = false;

  void _signupuser() async {
    setState(() {
      _isloading = true;
    });
    bool res = await _authMethods.signup(
      _usernamecontroller.text,
      _emailcontroller.text,
      _passwordcontroller.text,
      context,
    );
    setState(() {
      _isloading = false;
    });
    if (res && mounted) {
      Navigator.pushReplacementNamed(context, HomeScreen.routename);
    }
  }

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
              CustomTextField(textcontroller: _usernamecontroller),
              const Gap(20),
              const Text(
                'Email',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              CustomTextField(textcontroller: _emailcontroller),
              const Gap(20),
              const Text(
                'Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              CustomTextField(textcontroller: _passwordcontroller),
              const Gap(30),
              _isloading
                  ? const Loadingindicator()
                  : CustomButton(text: 'Sign up', onTap: _signupuser)
            ],
          ),
        ),
      ),
    );
  }
}
