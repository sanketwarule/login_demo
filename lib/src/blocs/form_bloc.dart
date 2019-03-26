import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:nsiaviemobile/src/blocs/events/form_events.dart';
import 'package:nsiaviemobile/src/blocs/states/form_state.dart';
//import 'package:nsiaviemobile/src/resources/repository.dart';

class FormBloc extends Bloc<FormEvent,FormState>{

  FormBloc();
  @override
  // TODO: implement initialState
  FormState get initialState => EmptyFieldsState();

  Stream<FormState> mapEventToState(FormState currentState,FormEvent event)async*{

    if(event is OnChangeFieldEvent){
      final String field=event.field;
      final String currentValue=event.value;
      //on valide le champs asynchronously depending on the fieldType
      if(event.fieldtype=="login"){
        if(currentValue.length<8 && (!currentValue.contains('ci')|| !currentValue.contains('CI'))){
          yield InvalidFieldState(field:field,error:"Veuillez entrer un identifiant correct");
        }else if(currentValue==''){
          yield EmptyFieldsState();
        }else if(currentValue.length==8 && (currentValue.contains('ci')|| currentValue.contains('CI'))){
          yield ValidFieldState(field: 'login');
        }
      }
      if(event.fieldtype=="password"){
        if(currentValue.length<6){
          yield InvalidFieldState(field: "password",error:"Le mot de passe doit avoir un minimum de 6 caractères ");
        }else if(currentValue==''){
          yield EmptyFieldsState();
        }else if(currentValue.length>=6){
          yield ValidFieldState(field: 'password');
        }
      }
    }
    if(event is ResetStateEvent){
      yield EmptyFieldsState();
    }
    if(event is SubmitEmptyEvent){
      yield SubmitEmptyState();
    }
    
  }
}