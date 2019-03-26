import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import './events/authentication_events.dart';
import './states/authentication_state.dart';
import '../models/contrat_model.dart';
import '../models/user_model.dart';
import '../resources/repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  Repository userRepository;
  UserModel user;
  ContratModel contrats;

  @override
  AuthenticationState get initialState => AuthenticationUninitializedState();

  Stream<AuthenticationState> mapEventToState(
      AuthenticationState currentState, AuthenticationEvent event) async* {
    if (event is LoggedOutEvent) {
      yield AuthenticationUninitializedState();
      contrats = null;
      user = null;
    }
    if (event is LoginAttemptEvent) {
      userRepository = Repository();
      user = await userRepository.fetchUser(event.login, event.password);
      //debugPrint('$loginResult');
      yield AuthenticationLoadingState();
      if (user != null) {
        yield AuthenticationAuthenticatedState();
      } else {
        yield AuthenticationUnauthenticatedState();
      }
    }
  }
}
