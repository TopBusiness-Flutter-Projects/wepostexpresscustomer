import 'package:flutter/foundation.dart';

@immutable
abstract class MissionShipmentsEvents
{
  const MissionShipmentsEvents();
}

class MissionShipmentsEvent extends MissionShipmentsEvents {}
class FetchMissionShipmentsEvent extends MissionShipmentsEvents {
  final  String missionID;

  FetchMissionShipmentsEvent(this.missionID);
}
class FetchedMissionShipmentsEvent extends MissionShipmentsEvents {}

class CheckedShipmentMissionShipmentsEvent extends MissionShipmentsEvents {}