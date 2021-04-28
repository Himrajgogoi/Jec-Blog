part of 'authenticate_bloc.dart';

abstract class AuthenticateState extends Equatable{
  @override
  List<Object> get props => [];
}

class AuthenticateUninitialized extends AuthenticateState{}

class AuthenticateAuthenticated extends AuthenticateState{}

class AuthenticateUnauthenticated extends AuthenticateState{}

class AuthenticateLoading extends AuthenticateState{}
