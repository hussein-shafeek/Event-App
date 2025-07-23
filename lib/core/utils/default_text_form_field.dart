import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DefaultTextFormField extends StatelessWidget {
  String hintText;
  TextEditingController? controller;
  void Function(String)? onChanged;
  String? prefixIconImageName;

  DefaultTextFormField({
    required this.hintText,
    this.controller,
    this.onChanged,
    this.prefixIconImageName,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon:
            prefixIconImageName == null
                ? null
                : SvgPicture.asset(
                  'assets/icons/$prefixIconImageName.svg',
                  height: 24,
                  width: 24,
                  fit: BoxFit.scaleDown,
                ),
      ),
    );
  }
}
