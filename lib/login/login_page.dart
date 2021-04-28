import "package:flutter/material.dart";

import "package:flutter_bloc/flutter_bloc.dart";
import "package:signup_login_template_v1/repository/user_repository.dart";

import "package:signup_login_template_v1/bloc/authenticate_bloc.dart";
import "package:signup_login_template_v1/bloc/bloc/login_bloc.dart";
import "package:signup_login_template_v1/login/login_form.dart";

class LoginPage extends StatelessWidget {

  final Function toggle;
  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository, this.toggle}) : assert(userRepository !=null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: BlocProvider(
        create: (context){
          return LoginBloc(userRepository: userRepository, authenticateBloc:
          BlocProvider.of<AuthenticateBloc>(context));
        },
        child: LoginForm(toggle: toggle,)
      ),
    );
  }
}
