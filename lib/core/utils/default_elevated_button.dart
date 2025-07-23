import 'package:flutter/material.dart';

class DefaultElevatedButton extends StatelessWidget {
  String label;
  VoidCallback onPressed;

  DefaultElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    TextTheme text = Theme.of(context).textTheme;
    //double height = MediaQuery.sizeOf(context).height;
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label, style: text.titleLarge),
      style: ElevatedButton.styleFrom(fixedSize: Size(width, 56)),
    );
  }
}
