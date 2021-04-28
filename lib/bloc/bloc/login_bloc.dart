import 'dart:async';

import 'package:bloc/bloc.dart';
import "package:signup_login_template_v1/bloc/authenticate_bloc.dart";
import "package:signup_login_template_v1/repository/user_repository.dart";
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticateBloc authenticateBloc;
  LoginBloc({@required this.userRepository, @required this.authenticateBloc})
      :assert(userRepository != null), assert(authenticateBloc != null), super(LoginInitial());


  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if(event is LoginButtonPressed){
      yield LoginInitial();
      try{
        final user = await userRepository.authenticate(username: event.username,
            password: event.password);
        authenticateBloc.add(LoggedIn(user: user));
        yield LoginInitial();
      } catch(error){
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
