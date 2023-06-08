import 'dart:js_interop';

import 'package:space_chat/bloc/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_chat/bloc/auth/auth_bloc.dart';
import 'package:space_chat/bloc/auth/auth_state.dart';
import 'package:space_chat/bloc/breadcromps/breadcromps_bloc.dart';
import 'package:space_chat/bloc/breadcromps/breadcromps_state.dart';
import 'package:space_chat/pages/auth/signup/auth_signup.dart';
import 'package:space_chat/pages/space/space_introduce.dart';
import 'package:space_chat/utils/localstorage_istance.dart';

import 'package:space_chat/widgets/breadcrumbs/breadcrumbs.dart';
import 'login/auth_login.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LocalstorageInstance storage = LocalstorageInstance();
    return FutureBuilder(
        future: storage.checkReadyStorage(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final User? user = storage.getCurrentUser();
          if (!user.isNull) {
            return SpaceIntroduce(currentUser: user!);
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (BuildContext context) => AuthBloc(),
              ),
              BlocProvider<BreadcrompsBloc>(
                create: (BuildContext context) => BreadcrompsBloc(),
              ),
            ],
            // child: SpaceIntroduce(),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return state is AuthFirebaseState
                    ? SpaceIntroduce(currentUser: state.getUser)
                    : const AuthContainer();
              },
            ),
          );
        });
  }
}

class AuthContainer extends StatelessWidget {
  const AuthContainer({super.key});
  @override
  Widget build(BuildContext context) {
    final breadcrompsBloc = BlocProvider.of<BreadcrompsBloc>(context);
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const Text(
                      'SPACE CHAT AUTHENTIFICATION',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Consend',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        BreadCrumbs(
                          navigation: const {
                            'login': 'login',
                            'signup': 'signup'
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: BlocBuilder<BreadcrompsBloc, BreadcrompsState>(
                    builder: (context, state) {
                  return breadcrompsBloc.state.activeBreadcromps == 'login'
                      ? Login()
                      : Signup();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
