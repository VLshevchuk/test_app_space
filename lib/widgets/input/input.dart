import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  late TextEditingController controller;
  late String? labelText;
  late bool obscur;
  late String? Function(String? value) validate;
  late String? placeholder;
  late String? borderStyle;
  late bool marginExist;

  Input(
      {required this.controller,
      this.labelText = '',
      this.obscur = false,
      required this.validate,
      this.placeholder,
      this.marginExist = true,
      this.borderStyle});

  @override
  Column build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          obscureText: obscur,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: borderStyle == 'squard'
                  ? BorderRadius.circular(0)
                  : BorderRadius.circular(10.0),
            ),
            hintText: placeholder ?? 'Type here',
            hintStyle: TextStyle(color: Colors.blueGrey),
            labelText: labelText,
          ),
          validator: validate,
        ),
        SizedBox(
          height: marginExist ? 10 : 0,
        )
      ],
    );
  }
}
