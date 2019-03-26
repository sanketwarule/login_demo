import 'package:flutter/material.dart';
import 'dart:io';
import '../models/contrat_model.dart';
import '../models/user_model.dart';
import '../resources/chapchapDb_provider.dart';
import '../resources/chapchapNetwork_provider.dart';
abstract class Source {
  Future<UserModel> fetchUser(String login, String password);
}

abstract class Cache {
  Future<int> clear(String table);
  Future<int> storeContracts(List<ContratModel> contrats);
  Future<int> storeUser(UserModel user);
}

class Repository {
  List<Source> sources = <Source>[dbProvider, ChapChapNetworkProvider()];
  List<Cache> caches = <Cache>[dbProvider];

  Future<UserModel> fetchUser(String login, String password) async {
    UserModel user;
    var source;
     for (source in sources) {
      if (source is ChapChapNetworkProvider) {
        try {
          
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            user = await source.fetchUser(login, password);
            debugPrint('user is $user');
          }
        } on SocketException catch (_) {
          
          debugPrint('no internet connetion');
        }
      } else {
        user = await source.fetchUser(login, password);
        debugPrint('user in db is $user');
      }

      if (user != null) {
        break;
      }
    }
    for (var cache in caches) {
      if (cache != source) {
        //ici les deux sont de meme instance
        cache.storeUser(user);
      }
    }
    return user ?? null;
  }

  Future<bool> clearCache() async {
    for (var cache in caches) {
      await cache.clear("User");
      await cache.clear("Contrats");
      await cache.clear("InternalSettings");
    }
    return true;
  }
}
