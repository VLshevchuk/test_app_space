import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:space_chat/bloc/auth/auth_bloc.dart';
import 'package:space_chat/bloc/auth/auth_events.dart';
import 'package:space_chat/pages/auth/helpers.dart';
import 'package:space_chat/widgets/input/input.dart';

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _email.dispose();
    _username.dispose();

    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform login or submit logic here
      String usernameText = _username.text;
      String passwordText = _password.text;
      String emailText = _email.text;
      BlocProvider.of<AuthBloc>(context).add(AuthCreateEvent(
          email: emailText, username: usernameText, password: passwordText));
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
            'Signup',
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
          Input(
            validate: validateUsername,
            controller: _username,
            labelText: 'Enter your username',
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
