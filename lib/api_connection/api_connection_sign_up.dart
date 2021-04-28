import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Response,get,post;
import 'package:signup_login_template_v1/models/api_model.dart';

final _base = "http://10.0.2.2:8000/api/auth/";
final _tokenEndpoint = "register";
final _tokenURL = _base+_tokenEndpoint;


Future<Token> get_Token(UserSignup userSignup) async {
  print(_tokenURL);
  final Response response = await post(_tokenURL,
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: jsonEncode(userSignup.toDatabaseJson()),
  );
  if(response.statusCode == 200){
    return Token.fromJson(json.decode(response.body));
  }
  else{
    print(json.decode(response.body).toString());
    throw Exception(json.decode(response.body));
  }
}