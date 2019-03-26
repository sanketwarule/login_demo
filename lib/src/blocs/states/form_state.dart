import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FormState extends Equatable{}

class ValidFieldState extends FormState{
  final String field;
  ValidFieldState({@required this.field});
  @override
  String toString()=>'the field $field is valid';
}

class InvalidFieldState extends FormState{
  final String field,error;
  InvalidFieldState({@required this.field,@required this.error});
  @override
  String toString()=>'the field $field is invalid.\n Error:$error';
}
class EmptyFieldsState extends FormState{
  @override
  String toString()=>'the fields are empty';
}
class SubmitEmptyState extends FormState{
  @override
  String toString()=>'the fields are empty and it tries to submit';
}

