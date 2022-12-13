import 'package:flutter/foundation.dart';

@immutable
abstract class AddAddressStates {
  const AddAddressStates();
}

class InitialAddAddressState extends AddAddressStates {}

class LoadingAddAddressState extends AddAddressStates {}
class LoadingProgressAddAddressState extends AddAddressStates {}

class SuccessAddAddressState extends AddAddressStates {}
class AddAddressedSuccessfully extends AddAddressStates {}
class SuccessGetAllCountriesAddAddressState extends AddAddressStates {}
class SuccessNextAddAddressState extends AddAddressStates {}
class SuccessPaymentMethodState extends AddAddressStates {}

class SuccessStepForwardAddAddressState extends AddAddressStates {}
class SuccessStepBackwardAddAddressState extends AddAddressStates {}

class ErrorAddAddressState extends AddAddressStates {
  final String error;
  final bool canPop;

  ErrorAddAddressState(this.error,this.canPop);
}