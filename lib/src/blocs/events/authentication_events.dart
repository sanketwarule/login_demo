import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable{
  AuthenticationEvent([List props=const[]]):super(props);
}

class LoginAttemptEvent extends AuthenticationEvent{
  final String login,password;
  LoginAttemptEvent({@required this.login,@required this.password}):super([login,password]);
  @override
  String toString()=>'trying log In {login:$login,password:$password}';
}

class LoggedInEvent extends AuthenticationEvent{
  final String login,password;
  LoggedInEvent({@required this.login,@required this.password}):super([login,password]);
  @override
  String toString()=>'logged In {login:$login,password:$password}';
}

class LoggedOutEvent extends AuthenticationEvent{
  @override
  String toString()=>'logged out';
}