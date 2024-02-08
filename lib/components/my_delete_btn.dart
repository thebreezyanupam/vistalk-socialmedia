import 'package:flutter/material.dart';

class MyDeleteBtn extends StatelessWidget {
  final void Function()? onTap;
  const MyDeleteBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.cancel, color: Theme.of(context).colorScheme.inversePrimary,),
    );
  }
}
