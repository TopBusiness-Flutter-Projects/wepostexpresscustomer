import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/models/create_mission_model.dart';
import 'package:wepostexpresscustomer/models/payment_method_model.dart';
import 'package:wepostexpresscustomer/models/shipment_model.dart';
import 'package:wepostexpresscustomer/models/user/user_model.dart';
import 'package:wepostexpresscustomer/ui/config_loader/bloc/config_loader_events.dart';
import 'package:wepostexpresscustomer/ui/config_loader/bloc/config_loader_states.dart';
import 'package:wepostexpresscustomer/ui/create_mission/bloc/create_mission_events.dart';
import 'package:wepostexpresscustomer/ui/create_mission/bloc/create_mission_states.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpresscustomer/utils/cache/cache_helper.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/app_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:wepostexpresscustomer/utils/network/repository.dart';

class CreateMissionBloc extends Bloc<CreateMissionEvents, CreateMissionStates> {
  final Repository _repository;
  List<ShipmentModel> pickShipments=[];
  List<ShipmentModel> deliveryShipments=[];
  List<ShipmentModel> checkedShipments=[];
  List<ShipmentModel> shipments=[];
  List<PaymentMethodModel> paymentTypes= [];
  String address = '';
  // UserModel selectedBranch;
  int missionType= AppKeys.PICKUP_TYPE;
  List<UserModel> branches= [];
  String selectedType;
  PaymentMethodModel paymentMethod;
  bool errorOccurred= false ;


  CreateMissionBloc(this._repository) : super(InitialCreateMissionState());

  static CreateMissionBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<CreateMissionStates> mapEventToState(CreateMissionEvents event) async*
  {
    if(event is CheckedShipmentCreateMissionEvent){
      yield ShipmentCheckedCreateMissionState();
    }
    if(event is SetBranchCreateMissionEvent){
      yield SetBranchCreateMissionState();
    }
    if(event is SetPaymentMethodCreateMissionEvent){
      pickShipments = [...shipments.where((element) {
        print('elementelement');
        print(element.payment_method_id);
        print(element.id);
        print(paymentMethod.id);
        print((element.status_id == AppKeys.SAVED_STATUS.toString())&&(element.payment_method_id == paymentMethod.id));
        return (element.status_id == AppKeys.SAVED_STATUS.toString())&&(element.payment_method_id == paymentMethod.id);
      }).toList()];
      deliveryShipments = shipments.where((element) => (element.status_id == AppKeys.DELIVERED_STATUS.toString())&& (element.payment_method_id == paymentMethod.id)).toList();

      yield SuccessPaymentMethodMissionState();
    }

    if (event is FetchCreateMissionEvent) {
      errorOccurred = false;
      yield LoadingCreateMissionState();

      final getPaymentTypes = await  _repository.getPaymentTypes();
      yield* getPaymentTypes.fold((l)async* {
        errorOccurred = true;
        yield ErrorCreateMissionState(l);
      }, (r)async *{
        paymentTypes = r;
      });

      final getBranches = await  _repository.getBranches();
      yield* getBranches.fold((l)async* {
        errorOccurred = true;
        yield ErrorCreateMissionState(l);
      }, (r)async *{
        branches = r;
      });

      final f =await  _repository.getShipments();
      yield* f.fold((l) async*{
        errorOccurred = true;
        yield ErrorCreateMissionState(l);
      }, (r) async*{
        print('element shipments rrrr');
        print(r.data.length);

        shipments=r.data.where((element) {
          print('element shipments');
          print(element.payment_method_id);
          print(element.type);
          print(element.mission_id);
          return element.type==AppKeys.PICKUP_Key && (element.mission_id == null || element.mission_id == "null"||element.mission_id.isEmpty);
        }).toList();
        print('rrrr.length');
        print(shipments.length);
        paymentMethod = paymentTypes.first;
        pickShipments = shipments.where((element) => (element.status_id == AppKeys.SAVED_STATUS.toString())&&(element.payment_method_id == paymentMethod.id)).toList();
        deliveryShipments = shipments.where((element) => (element.status_id == AppKeys.DELIVERED_STATUS.toString())&& (element.payment_method_id == paymentMethod.id)).toList();

        print(paymentTypes);
        print(r.data.length);
        print(deliveryShipments.length);
        print(pickShipments.length);
        yield SuccessCreateMissionState();
      });
      yield SuccessCreateMissionState();
    }

    if (event is CreateMissionEvent) {
      yield LoadingCreatingMissionState();
      final f = await _repository.createMission(createMissionModel: CreateMissionModel( clientAddress: address, clientId: _repository.user.id, checkedShipments: checkedShipments, type: missionType.toString()));
      yield* f.fold((l) async*{
        yield ErrorCreateMissionState(l);
      }, (r) async*{
        yield MissionCreatedSuccessfullyMissionState();
      });
    }
  }


}
