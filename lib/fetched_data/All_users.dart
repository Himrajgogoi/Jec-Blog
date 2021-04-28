import 'package:http/http.dart' show Response,get,put;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AllUsers{
  String _token;
  List<dynamic> data=[];
  Map<String,dynamic> user = {};
  String message;

  ///getting the token
  Future<void> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');
  }

  /// get data
  Future<void> getData() async {
    try{
      Response response = await get('http://10.0.2.2:8000/api/users/',
        headers: <String,String>{
          "Content-Type": "application/json",
          "Authorization":  "token $_token"
        });
    data = jsonDecode(response.body);
    print(data);
    }
    catch(e){
      message = e.toString();
    }
  }


  ///specific user data
  Future<void> get_specific_user(int id) async {
   try{ Response response = await get('http://10.0.2.2:8000/api/users/$id/',
        headers: <String,String>{
          "Content-Type": "application/json",
          "Authorization":  "token $_token"
        });
    user = jsonDecode(response.body);
    print(user);}
    catch(e){
     message = e.toString();
    }
  }
}