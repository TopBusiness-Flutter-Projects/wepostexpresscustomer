import 'package:flutter/foundation.dart';

@immutable
abstract class RegisterStates {
  const RegisterStates();
}

class InitialRegisterState extends RegisterStates {}

class LoadingRegisterState extends RegisterStates {}
class LoadingProgressRegisterState extends RegisterStates {}

class SuccessRegisterState extends RegisterStates {}
class RegisteredSuccessfully extends RegisterStates {}
class SuccessGetAllCountriesRegisterState extends RegisterStates {}
class SuccessNextRegisterState extends RegisterStates {}
class PasswordToggleChangedRegisterState extends RegisterStates {}

class SuccessStepForwardRegisterState extends RegisterStates {}
class SuccessStepBackwardRegisterState extends RegisterStates {}

class ErrorRegisterState extends RegisterStates {
  final String error;
  final bool canPop;

  ErrorRegisterState(this.error,this.canPop);
}