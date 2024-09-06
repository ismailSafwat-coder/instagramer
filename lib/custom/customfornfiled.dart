import 'package:flutter/material.dart';

class CustomTextFormFieldAuth extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextFormFieldAuth({
    super.key,
    required this.hint,
    required this.obscureText,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
