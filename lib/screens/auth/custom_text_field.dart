import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final bool obscureText;
  final FocusNode? focusNode;
  final int? maxLength;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.keyboardType,
    required this.textInputAction,
    required this.onFieldSubmitted,
    required this.validator,
    required this.onSaved,
    required this.focusNode,
    this.controller,
    this.maxLength,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        key: ValueKey(key),
        decoration: InputDecoration(
          counterText: '',
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.shade100,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
        ),
        maxLength: maxLength,
        focusNode: focusNode,
        obscureText: obscureText,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        validator: validator,
        onSaved: onSaved,
        inputFormatters: const [],
      ),
    );
  }
}
