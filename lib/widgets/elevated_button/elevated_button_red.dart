import 'package:flutter/material.dart';

class ElevatedButtonRed extends StatelessWidget {
  const ElevatedButtonRed({
    required this.activeText,
    this.isActive = false,
    this.onPressed,
    super.key,
  });

  final String activeText;
  final bool isActive;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive
              ? Colors.red
              : Colors.grey[350],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
          child: Text(activeText),
        ));
  }
}
