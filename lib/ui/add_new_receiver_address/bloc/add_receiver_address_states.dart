import 'package:flutter/foundation.dart';

@immutable
abstract class AddReceiverAddressStates {
  const AddReceiverAddressStates();
}

class InitialAddReceiverAddressState extends AddReceiverAddressStates {}

class LoadingAddReceiverAddressState extends AddReceiverAddressStates {}
class LoadingProgressAddReceiverAddressState extends AddReceiverAddressStates {}

class SuccessAddReceiverAddressState extends AddReceiverAddressStates {}
class AddReceiverAddressedSuccessfully extends AddReceiverAddressStates {}
class SuccessGetAllCountriesAddReceiverAddressState extends AddReceiverAddressStates {}
class SuccessNextAddReceiverAddressState extends AddReceiverAddressStates {}
class SuccessSearchAddReceiverAddressState extends AddReceiverAddressStates {}
class SuccessPaymentMethodState extends AddReceiverAddressStates {}

class SuccessStepForwardAddReceiverAddressState extends AddReceiverAddressStates {}
class SuccessStepBackwardAddReceiverAddressState extends AddReceiverAddressStates {}

class ErrorAddReceiverAddressState extends AddReceiverAddressStates {
  final String error;
  final bool canPop;

  ErrorAddReceiverAddressState(this.error,this.canPop);
}