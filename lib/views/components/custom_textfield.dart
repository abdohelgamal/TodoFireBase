import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {required this.controller,
      required this.hint,
      required this.label,
      this.type = TextInputType.text,
      this.obscure = false,
      Key? key})
      : super(key: key);
  TextEditingController controller;
  bool obscure;
  String label;
  String hint;
  TextInputType type;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hint),
      keyboardType: type,
    );
  }
}
