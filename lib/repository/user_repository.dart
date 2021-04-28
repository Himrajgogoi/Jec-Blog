import "dart:async";
import "package:signup_login_template_v1/models/user_model.dart";
import "package:meta/meta.dart";
import "package:signup_login_template_v1/models/api_model.dart";
import "package:signup_login_template_v1/api_connection/api_connection.dart";
import "package:signup_login_template_v1/api_connection/api_connection_sign_up.dart";
import "package:signup_login_template_v1/dao/user_dao.dart";
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository{
  final userDao = UserDao();

  Future<User> authenticate ({@required String username, @required String password}) async {
    UserLogin userLogin = UserLogin(
      username: username,
      password: password
    );
    Token token = await getToken(userLogin);
    User user = User(
        id: 0,
        username: username,
        token: token.token
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', token.token);
    return user;
  }

  Future<User> authenticate_SignUp({@required username, @required email, @required password}) async {
    UserSignup userSignup = UserSignup(
      username: username,
      email: email,
      password: password
    );
    Token token = await get_Token(userSignup);
    User user = User(
        id: 0,
        username: username,
        token: token.token
    );
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', token.token);
    return user;
  }

  Future<void> persistToken ({@required User user}) async {
    await userDao.createUser(user);
  }

  Future<void> delteToken({@required int id}) async {
    await userDao.deleteUser(id);
  }

  Future<bool> hasToken() async {
    bool result = await userDao.checkUser(0);
    return result;
  }

}