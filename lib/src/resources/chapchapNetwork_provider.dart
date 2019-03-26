import 'package:flutter/material.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:http/http.dart' show Client;
import '../utils/app_assets.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../models/contrat_model.dart';
import './repository.dart';
import './chapchapDb_provider.dart';

class ChapChapNetworkProvider implements Source {
  Client client = Client();
  
  //fetch the user info
  Future<UserModel> fetchUser(String login, String password) async {
    debugPrint("fetching user from network");
    Map<String, dynamic> finalObj = {};
    List<ContratModel> contracts = [];
    final borneAuthResponse =
        await client.get('${NsiaAssets.wsborne}/authentification?d=$login&v=$password');
    //debugPrint('reponse WSBORNE: ${borneAuthResponse.body}');
    final Map<String, dynamic> borneAuthResult =
        json.decode(borneAuthResponse.body);
    if (borneAuthResult['CodeErreur'] != null) {
      return null;
    } else {
      // debugPrint('borne auth map : ${borneAuthResult['ElementsAuthentifies'][0]['PoliceInterne']}');
      final infosAssureResponse = await client.get(
          '${NsiaAssets.nsiaviews}/NONE/NONE/NONE/${borneAuthResult['ElementsAuthentifies'][0]['PoliceInterne']}/NONE');
      final Map<String, dynamic> infosAssureResult =
          json.decode(infosAssureResponse.body);
      finalObj = {
        "login": login,
        "password": await _encrypt(password),
        "email": infosAssureResult['client']['email'],
        "nom": infosAssureResult['client']['nom_client'],
        "prenoms": infosAssureResult['client']['prenoms_client'],
        "lieuNaissance": infosAssureResult['client']['lieu_naissance'],
        "dateNaissance": infosAssureResult['client']['date_naissance'],
        "sexe": infosAssureResult['client']['sexe'],
        "adressePostale": infosAssureResult['client']['adresse_postale'],
        "telephone": infosAssureResult['client']['telephone'],
        "mobile": infosAssureResult['client']['telephone1'],
        "civilite": infosAssureResult['client']['civilite'],
        "nationalite": infosAssureResult['client']['nationalite'],
        "situationMatrimoniale": infosAssureResult['client']
            ['situation_matrimoniale'],
        "dateConnexion": DateTime.now(),
        "photo": infosAssureResult['client']['photo_utilisateur']
      };
      for (var c in infosAssureResult['client']['contrats']) {
        Map<String,dynamic> contrat = {};
        for (var e in borneAuthResult['ElementsAuthentifies']) {
          if (int.parse(c['NUMERO_POLICE']) == e['PoliceInterne']) {
            contrat = {
              'id_contrat': c['IDE_CONTRAT'],
              'numero_police': c['NUMERO_POLICE'],
              'libelle_produit': e['LibelleProduit'],
              'date_effet': c['DATE_DEBUT_EFFET_POLICE'],
              'date_fin_effet': c['DATE_FIN_EFFET_POLICE'],
              'date_resiliation': c['DATE_RESILIATION']
            };
          }
        }

        contracts.add(ContratModel.fromJSON(contrat));
      }
      //storing contracts in sqlite
      //finalObj.toString();
      dbProvider.storeContracts(contracts);
      return UserModel.fromJSON(finalObj);
    }
  }

  Future<String> _encrypt(String string) async {
    final cryptor = PlatformStringCryptor();
    final password = "supersecret";
    final salt = await cryptor.generateSalt();
    final key = await cryptor.generateKeyFromPassword(password, salt);
    //storing the salt and the key
    await dbProvider.clear('InternalSettings');
    await dbProvider.storeSettings(salt, key);
    final encrypted = await cryptor.encrypt(string, key);
    return encrypted;
  }
}
