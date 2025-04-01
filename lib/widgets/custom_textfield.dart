import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType; 
    final TextEditingController? controller; 

  const CustomTextField({
    super.key,
    required this.label,
    required this.onSaved,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
        this.controller, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller, 
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        obscureText: obscureText,
        onSaved: onSaved,
        validator: validator,
        keyboardType: keyboardType, 
      ),
    );
  }
}
