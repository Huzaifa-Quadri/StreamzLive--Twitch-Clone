import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:streamzlive/resources/auth_Methods.dart';
import 'package:streamzlive/screens/home.dart';
import 'package:streamzlive/widgets/customButton.dart';
import 'package:streamzlive/widgets/custom_textfiled.dart';
import 'package:streamzlive/widgets/loading_indicator.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  static const routname = './login';

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final AuthMethods _auth = AuthMethods();
  bool loading = false;

  void login() async {
    setState(() {
      loading = true;
    });
    bool res = await _auth.logInUser(
        _emailcontroller.text, _passwordcontroller.text, context);

    // print('\n\n Is User Succesfully Logged in ? $res \n\n');

    if (res && mounted) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routename);

      setState(() {
        loading = false;
      });
      _emailcontroller.clear();
      _passwordcontroller.clear();
    } else {
      setState(() {
        loading = false;
      });
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
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
              CustomTextField(textcontroller: _emailcontroller),
              const Gap(20),
              const Text(
                'Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              CustomTextField(textcontroller: _passwordcontroller),
              const Gap(30),
              loading
                  ? const Loadingindicator()
                  : CustomButton(text: 'Log in', onTap: login)
            ],
          ),
        ),
      ),
    );
  }
}
