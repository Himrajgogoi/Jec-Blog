import "package:flutter/material.dart";

import "package:flutter_bloc/flutter_bloc.dart";
import "package:signup_login_template_v1/repository/user_repository.dart";

import "package:signup_login_template_v1/bloc/authenticate_bloc.dart";
import "package:signup_login_template_v1/bloc/signup/signup_bloc.dart";
import "signup_form.dart";

class SignUpPage extends StatelessWidget {

  final Function toggle;
  final UserRepository userRepository;

  SignUpPage({Key key, @required this.userRepository, @required this.toggle})
     : assert(userRepository != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: BlocProvider(
        create: (context){
          return SignupBloc(userRepository: userRepository,
              authenticateBloc: BlocProvider.of<AuthenticateBloc>(context));
        },
        child: SignUpForm(toggle: toggle,)
      )
    );
  }
}
