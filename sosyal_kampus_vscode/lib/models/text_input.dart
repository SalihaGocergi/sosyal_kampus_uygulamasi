import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  String labelName;
  var controller = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool passwordType;
  Function valid;

  TextInputWidget(
      this.labelName, this.controller, this.passwordType, this.valid);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: passwordType,
        validator: valid,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelName,
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }
}
