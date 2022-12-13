import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wepostexpresscustomer/models/address_model.dart';
import 'package:wepostexpresscustomer/models/area_model.dart';
import 'package:wepostexpresscustomer/models/county_model.dart';
import 'package:wepostexpresscustomer/models/currency_model.dart';
import 'package:wepostexpresscustomer/models/payment_method_model.dart';
import 'package:wepostexpresscustomer/models/shipment_model.dart';
import 'package:wepostexpresscustomer/models/single_package_shipment_model.dart';
import 'package:wepostexpresscustomer/models/state_model.dart';
import 'package:wepostexpresscustomer/ui/search/bloc/search_events.dart';
import 'package:wepostexpresscustomer/ui/search/bloc/search_states.dart';
import 'package:wepostexpresscustomer/ui/shipment_details/bloc/shipment_details_events.dart';
import 'package:wepostexpresscustomer/ui/shipment_details/bloc/shipment_details_states.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/network/repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShipmentDetailsBloc extends Bloc<ShipmentDetailsEvents, ShipmentDetailsStates> {
  final Repository _repository;
  List<SinglePackageShipmentModel> packages =[];
  CurrencyModel currencyModel ;
  ShipmentModel shipmentModel;
  List<PaymentMethodModel> paymentTypes= [];
  bool errorOccurred= false ;

  ShipmentDetailsBloc(this._repository) : super(InitialShipmentDetailsState());

  static ShipmentDetailsBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<ShipmentDetailsStates> mapEventToState(ShipmentDetailsEvents event) async*
  {
    if (event is NextShipmentDetailsEvent) {
      yield SuccessNextShipmentDetailsState();
    }
    if (event is FetchShipmentDetailsEvent) {
      errorOccurred = false;
      yield LoadingShipmentDetailsState();
      if(event.code != null)
        {
          final getPaymentTypes = await  _repository.getPaymentTypes();
          yield* getPaymentTypes.fold((l)async* {
            errorOccurred = true;
            yield ErrorShipmentDetailsState(l);
          }, (r)async *{
            paymentTypes = r;
          });

          final f1 =await  _repository.getShipments(code: event.code);
          yield* f1.fold((l) => null, (r) async*{
            if(r != null && r.data != null && r.data.length==1){
              final getCurrencies = await  _repository.getCurrencies();
              yield* getCurrencies.fold((l)async* {
                errorOccurred = true;
                yield ErrorShipmentDetailsState(l);
              }, (r)async *{
                 currencyModel = r;
              });
              final f =await  _repository.getSingleShipmentPackages(shipmentId: r.data.first.id);
              shipmentModel = r.data.first;
              yield* f.fold((l) async*{
                errorOccurred = true;
                yield ErrorShipmentDetailsState(l);
              }, (r) async*{
                packages = r;
                print('r.length');
                yield SuccessShipmentDetailsState();
              });
            }
          });
        }else{
        print('ollplpl');
        print(event.shipmentModel);
        final getCurrencies = await  _repository.getCurrencies();
        yield* getCurrencies.fold((l)async* {
          errorOccurred = true;
          yield ErrorShipmentDetailsState(l);
        }, (r)async *{
          currencyModel = r;
        });
        final getPaymentTypes = await  _repository.getPaymentTypes();
        yield* getPaymentTypes.fold((l)async* {
          errorOccurred = true;
          yield ErrorShipmentDetailsState(l);
        }, (r)async *{
          paymentTypes = r;
        });

        shipmentModel = event.shipmentModel;
        final f =await  _repository.getSingleShipmentPackages(shipmentId: event.shipmentId);
        yield* f.fold((l) async*{
          errorOccurred = true;
          yield ErrorShipmentDetailsState(l);
        }, (r) async*{
          packages = r;
          print('r.length');
          print(packages.length);
          yield SuccessShipmentDetailsState();
        });
      }
    }

    }
  }
