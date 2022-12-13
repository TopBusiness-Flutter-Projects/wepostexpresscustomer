import 'package:flutter/foundation.dart';

@immutable
abstract class NewOrderStates {
  const NewOrderStates();
}

class InitialNewOrderState extends NewOrderStates {}

class LoadingNewOrderState extends NewOrderStates {}
class SuccessPaymentMethodState extends NewOrderStates {}
class SuccessSetAmountToBeCollectedNewOrderState extends NewOrderStates {}

class SuccessNewOrderState extends NewOrderStates {}
class SuccessNextNewOrderState extends NewOrderStates {}

class SuccessCreateOrderState extends NewOrderStates {}

class SuccessAddedPackageNewOrderState extends NewOrderStates {}
class SuccessRemovedNewOrderState extends NewOrderStates {}

class SuccessPaymentSelectedOrderState extends NewOrderStates {}
class SuccessSenderAddressOrderState extends NewOrderStates {}
class SuccessSetBranchAddressOrderState extends NewOrderStates {}
class SuccessAddedDateOrderState extends NewOrderStates {}
class SuccessReceiverAddressOrderState extends NewOrderStates {}

class SuccessStepForwardNewOrderState extends NewOrderStates {}
class SuccessStepBackwardNewOrderState extends NewOrderStates {}

class ChangedSendReceiveNewOrderState extends NewOrderStates {}

class ErrorNewOrderState extends NewOrderStates {
  final String error;

  ErrorNewOrderState(this.error);
}