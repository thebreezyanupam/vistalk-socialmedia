import 'package:flutter/material.dart';

class CustomPostButton extends StatelessWidget {
  final void Function()? onTap;
  const CustomPostButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(left:10),
        child: const Center(child: Icon(Icons.done),),
      ),
    );
  }
}
