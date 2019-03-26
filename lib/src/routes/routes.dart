import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './route_handler.dart';

class Routes{
  static String root="/";
  static String home="/home";
  static String simulation="/home/simulation";
  static String souscription="/home/souscription";
  static String nsianews="/home/nsianews";
  static String faq="/home/faq";
  static String nsiachapchap="/home/nsiachapchap";
  static String agences="/home/agences";

  static void configureRoutes(Router router){
    router.notFoundHandler=Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> params){
        debugPrint("Route was not found !");
      }
    );
    //definir les routes ici
    router.define(root,handler:rootHandler,transitionType: TransitionType.fadeIn);
  }

}