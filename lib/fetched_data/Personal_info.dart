import 'package:http/http.dart' show Response,get,put;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PersonalInfo {

  String _token;
  Map<String,dynamic> data={};
  String message;

  ///getting the token
  Future<void> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');
  }


  /// get data
  Future<void> getData() async {
    try{Response response = await get('http://10.0.2.2:8000/api/auth/user',
    headers: <String,String>{
      "Content-Type": "application/json",
      "Authorization":  "token $_token"
    });
    data = jsonDecode(response.body);
   }
    catch(e){
      message = e.toString();
    }
  }


  /// update data
  Future<void> putData(int id, username, email) async {
      try{Response response = await put('http://10.0.2.2:8000/api/users/$id/',
          headers: <String,String>{
            "Content-Type": "application/json",
            "Authorization":  "token $_token"
          },
          body: jsonEncode({
            "username": username,
            "email": email
          }));
      if(response.statusCode == 200) {
        message = "Updated!";
      }
      else{
        message = "An error occured";
      }
      }
      catch(e){
        message = e.toString();
      }


  }


}