import 'package:flutter/foundation.dart';

@immutable
abstract class CreateMissionStates {
  const CreateMissionStates();
}

class InitialCreateMissionState extends CreateMissionStates {}

class LoadingCreateMissionState extends CreateMissionStates {}
class LoadingCreatingMissionState extends CreateMissionStates {}

class SuccessCreateMissionState extends CreateMissionStates {}
class SuccessPaymentMethodMissionState extends CreateMissionStates {}
class ShipmentCheckedCreateMissionState extends CreateMissionStates {}
class SetBranchCreateMissionState extends CreateMissionStates {}
class MissionCreatedSuccessfullyMissionState extends CreateMissionStates {}

class ErrorCreateMissionState extends CreateMissionStates {
  final String error;

  ErrorCreateMissionState(this.error);
}