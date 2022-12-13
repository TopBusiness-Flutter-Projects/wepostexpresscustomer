import 'package:wepostexpresscustomer/models/payment_method_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/models/mission_model.dart';
import 'package:wepostexpresscustomer/models/notification_model.dart';
import 'package:wepostexpresscustomer/models/shipment_model.dart';
import 'package:wepostexpresscustomer/models/shipments_response_model.dart';
import 'package:wepostexpresscustomer/ui/home/bloc/home_events.dart';
import 'package:wepostexpresscustomer/ui/home/bloc/home_states.dart';
import 'package:wepostexpresscustomer/ui/login/bloc/login_events.dart';
import 'package:wepostexpresscustomer/ui/login/bloc/login_states.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpresscustomer/utils/network/repository.dart';

class HomeBloc extends Bloc<HomeEvents, HomeStates> {
  final Repository _repository;
  int currentIndex = 0 ;
  int shipmentPages = 0 ;
  List<ShipmentModel> shipments=[];
  List<MissionModel> missions=[];
  ShipmentResponseModel shipmentResponseModel;
  bool errorOccurred= false ;
  List<PaymentMethodModel> paymentTypes= [];

  HomeBloc(this._repository) : super(InitialHomeState());

  static HomeBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<HomeStates> mapEventToState(HomeEvents event) async*
  {
    if (event is FetchUserWalletEvent) {
      final f =await  _repository.getUserWallet();

      yield* f.fold((l) async*{
        errorOccurred = true;
        yield ErrorHomeState(l);
      }, (r) async*{

        yield SuccessWalletHomeState();
      });
    }
    if (event is FetchHomeEvent) {
      final getPaymentTypes = await  _repository.getPaymentTypes();
      yield* getPaymentTypes.fold((l)async* {
        errorOccurred = true;
        yield ErrorHomeState(l);
      }, (r)async *{
        paymentTypes = r;
      });

      print('ssssssss');
      errorOccurred = false;
      yield LoadingHomeState();
      final f =await  _repository.getShipments(page: (1).toString());
      // final missionsResponse =await  _repository.getMissions();
      yield* f.fold((l) async*{
        errorOccurred = true;
        yield ErrorHomeState(l);
      }, (r) async*{
        shipmentResponseModel= r;
        shipments = r.data;
        shipmentPages =1;
        yield SuccessHomeState();
      });
      // yield* missionsResponse.fold((l) async*{
      //   errorOccurred = true;
      //   yield ErrorHomeState(l);
      // }, (r) async*{
      //   missions = r;
      // });
    }

    if (event is FetchMoreHomeEvent) {
      shipmentPages+=1;
      yield LoadingMoreShipmentsHomeState();
      final f =await  _repository.getShipments(page: (shipmentPages+1).toString());
      yield* f.fold((l) async*{
        yield ErrorHomeState(l);
      }, (r) async*{
        shipmentResponseModel= r;
        shipments .addAll(r.data) ;
        yield SuccessHomeState();
      });
    }

    if (event is HomePageChangedEvent) {
      yield SuccessChangedPageState();
    }

    if (event is LogoutHomeEvent) {
      await _repository.logout();
      yield LogoutSuccessfullyHomeState();
    }
  }
}
