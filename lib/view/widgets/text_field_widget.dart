import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const TextFieldWidget(
      {super.key, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          hintText: hint),
      controller: controller,
    );
  }
}

class PasswordTextFieldWidget extends TextFieldWidget {
  const PasswordTextFieldWidget({super.key, required super.hint, required super.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          hintText: hint),
          obscureText: true,
      controller: controller,
    );
  }
}
