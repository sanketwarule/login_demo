import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './src/app.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocDelegate extends BlocDelegate{
  @override
  void onTransition(Transition transition) {
    print(transition);
    super.onTransition(transition);
  }
}
void main(){
  BlocSupervisor().delegate=SimpleBlocDelegate();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(App());
  });
}