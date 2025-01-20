import 'package:flutter/material.dart';
import 'package:streamzlive/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController emailcontroller;
  const CustomTextField({super.key, required this.emailcontroller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailcontroller,
      decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: buttonColor, width: 2),
          ),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
    );
  }
}
