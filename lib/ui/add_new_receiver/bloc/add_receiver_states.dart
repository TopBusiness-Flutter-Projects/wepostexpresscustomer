import 'package:flutter/foundation.dart';

@immutable
abstract class AddReceiverStates {
  const AddReceiverStates();
}

class InitialAddReceiverState extends AddReceiverStates {}

class LoadingAddReceiverState extends AddReceiverStates {}
class LoadingProgressAddReceiverState extends AddReceiverStates {}

class SuccessAddReceiverState extends AddReceiverStates {}
class AddedReceiverSuccessfully extends AddReceiverStates {}
class SuccessGetAllCountriesAddReceiverState extends AddReceiverStates {}
class SuccessNextAddReceiverState extends AddReceiverStates {}

class SuccessStepForwardAddReceiverState extends AddReceiverStates {}
class SuccessStepBackwardAddReceiverState extends AddReceiverStates {}

class ErrorAddReceiverState extends AddReceiverStates {
  final String error;
  final bool canPop;

  ErrorAddReceiverState(this.error,this.canPop);
}