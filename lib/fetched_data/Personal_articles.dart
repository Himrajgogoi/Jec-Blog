import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Response,get,delete, MultipartRequest, MultipartFile;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PersonalArticles{
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
    try{Response response = await get('http://10.0.2.2:8000/api/personal/',
        headers: <String,String>{
          "Content-Type": "application/json",
          "Authorization":  "token $_token"
        });
    data = jsonDecode(response.body);}
    catch(e){
      message = e.toString();
    }

  }


  /// getting specifc article
  Future<void> get_specific_article(int id) async {
    try{Response response = await get('http://10.0.2.2:8000/api/personal/$id/',
        headers: <String,String>{
          "Content-Type": "application/json",
          "Authorization":  "token $_token"
        });
    article = jsonDecode(response.body);}
    catch(e){
      message = e.toString();
    }

  }

  /// updating the article
  Future<void> putData(int id, String username, String textArea, String header, var image, {bool isImage = false}) async {
    var req = MultipartRequest('PUT', Uri.parse('http://10.0.2.2:8000/api/personal/$id/'));

    if(isImage){
      req.headers["Authorization"] = "token $_token";
      req.fields['username'] = username;
      req.fields['textArea'] = textArea;
      req.fields['header'] = header;

      req.files.add(
          await MultipartFile.fromPath('image', image)
      );

      var res = await req.send();
      if(res.statusCode == 200){
        message = "Updated!";
      }
      else{
        message = "An error occured";
      }
    }

    else{
      req.headers["Authorization"] = "token $_token";
      req.fields['username'] = username;
      req.fields['textArea'] = textArea;
      req.fields['header'] = header;

      var res = await req.send();
      if(res.statusCode == 200){
        message = "Updated!";
      }
      else{
        message = "An error occured";
      }

    }
  }

  /// deleting an article
 Future<void> deleteArticle(int id) async {
    Response response = await delete("http://10.0.2.2:8000/api/personal/$id/",
        headers: <String,String>{
          "Content-Type": "application/json",
          "Authorization":  "token $_token"
        });
    print(response.statusCode);
    if(response.statusCode == 204){
      message = "Deleted!";
    }
    else{
      message = "An error occured";
    }
 }

}