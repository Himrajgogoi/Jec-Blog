import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Response,get,put, MultipartRequest, MultipartFile;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AllArticles{
  String _token;
  List<dynamic> data=[];
  Map<String,dynamic> article = {};
  String message;

  ///getting the token
  Future<void> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');
  }

  /// get data
  Future<void> getData() async {
    try{
      Response response = await get('http://10.0.2.2:8000/api/articles/',
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


  /// posting an article
  Future<void> postData(String username, String textArea, String header, var image) async {
       var req = MultipartRequest('POST', Uri.parse('http://10.0.2.2:8000/api/articles/'));
       req.headers["Authorization"] = "token $_token";
       req.fields['username'] = username;
       req.fields['textArea'] = textArea;
       req.fields['header'] = header;
       req.files.add(
         await MultipartFile.fromPath('image', image)
       );

       var res = await req.send();
       print(res.statusCode);
       if(res.statusCode == 201){
         message = "Updated!";
       }
       else{
         message = "An error occured";
       }

  }

  Future<void> get_specific_article(int id) async {
    try{
      Response response = await get('http://10.0.2.2:8000/api/articles/$id/',
        headers: <String,String>{
          "Content-Type": "application/json",
          "Authorization":  "token $_token"
        });
    article = jsonDecode(response.body);
    print(article);
    }
    catch(e){
      message = e.toString();
    }
  }
}
