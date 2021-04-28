import 'package:flutter/material.dart';
import 'package:signup_login_template_v1/login/login_page.dart';
import 'package:signup_login_template_v1/repository/user_repository.dart';
import "package:signup_login_template_v1/signUp/signup_page.dart";

class Wrapper extends StatefulWidget {
  final UserRepository userRepository;
  Wrapper({@required this.userRepository}) : assert( userRepository!=null);
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool signUp = true;
  void toggle(){
    setState(() {
      signUp = !signUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(signUp){
      return SignUpPage(userRepository: widget.userRepository, toggle: toggle,);
    }
    else{
      return LoginPage(userRepository: widget.userRepository, toggle: toggle,);
    }

  }
}
