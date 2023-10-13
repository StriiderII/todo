import 'package:flutter/material.dart';
import 'package:todo/Theme_settings/MyTheme.dart';

typedef Validator = String? Function(String?);

class CustomTextFormField extends StatefulWidget {
  String label;
  TextInputType keyboardType;
  bool isPassword;

  TextEditingController controller;
  Validator myValidator;

  CustomTextFormField({
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    required this.controller,
    required this.myValidator,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(
            widget.label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: MyTheme.GreyColorText,
                ),
          ),


          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  child: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
        ),
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword && !isPasswordVisible,
        controller: widget.controller,
        validator: widget.myValidator,
      ),
    );
  }
}
