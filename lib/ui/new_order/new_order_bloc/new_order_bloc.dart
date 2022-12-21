import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wepostexpresscustomer/models/address_model.dart';
import 'package:wepostexpresscustomer/models/address_response_model.dart';
import 'package:wepostexpresscustomer/models/create_order_model.dart';
import 'package:wepostexpresscustomer/models/delivery_times_model.dart';
import 'package:wepostexpresscustomer/models/new_order/address_new_order.dart';
import 'package:wepostexpresscustomer/models/package_model.dart';
import 'package:wepostexpresscustomer/models/payment_method_model.dart';
import 'package:wepostexpresscustomer/models/receiver_model.dart';
import 'package:wepostexpresscustomer/models/shipment_settings_model.dart';
import 'package:wepostexpresscustomer/models/user/user_model.dart';
import 'package:wepostexpresscustomer/ui/new_order/new_order_bloc/new_order_events.dart';
import 'package:wepostexpresscustomer/ui/new_order/new_order_bloc/new_order_states.dart';
import 'package:wepostexpresscustomer/ui/new_order/settings_new_order.dart';
import 'package:wepostexpresscustomer/utils/constants/app_keys.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/network/repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewOrderBloc extends Bloc<NewOrderEvents, NewOrderStates> {
  final Repository _repository;
  Position location;
  LatLng latLng;
  int currentIndex = 0;
  bool isPickup = true;
  DateTime dateTime ;
  List<ReceiverModel> receivers= [];
  List<UserModel> branches= [];
  List<AddressResponseModel> addresses= [];
  List<AddressResponseModel> receiverAddresses= [];
  List<ShipmentSettingsModel> settings= [];
  List<PackageModel> packages= [];
  List<PaymentMethodModel> paymentMethods= [];
  List<AddressOrderModel> packageWidgets= [];
  List<DeliveryTimeModel> deliveryTimes= [];

  PaymentMethodModel paymentMethodModel;
  PackageModel defaultPackage;
  int paymentType;
  AddressResponseModel senderAddress;
  UserModel selectedBranch;
  DeliveryTimeModel selectedDeliveryTime;
  AddressResponseModel receiverAddress;
  ReceiverModel receiverModel;

  String amount_to_be_collected = '0';
  String weightUnit = AppKeys.weights.first;
  String heightUnit= AppKeys.heights.first;
  String widthUnit= AppKeys.heights.first;
  String lengthUnit= AppKeys.heights.first;
  bool errorOccurred= false ;

  NewOrderBloc(this._repository) : super(InitialNewOrderState());

  static NewOrderBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<NewOrderStates> mapEventToState(NewOrderEvents event) async*
  {
    if (event is NextNewOrderEvent) {
      yield SuccessNextNewOrderState();
    }

    if (event is SetPaymentMethodNewOrderEvent) {
      yield SuccessPaymentMethodState();
    }

    if (event is SetAmountToBeCollectedNewOrderEvent) {
      yield SuccessSetAmountToBeCollectedNewOrderState();
    }

    if (event is CreateNewOrderEvent) {
      yield LoadingNewOrderState();
      final response = await _repository.createShipment(createOrderModel: CreateOrderModel(
        shipment_client_lat: senderAddress?.client_lat??'',
        shipment_client_lng: senderAddress?.client_lng??'',
        shipment_client_street_address_map: senderAddress?.client_street_address_map??'',
        shipment_client_url: senderAddress?.client_url??'',
        shipment_reciver_lat: receiverAddress.client_lat,
        shipment_reciver_lng: receiverAddress.client_lng,
        shipment_reciver_street_address_map: receiverAddress.client_street_address_map,
        shipment_reciver_url: receiverAddress.client_url,
        delivery_time:selectedDeliveryTime.name,
        packages: packageWidgets,
        shipment_payment_type: paymentType.toString(),
        shipment_reciver_address: receiverAddress.address,
        shipment_reciver_name: receiverModel.receiver_name,
        shipment_reciver_phone: receiverModel.receiver_mobile,
        shipment_shipping_date: dateTime.year.toString()+ '/'+ (dateTime.month > 9?'':'0')+ dateTime.month.toString()+ '/'+ (dateTime.day >9?'':'0')+ dateTime.day.toString(),
        shipment_to_country_id: receiverAddress.country_id,
        shipment_to_state_id: receiverAddress.country_id,
        shipment_type: isPickup? AppKeys.PICKUP.toString() : AppKeys.DROPOFF.toString(),
        shipment_branch_id: selectedBranch.id,
        shipment_client_address: senderAddress.id,
        shipment_client_phone: _repository.user.responsible_mobile??'',
        shipment_from_country_id: senderAddress.country_id,
        shipment_from_state_id: senderAddress.state_id,
        amount_to_be_collected: amount_to_be_collected,
        shipment_payment_method_id: paymentMethodModel.id.toString(),
      ));
      response.fold((l) => showToast(l,false), (r) => showToast(r,true));
      yield SuccessCreateOrderState();
    }

    if (event is SetSenderAddressNewOrderEvent) {
      yield SuccessSenderAddressOrderState();
    }

    if (event is SetBranchNewOrderEvent) {
      yield SuccessSetBranchAddressOrderState();
    }

    if (event is AddDateNewOrderEvent) {
      yield SuccessAddedDateOrderState();
    }

    if (event is SetPaymentNewOrderEvent) {
      yield SuccessPaymentSelectedOrderState();
    }

    if (event is SetReceiverAddressNewOrderEvent) {
      yield SuccessReceiverAddressOrderState();
    }

    if (event is ChangeSendReceiveNewOrderEvent) {
      isPickup = !isPickup;
      yield ChangedSendReceiveNewOrderState();
    }

    if (event is NewOrderChangeEvent) {
      yield SuccessStepForwardNewOrderState();
    }

    if (event is NewOrderChangeBackwardEvent) {
      yield SuccessStepBackwardNewOrderState();
    }

    if (event is AddPackageNewOrderEvent) {
      yield SuccessAddedPackageNewOrderState();
    }

    if (event is RemovePackageNewOrderEvent) {
      yield SuccessRemovedNewOrderState();
    }

    if (event is FetchNewOrderEvent) {
      errorOccurred = false;
      yield LoadingNewOrderState();
      location =  await Geolocator.getCurrentPosition();
      latLng = LatLng(location.latitude, location.longitude);

      final getShipmentSettings = await  _repository.getShipmentSettings();
      yield* getShipmentSettings.fold((l)async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r)async *{
        settings = r;
      });

      final getDeliveryTimes = await  _repository.getDeliveryTimes();
      yield* getDeliveryTimes.fold((l)async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r)async *{
        deliveryTimes = r;
      });

      final getAddresses = await _repository.getAddresses();
      final getReceiversAddresses = await  _repository.getReceiversAddresses();
      yield* getReceiversAddresses.fold((l)async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r)async *{
        receiverAddresses = r;
      });
      final getReceivers = await  _repository.getReceivers();
      yield* getReceivers.fold((l)async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r)async *{
        receivers = r;
      });


      final getBranches = await  _repository.getBranches();
      yield* getBranches.fold((l)async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r)async *{
        branches = r;
      });

      final getPackages = await  _repository.getPackages();
      yield* getPackages.fold((l)async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r)async *{
        packages = r;
      });

      final getPaymentMethods = await  _repository.getPaymentTypes();
      yield* getPaymentMethods.fold((l)async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r)async *{
        paymentMethods = r;
      });

      yield* getAddresses.fold((l) async*{
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r) async*{
        addresses = r;
      });
      if(dateTime==null){
        dateTime = DateTime.now().add(Duration(days: int.parse(settings?.firstWhere((element) => element.key ==SettingsNewOrder.is_date_required)?.value??'0')));
      }
try{
      if(selectedBranch ==null && branches != []){
        selectedBranch = branches.firstWhere((element) {
          return element.id == settings?.firstWhere((element) => element.key ==SettingsNewOrder.def_branch)?.value??'0';
        });
      }}catch
    (e){

    }
try {
  if (paymentMethodModel == null && paymentMethods != []) {
    paymentMethodModel = paymentMethods.firstWhere((element) {
      print('paymentMethodspaymentMethods');
      print(element.id);
      print(element.value);
      print(settings?.firstWhere((element) => element.key ==
          SettingsNewOrder.def_payment_method)?.toJson() ?? '0');
      return element.id == settings
          ?.firstWhere((element) =>
      element.key == SettingsNewOrder.def_payment_method)
          ?.value ?? '0';
    });
  }
}
      catch(e){

      }
      if(paymentType ==null ){
        paymentType = int.parse(settings.firstWhere((element) => element.key ==SettingsNewOrder.def_payment_type).value);
      }

      if(defaultPackage ==null && packages != []){
        defaultPackage = packages.firstWhere((element) {
          return element.id == settings?.firstWhere((element) => element.key ==SettingsNewOrder.def_package_type)?.value??'0';
        });
      }

      print('addresses');
      print(paymentMethods);
      print(addresses);
      print(settings.length);
      print(receivers);
      if(packageWidgets.length ==0){
        packageWidgets.add(
                AddressOrderModel(
                  weightUnit: AppKeys.weights.first,
                  heightUnit: AppKeys.heights.first,
                  widthUnit: AppKeys.heights.first,
                  packageModel: defaultPackage,
                  lengthUnit: AppKeys.heights.first,
                  quantity: 1.toString(),
                  weight: 1.toString(),
                  height: 1.toString(),
                  width: 1.toString(),
                  length: 1.toString(),
                ));
      }
      yield SuccessNewOrderState();
    }
  }


}
