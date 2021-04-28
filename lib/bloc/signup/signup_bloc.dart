import 'dart:async';

import 'package:bloc/bloc.dart';
import "package:signup_login_template_v1/bloc/authenticate_bloc.dart";
import "package:signup_login_template_v1/repository/user_repository.dart";
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository userRepository;
  final AuthenticateBloc authenticateBloc;
  SignupBloc({@required this.userRepository, @required this.authenticateBloc})
      :assert(userRepository != null), assert(authenticateBloc != null),super(SignupInitial());


  SignupState get initialState => SignupInitial();
  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if(event is SignupButtonPressed){
      yield SignupInitial();
      try{
        final user= await userRepository.authenticate_SignUp
          (
            username: event.username,
            email: event.email,
            password: event.password);

        authenticateBloc.add(LoggedIn(user: user));
        yield SignupInitial();
      }catch(e){
        yield SignupFailure(error: e);
      }
    }
  }
}
