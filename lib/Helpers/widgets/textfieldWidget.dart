import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  bool? enabled;
  TextFieldWidget(
      {super.key,
      required this.label,
      required this.controller,
      this.obscureText,
      this.keyboardType,
      this.enabled});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: label == "Mobile Number" ? 10 : null,
      inputFormatters: [
        label == "Mobile Number"
            ? FilteringTextInputFormatter.digitsOnly
            : FilteringTextInputFormatter.singleLineFormatter
      ],
      decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
          ),
          enabled: enabled ?? true,
          counterText: ""),
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
    );
    ;
  }
}
