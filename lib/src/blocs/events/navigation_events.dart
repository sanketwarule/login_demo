import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NavigationEvents extends Equatable{
  NavigationEvents([List props=const[]]):super(props);
}

class GoHomeEvent extends NavigationEvents{
  @override
  String toString() => 'Go home';
}

class GoLoginEvent extends NavigationEvents{
  @override
  String toString()=>'Go Login Chap Chap';
}

//class