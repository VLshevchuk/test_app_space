import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:space_chat/bloc/auth/auth_bloc.dart';
import 'package:space_chat/pages/auth/helpers.dart';
import 'package:space_chat/bloc/auth/auth_events.dart';
import 'package:space_chat/widgets/input/input.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _email.dispose();

    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform login or submit logic here
      String email = _email.text;
      String password = _password.text;
      BlocProvider.of<AuthBloc>(context)
          .add(AuthCheckEvent(email: email, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Login',
            style: TextStyle(
                fontSize: 30, fontFamily: 'Consend', color: Colors.blueAccent),
          ),
          const SizedBox(height: 50.0),
          Input(
            validate: validateEmail,
            controller: _email,
            labelText: 'Enter your email',
          ),
          Input(
            validate: validatePassword,
            controller: _password,
            labelText: 'Enter your password',
            obscur: true,
          ),
          GFButton(
            onPressed: () {
              _submitForm();
            },
            text: "Submit",
            fullWidthButton: true,
          ),
        ],
      ),
    );
  }
}
