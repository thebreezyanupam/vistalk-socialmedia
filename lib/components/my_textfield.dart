import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.white54)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
           borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.0)
          ),
          hintText: hintText,
      ),
      obscureText: obscureText,



    );
  }
}
