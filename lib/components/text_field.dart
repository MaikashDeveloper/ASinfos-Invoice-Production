// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String lableText;
  TextEditingController controller;
  MyTextField({super.key, required this.lableText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lableText,
        ),
        controller: controller,
      ),
    );
  }
}
