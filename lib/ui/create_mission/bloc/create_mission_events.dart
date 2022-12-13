import 'package:flutter/foundation.dart';

@immutable
abstract class CreateMissionEvents
{
  const CreateMissionEvents();
}

class CreateMissionEvent extends CreateMissionEvents {}
class FetchCreateMissionEvent extends CreateMissionEvents {}
class FetchedCreateMissionEvent extends CreateMissionEvents {}
class SetBranchCreateMissionEvent extends CreateMissionEvents {}
class SetPaymentMethodCreateMissionEvent extends CreateMissionEvents {}

class CheckedShipmentCreateMissionEvent extends CreateMissionEvents {}