import 'package:evently/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class DefaultElevatedButton extends StatelessWidget {
  String label;
  VoidCallback onPressed;
  Color? backgroundColor;
  Color? foregroundColor;
  String? prefixSvgPath;

  DefaultElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.prefixSvgPath,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    TextTheme text = Theme.of(context).textTheme;
    //double height = MediaQuery.sizeOf(context).height;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, 56),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: BorderSide(color: AppColors.primary, width: 2),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixSvgPath != null) ...[
            SvgPicture.asset(prefixSvgPath!, width: 24, height: 24),

            SizedBox(width: width * 0.020),
          ],
          Text(label, style: text.titleLarge),
        ],
      ),
    );
  }
}
