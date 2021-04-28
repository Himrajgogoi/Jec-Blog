import 'package:http/http.dart' show post,Response;
import 'package:shared_preferences/shared_preferences.dart';
class Logout{
  String _token;

  ///getting the token
  Future<void> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _token = pref.getString('token');
  }

  Future<void> logout() async {
    Response response = await post("http://10.0.2.2:8000/api/auth/logout",
    headers: <String,String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization":  "token $_token"
    });
    print(response.statusCode);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
  }

}