import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nsiaviemobile/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contrat_model.dart';
import '../models/user_model.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class ChapChapDBProvider implements Source, Cache {
  Database db;

  ChapChapDBProvider() {
    init();
  }
  init() async {
    //initialiser la base de donnees sur le device
    String dbPath = await getDatabasesPath();
    final path = join(dbPath, "chapchap.db");
    await deleteDatabase(dbPath); //a commenter une fois en prod
    debugPrint('Path to db:$dbPath');
    //sql pour creer a base de donnee et ses tables
    final sqlUser = """
      CREATE TABLE User
          (
            id INTEGER PRIMARY KEY,
            login TEXT,
            password TEXT,
            email TEXT,
            nom TEXT,
            prenoms TEXT,
            date_naissance TEXT,
            lieu_naissance TEXT,
            sexe TEXT,
            adresse_postale TEXT,
            telephone TEXT,
            mobile TEXT,
            civilite TEXT,
            nationalite TEXT,
            situation_matrimoniale TEXT,
            date_connexion TEXT,
            photo TEXT
          )
    """;
    final sqlContrats = """
      CREATE TABLE Contrats
      (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_contrat INTEGER,
        numero_police INTEGER,
        libelle_produit TEXT,
        date_effet TEXT,
        date_fin_effet TEXT,
        date_resiliation TEXT
      )
    """;
    final sqlAppSetting = """
      CREATE TABLE InternalSettings
      (
        id INTEGER PRIMARY KEY,
        encryption_salt TEXT,
        encryption_key TEXT
      )
    """;
    //stocker aussi les beneficiaires, les assures et les souscripteurs
    //si la base n'existe pas on la cree sinon on reetablie la connexion
    db = await openDatabase(path, version: 1,
        onCreate: (Database chapchapdb, int version) async {
      await chapchapdb.execute(sqlUser);
      await chapchapdb.execute(sqlContrats);
      await chapchapdb.execute(sqlAppSetting);
    });
  }

  Future<int> storeSettings(String salt, String key) async {
    await db.delete('InternalSettings');
    return db.insert(
        "InternalSettings", {"encryption_salt": salt, "encryption_key": key});
  }

  Future<Map<String, dynamic>> getSettings() async {
    final settings = await db.query("InternalSettings");
    if (settings != null) {
      return settings.isEmpty ? null : settings.first;
    }
    return null;
  }

  //fetch the user info
  Future<UserModel> fetchUser(String login, String password) async {
    debugPrint('fetching user from db ko');
    var user = await db.query("User",
        columns: null,
        where: 'login = ?',
        whereArgs: [login]);
    if (user.length > 0) {
      debugPrint('contents of user in db ${user.first}');
      var userObj={
        "login":user.first['login'],
        "password":await _decryptPassword(user.first['password']),
        "email":user.first['email'],
        "nom":user.first['nom'],
        "prenoms":user.first['prenoms'],
        "lieu_naissance":user.first['lieu_naissance'],
        "date_naissance":user.first['date_naissance'],
        "sexe":user.first['sexe'],
        "adresse_postale":user.first['adresse_postale'],
        "telephone":user.first['telephone'],
        "mobile":user.first['mobile'],
        "civilite":user.first['civilite'],
        "nationalite":user.first['nationalite'],
        "situation_matrimoniale":user.first['situation_matrimoniale'],
        "date_connexion":user.first['date_connexion'],
        "photo":user.first['photo']
      };
       
      if(userObj['password']==password){
        return UserModel.fromDB(userObj);
      }
      return null;
    }
    debugPrint('end on the db fecthing');
    return null;
  }

  //fetch all contracts of the user
  Future<List<ContratModel>> fetchContracts() async {
    final contrats = await db.query("Contrats");
    List<ContratModel> list;
    if (contrats.length > 0) {
      for (var contrat in contrats) {
        list.add(ContratModel.fromDB(contrat));
      }
      return list;
    }
    return null;
  }

  //fetch a single contract
  Future<ContratModel> fetchContrat(int numeroPolice) async {
    final contrat = await db.query('Contrats',
        columns: null, where: 'numero_police = ?', whereArgs: [numeroPolice]);
    if (contrat != null) {
      return ContratModel.fromDB(contrat.first);
    }
    return null;
  }

  //fetch number of contracts
  Future<int> countContracts() async {
    var count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Contrats'));
    return count;
  }

  //insert user
  Future<int> storeUser(UserModel user) async {
    if (user != null) {
      db.delete('User');
      debugPrint('user inserted');
      return db.insert("User", user.toMapForDb());
    }
    return null;
  }

  //insert contracts
  Future<int> storeContracts(List<ContratModel> contrats) async {
    if (contrats.length > 0) {
      db.delete('Contrats');
      debugPrint('contrats effacer');
      for (var c in contrats) {
        db.insert('Contrats', c.toMapForDb());
      }
      return 1;
    }
    return null;
  }

  Future<int> clear(String table) async {
    return await db.delete(table);
  }

  _decryptPassword(String password) async {
    final cryptor = PlatformStringCryptor();
    final settings = await getSettings();
    debugPrint('key is ${settings['encryption_key']}');
    if (settings != null) {
        final String decrypted =await cryptor.decrypt(password, settings['encryption_key']);
        debugPrint(decrypted);
        return decrypted;
      
    }
  }
  Future<String> _encrypt(String string) async {
    final settings = await getSettings();
    if(settings!=null){
      final cryptor = PlatformStringCryptor();
      final encrypted = await cryptor.encrypt(string, settings['encryption_key']);
      debugPrint('encripted password  is $encrypted');
      return encrypted;
    }
    return null;
  }
}

final dbProvider = ChapChapDBProvider();
