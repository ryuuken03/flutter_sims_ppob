import 'package:flutter/material.dart';

class ProgressLoading extends StatelessWidget {
  const ProgressLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
