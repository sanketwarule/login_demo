import 'dart:convert';

import 'package:flutter/material.dart';

class UserModel{
  final String login;
  final String password;
  final String email;
  final String nom;
  final String prenoms;
  final String lieuNaissance;
  final String dateNaissance;
  final String sexe;
  final String adressePostale;
  final String telephone;
  final String mobile;
  final String civilite;
  final String nationalite;
  final String situationMatrimoniale;
  final DateTime dateConnexion;
  final String photo;

  UserModel.fromJSON(Map<String,dynamic> parsedJSON):
  login=parsedJSON['login'],
  password=parsedJSON['password'],
  email=parsedJSON['email']??'NOVALUE',
  nom=parsedJSON['nom'],
  prenoms=parsedJSON['prenoms'],
  lieuNaissance=parsedJSON['lieuNaissance']??'NOVALUE',
  dateNaissance=parsedJSON['dateNaissance'],
  sexe=parsedJSON['sexe'],
  adressePostale=parsedJSON['adressePostale']??'NOVALUE',
  telephone=parsedJSON['telephone']??'NOVALUE',
  mobile=parsedJSON['mobile']??'',
  civilite=parsedJSON['civilite'],
  nationalite=parsedJSON['nationalite'],
  situationMatrimoniale=parsedJSON['situationMatrimoniale'],
  dateConnexion=parsedJSON['dateConnexion'],
  photo=parsedJSON['photo']??'NOVALUE';

    UserModel.fromDB(Map<String,dynamic> parsedDB):
  login=parsedDB['login'],
  password=parsedDB['password'],
  email=parsedDB['email']??'',
  nom=parsedDB['nom'],
  prenoms=parsedDB['prenoms'],
  lieuNaissance=parsedDB['lieu_naissance']??'',
  dateNaissance=parsedDB['date_naissance'],
  sexe=parsedDB['sexe'],
  adressePostale=parsedDB['adresse_postale']??'',
  telephone=parsedDB['telephone']??'',
  mobile=parsedDB['mobile']??'',
  civilite=parsedDB['civilite'],
  nationalite=parsedDB['nationalite'],
  situationMatrimoniale=parsedDB['situation_matrimoniale'],
  dateConnexion=DateTime.parse(parsedDB['date_connexion']),
  photo=parsedDB['photo']??'';


  Map<String,dynamic> toMapForDb(){
    debugPrint(this.toString());
    return <String,dynamic>{
      "login":login,
      "password":password,
      "email":email,
      "nom":nom,
      "prenoms":prenoms,
      "lieu_naissance":lieuNaissance,
      "date_naissance":dateNaissance,
      "sexe":sexe,
      "adresse_postale":adressePostale,
      "telephone":telephone,
      "mobile":mobile,
      "civilite":civilite,
      "nationalite":nationalite,
      "situation_matrimoniale":situationMatrimoniale,
      "date_connexion":dateConnexion.toIso8601String(),
      "photo":photo
    };
  }
  @override
  String toString() {
  return 'login is:$login nom is:$nom prenoms is:$prenoms';
   }
}