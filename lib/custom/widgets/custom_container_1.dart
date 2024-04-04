import 'package:flutter/material.dart';

class CustomContainerOne extends StatelessWidget {
  const CustomContainerOne({
    super.key,
    required this.content,
    this.width,
    this.height,  
  });

  final Widget content;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.primary,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: content,
    );
  }
}
