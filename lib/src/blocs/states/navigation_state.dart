import 'package:equatable/equatable.dart';
 
 abstract class NavigationState extends Equatable{}

 class HomeRouteState extends NavigationState{
   @override
  String toString() {
    // TODO: implement toString
    return 'home';
  }
 }
  class LoginRouteState extends NavigationState{
   @override
  String toString() {
    // TODO: implement toString
    return 'loginchapchap';
  }
 }