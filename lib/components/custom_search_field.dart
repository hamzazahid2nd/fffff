import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Function(PointerDownEvent)? onTapOutside;

  const CustomSearchField({super.key, 
    required this.hintText,
    required this.onChanged,
    required this.onFieldSubmitted,
    required this.controller,
    
    required this.onTapOutside,
  });

  InputBorder getBorder({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      width: double.infinity,
      child: TextFormField(
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          enabledBorder: getBorder(color: Colors.grey),
          focusedBorder: getBorder(color: Colors.grey),
          errorBorder: getBorder(color: Colors.red),
          focusedErrorBorder: getBorder(color: Colors.red),
        ),
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        onChanged: onChanged,
        
        onTapOutside:onTapOutside,
      ),
    );
  }
}
