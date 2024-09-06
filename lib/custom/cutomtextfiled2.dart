import 'package:flutter/material.dart';

class CustomTextFormFiled2 extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustomTextFormFiled2(
      {super.key,
      required this.hint,
      required this.obscureText,
      required this.controller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.blue[50],
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 2, 26, 39)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
