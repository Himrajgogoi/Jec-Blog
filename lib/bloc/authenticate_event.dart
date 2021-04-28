part of 'authenticate_bloc.dart';

abstract class AuthenticateEvent extends Equatable{
  const AuthenticateEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticateEvent {}

class LoggedIn extends AuthenticateEvent {
  final User user;
  const LoggedIn({@required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoggedIn {user: ${user.username.toString()}}';
}



class LoggedOut extends AuthenticateEvent{}
