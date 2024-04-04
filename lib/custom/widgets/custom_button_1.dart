import 'package:flutter/material.dart';

class CustomButton1 extends StatelessWidget {
  const CustomButton1({
    super.key,
    required this.text,
    required this.onTap,
  });
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      child: Text(text),
    );
  }
}
