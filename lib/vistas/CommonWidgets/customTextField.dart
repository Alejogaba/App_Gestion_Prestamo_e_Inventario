import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.customController,
      required this.labelText,
      required this.isPassword})
      : super(key: key);

  final TextEditingController customController;
  final String labelText;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: TextField(
          style: TextStyle(fontSize: 20),
          controller: customController,
          obscureText: this.isPassword,
          decoration: InputDecoration(
            fillColor: Colors.green[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            filled: true,
            hintStyle: TextStyle(fontSize: 20),
            labelStyle: TextStyle(fontSize: 20),
            hintText: this.labelText,
          ),
          onSubmitted: (String nombre) {}),
    );
  }
}
