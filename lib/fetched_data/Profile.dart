import 'package:http/http.dart' show Response,get,put, MultipartRequest, MultipartFile;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Profile {
  String _token;
  List<dynamic> data=[];
  String message;

  ///getting the token
  Future<void> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');
  }

  ///posting the profile data
  Future<void> postData(String bio, var dp) async {
    var req = MultipartRequest('POST', Uri.parse("http://10.0.2.2:8000/api/user/profile/"));
    req.headers["Authorization"] = "token $_token";
    req.fields["bio"] = bio;
    req.files.add(
      await MultipartFile.fromPath('dp', dp)
    );
    var res = await req.send();
    if(res.statusCode == 201){
      message = "Updated!";
    }
    else{
      message = "An error occured";
    }

  }


  /// getting the profile data
  Future<void> getData() async {
      try{Response response = await get("http://10.0.2.2:8000/api/user/profile/",
      headers: <String,String>{
        "Authorization": "token $_token",
        "Content-Type" : "application/json"
      });

      data = jsonDecode(response.body);
      print(data);}
      catch(e){
        message = e.toString();
      }

  }


  /// updating the profile
  Future<void> putData(int id, dynamic info, {bool isDp=false}) async {
    var req = MultipartRequest('PUT', Uri.parse("http://10.0.2.2:8000/api/user/profile/$id/"));
    req.headers["Authorization"] = "token $_token";
    if(isDp){
      req.files.add(
          await MultipartFile.fromPath('dp', info)
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
      req.fields["bio"] = info;
      var res = await req.send();
      if(res.statusCode == 200){
        message = "Updated!";
      }
      else{
        message = "An error occured";
      }
    }
  }

  Future<void> fullUpdate(int id, String bio, var dp) async {
    var req = MultipartRequest('PUT', Uri.parse("http://10.0.2.2:8000/api/user/profile/$id"));
    req.headers["Authorization"] = "token $_token";
    req.files.add(
        await MultipartFile.fromPath('dp', dp)
    );
    req.fields["bio"] = bio;
    var res = await req.send();
    if(res.statusCode == 200){
      message = "Updated!";
    }
    else{
      message = "An error occured";
    }
  }
}