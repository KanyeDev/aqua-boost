
import 'package:flutter/material.dart';
class MyTextFormFIeld extends StatelessWidget {
  const MyTextFormFIeld({
    super.key,
    required this.controller,
    required this.returnText,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;
  final String returnText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return returnText;
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        focusColor: const Color(0xffB6D69E),
        focusedBorder: const OutlineInputBorder(),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        hintText: hintText,
      ),
    );
  }
}