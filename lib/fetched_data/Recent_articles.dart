import 'package:http/http.dart' show Response,get;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class RecentArticles{
  String _token;
  List<dynamic> data=[];
  String message;


  ///getting the token
  Future<void> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');
  }

  /// get data
  Future<void> getData() async {
   try{ Response response = await get('http://10.0.2.2:8000/api/recent/',
        headers: <String,String>{
          "Content-Type": "application/json",
          "Authorization":  "token $_token"
        });
    data = jsonDecode(response.body);}
    catch(e){
     message = e.toString();
    }

  }

}