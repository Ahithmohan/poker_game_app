import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'date_input_formatter.dart'; // Import the custom formatter

class DateTextFormField extends StatelessWidget {
  final bool obscureText;
  final String? hintText;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const DateTextFormField({
    super.key,
    this.obscureText = false,
    this.suffixIcon,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.hintText,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 67, // Increased to account for potential error text
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Stack(
              children: [
                TextFormField(
                  keyboardType: keyboardType ?? TextInputType.datetime,
                  controller: controller,
                  style: const TextStyle(fontSize: 17),
                  obscureText: obscureText,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF5F6368),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          const BorderSide(color: Colors.black26, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          const BorderSide(color: Colors.black26, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  validator: (value) {
                    // Default validator if not provided
                    if (validator != null) {
                      return validator!(value);
                    }
                    // Validate the date format
                    if (value == null || value.isEmpty) {
                      return 'Date is required';
                    }
                    if (value.length != 10) {
                      return 'Enter a valid date (mm/dd/yyyy)';
                    }
                    return null;
                  },
                  inputFormatters: inputFormatters ??
                      [DateInputFormatter()], // Apply the custom formatter
                ),
                if (suffixIcon != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 19),
                      child: suffixIcon,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
