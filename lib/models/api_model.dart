import 'package:flutter/foundation.dart';

class UserLogin{
  String username;
  String password;

  UserLogin({this.username, this.password});
  Map<String, dynamic> toDatabaseJson()=>{
    "username": this.username,
    "password": this.password
  };
}

class Token{
  String token;

  Token({this.token});

  factory Token.fromJson(Map<String,dynamic> json){
    return Token(
      token: json["token"]
    );
  }
}

class UserSignup{

  String username;
  String email;
  String password;

  UserSignup({this.username, this.email, this.password});

  Map<String, dynamic> toDatabaseJson()=>{

    "username": this.username,
    "email": this.email,
    "password": this.password
  };
}