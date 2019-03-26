import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import './events/navigation_events.dart';
import './states/navigation_state.dart';
import 'dart:async';

class NavigationBloc extends Bloc<NavigationEvents,NavigationState>{
@override
  // TODO: implement initialState
  NavigationState get initialState => HomeRouteState();
  @override
  Stream<NavigationState> mapEventToState(NavigationState currentState, NavigationEvents event) async*{
    debugPrint("out event:$event");
    if(event is GoHomeEvent){
      debugPrint('event:$event');
      yield HomeRouteState();
    }else if(event is GoLoginEvent){
      debugPrint('event:$event');
      yield LoginRouteState();
    }
  }
}