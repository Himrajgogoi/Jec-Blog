import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:signup_login_template_v1/api_connection/logout.dart';

import "package:signup_login_template_v1/repository/user_repository.dart";
import 'package:signup_login_template_v1/models/user_model.dart';

part 'authenticate_event.dart';
part 'authenticate_state.dart';

class AuthenticateBloc
    extends Bloc<AuthenticateEvent, AuthenticateState> {
  final UserRepository userRepository;

  AuthenticateBloc({@required this.userRepository})
    : assert(userRepository != null),  super(AuthenticateUninitialized());

  AuthenticateState get initialState => AuthenticateUninitialized();

  @override
  Stream<AuthenticateState> mapEventToState(
      AuthenticateEvent event,
      ) async* {
    if(event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();

      if(hasToken){
        yield AuthenticateAuthenticated();
      }
      else{
        yield AuthenticateUnauthenticated();
      }
    }
    if(event is LoggedIn){
      yield AuthenticateLoading();
      await userRepository.persistToken(
        user: event.user
      );
      yield AuthenticateAuthenticated();
    }
    if(event is LoggedOut){
      yield AuthenticateLoading();
      await userRepository.delteToken(id: 0);
      yield AuthenticateUnauthenticated();
    }
  }
}
