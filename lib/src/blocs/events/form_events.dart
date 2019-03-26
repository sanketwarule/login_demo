import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class FormEvent extends Equatable{
  FormEvent([List props=const[]]):super(props);
}

class OnChangeFieldEvent extends FormEvent{
  final String field,fieldtype,value;
  OnChangeFieldEvent({@required this.field,@required this.fieldtype,@required this.value}):super([field,value]);
  @override
  String toString()=>'typing in $field the value $value';
}

class ResetStateEvent extends FormEvent{
  @override
  String toString()=>'resetting state of the form';
}

class SubmitEmptyEvent extends FormEvent{
  final String formName;
  SubmitEmptyEvent({@required this.formName});
  @override
  String toString()=>'trying to submit an empty $formName form';
}
