import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:signup_login_template_v1/bloc/bloc/login_bloc.dart";
import "package:signup_login_template_v1/shared/textdecoration.dart";

class LoginForm extends StatefulWidget {

  final Function toggle;
  LoginForm({this.toggle});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    _onLoginButtonPressed(){
      BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(username: _usernameController.text,
          password: _passwordController.text));
    }
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state){
          if(state is LoginFailure){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("${state.error}",),
            backgroundColor: Colors.red,));
          }
        },
       child: BlocBuilder<LoginBloc, LoginState>(
         builder: (context, state){
           return Container(
             color: Colors.blue[900],
             child: Form(
               child: Padding(
                 padding: EdgeInsets.all(40.0),
                 child: SingleChildScrollView(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[
                       SizedBox(height: 50.0,),
                       Text("Welcome.", style: TextStyle(
                           fontSize: 50.0,
                           fontWeight: FontWeight.bold,
                           color: Colors.white
                       ),),
                       SizedBox(height: 30.0,),
                       TextFormField(
                         decoration: textDecoration.copyWith(hintText: "Username"),
                         controller: _usernameController,
                       ),
                       SizedBox(height: 12.0,),
                       TextFormField(
                         decoration: textDecoration.copyWith(hintText: "password"),
                         controller: _passwordController,
                         obscureText: true,
                       ),
                       Container(
                         width: MediaQuery.of(context).size.width * 0.85,
                         height: MediaQuery.of(context).size.width * 0.22,
                         child: Padding(
                           padding: EdgeInsets.only(top: 30.0),
                           child: RaisedButton(
                             onPressed: state is! LoginLoading
                                 ? _onLoginButtonPressed
                                 : null,
                             child: Text(
                               'Login',
                               style: TextStyle(
                                 fontSize: 24.0,
                               ),
                             ),
                             shape: StadiumBorder(
                               side: BorderSide(
                                 color: Colors.black,
                                 width: 2,
                               ),
                             ),
                           ),
                         ),
                       ),
                       Container(
                         child: state is LoginLoading
                             ? CircularProgressIndicator()
                             : null,
                       ),
                       SizedBox(height: 12.0,),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Text("Dont have an account?", style: TextStyle(
                               color: Colors.white
                           ),),
                           InkWell(
                             onTap: (){
                               widget.toggle();
                             },
                             child: Text("  Register", style: TextStyle(
                                 color: Colors.yellowAccent
                             ),),)
                         ],
                       )
                     ],
                   ),
                 ),
               ),
             ),
           );
         },
       ));
  }
}
