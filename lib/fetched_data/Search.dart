import 'dart:convert';
import 'package:http/http.dart' show get,Response;
import 'package:shared_preferences/shared_preferences.dart';

class Search{

  String word;
  Search({this.word});

  String _token;
  String message;
  List<dynamic> searched=[];
  List<dynamic> data=[];

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


  /// searching algo
  void search() {

    var splited =  word.toLowerCase().split('');
    var pattern="";
    splited.forEach((element) {
      pattern += element + '.*';
    });

    pattern += "";

    RegExp re = new RegExp(pattern);

    for (Map<String,dynamic> item in data){
      if(re.hasMatch(item["header"].toString().toLowerCase().trim())){
        searched.add(item);
      }
    }

    if(searched.isEmpty){
      message = "No such article found!";
    }
  }


}