import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../screens/chapchap_loginScreen.dart';


final rootHandler=Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return LoginScreen();
  }
);
/*final homeHandler=Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    return RootDrawer();
  }
);*/