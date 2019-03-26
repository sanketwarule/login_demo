import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable{}

class AuthenticationUninitializedState extends AuthenticationState{
  @override
  String toString()=>'not connected yet';
}

class AuthenticationAuthenticatedState extends AuthenticationState{
  @override
  String toString()=>'user connected successfully';
}

class AuthenticationUnauthenticatedState extends AuthenticationState{
  @override
  String toString()=>'authentication failed';
}

class AuthenticationLoadingState extends AuthenticationState{
  @override
  String toString()=>'loading';
} 