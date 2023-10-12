import 'package:flutter/material.dart';

class ElevatedButtonRedOutline extends StatelessWidget {
  const ElevatedButtonRedOutline({
    required this.activeText,
    this.onPressed,
    super.key,
  });

  final String activeText;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                  width: 1, // thickness
                  color: Colors.red // color
                  ),
              // border radius
              borderRadius: BorderRadius.circular(4)
            )
          ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
          child: Text(
            activeText,
            style: TextStyle(
              color: Colors.red
            ),
          ),
        ));
  }
}
