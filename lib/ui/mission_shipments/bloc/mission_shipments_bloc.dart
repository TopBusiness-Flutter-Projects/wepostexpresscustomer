import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/models/create_mission_model.dart';
import 'package:wepostexpresscustomer/models/payment_method_model.dart';
import 'package:wepostexpresscustomer/models/shipment_model.dart';
import 'package:wepostexpresscustomer/ui/config_loader/bloc/config_loader_events.dart';
import 'package:wepostexpresscustomer/ui/config_loader/bloc/config_loader_states.dart';
import 'package:wepostexpresscustomer/ui/create_mission/bloc/create_mission_events.dart';
import 'package:wepostexpresscustomer/ui/create_mission/bloc/create_mission_states.dart';
import 'package:wepostexpresscustomer/ui/mission_shipments/bloc/mission_shipments_events.dart';
import 'package:wepostexpresscustomer/ui/mission_shipments/bloc/mission_shipments_states.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpresscustomer/utils/cache/cache_helper.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/app_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:wepostexpresscustomer/utils/network/repository.dart';

class MissionShipmentsBloc extends Bloc<MissionShipmentsEvents, MissionShipmentsStates> {
  final Repository _repository;
  List<ShipmentModel> shipments=[];
  List<ShipmentModel> checkedShipments=[];
  List<PaymentMethodModel> paymentTypes= [];

  MissionShipmentsBloc(this._repository) : super(InitialMissionShipmentsState());

  static MissionShipmentsBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<MissionShipmentsStates> mapEventToState(MissionShipmentsEvents event) async*
  {
    if(event is CheckedShipmentMissionShipmentsEvent){
      yield ShipmentCheckedMissionShipmentsState();
    }

    if (event is FetchMissionShipmentsEvent) {
      yield LoadingMissionShipmentsState();

      final getPaymentTypes = await  _repository.getPaymentTypes();
      yield* getPaymentTypes.fold((l)async* {
        yield ErrorMissionShipmentsState(l);
      }, (r)async *{
        paymentTypes = r;
      });

      final f =await  _repository.getMissionShipments(id: event.missionID);
      yield* f.fold((l) async*{
        yield ErrorMissionShipmentsState(l);
      }, (r) async*{
        shipments = r;
        print('rrrr.length');
        print(paymentTypes);
        print(shipments.length);
        yield SuccessMissionShipmentsState();
      });
      yield SuccessMissionShipmentsState();
    }

  }


}
