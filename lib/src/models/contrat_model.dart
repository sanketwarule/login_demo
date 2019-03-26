import 'dart:convert';

class ContratModel{
  final int id;
  final int idContrat;
  final int numeroPolice;
  final String libeleProduit;
  final String dateEffet;
  final String dateFinEffet;
  final String dateResiliation;

  ContratModel.fromJSON(Map<String,dynamic> parsedJSON):
  id=0,
  idContrat=int.parse(parsedJSON['id_contrat']),
  numeroPolice=int.parse(parsedJSON['numero_police']),
  libeleProduit=parsedJSON['libelle_produit'],
  dateEffet=parsedJSON['date_effet']??'',
  dateFinEffet=parsedJSON['date_fin_effet']??'',
  dateResiliation=parsedJSON['date_resiliation']??'';
  

  ContratModel.fromDB(Map<String,dynamic> parsedDB):
  id=parsedDB['id'],
  idContrat=parsedDB['id_contrat'],
  libeleProduit=parsedDB['libelle_produit'],
  numeroPolice=parsedDB['numero_police'],
  dateEffet=parsedDB['date_effet']??'',
  dateFinEffet=parsedDB['date_fin_effet']??'',
  dateResiliation=parsedDB['date_resiliation']??'';
  

  Map<String,dynamic> toMapForDb(){
    return <String,dynamic>{
      "id_contrat":idContrat,
      "numero_police":numeroPolice,
      'libelle_produit':libeleProduit,
      "date_effet":dateEffet,
      "date_fin_effet":dateFinEffet,
      "date_resiliation":dateResiliation
    };
  }
}