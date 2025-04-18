import 'package:flutter/material.dart';
import 'package:streamzlive/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textcontroller;
  const CustomTextField({super.key, required this.textcontroller, this.onTap});
  final Function(String)? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onTap,
      controller: textcontroller,
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
