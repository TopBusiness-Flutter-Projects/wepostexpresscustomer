import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wepostexpresscustomer/models/address_model.dart';
import 'package:wepostexpresscustomer/models/area_model.dart';
import 'package:wepostexpresscustomer/models/county_model.dart';
import 'package:wepostexpresscustomer/models/google_maps_model.dart';
import 'package:wepostexpresscustomer/models/state_model.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_events.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_states.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/network/repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressBloc extends Bloc<AddAddressEvents, AddAddressStates> {
  final Repository _repository;
  Position location;
  LatLng latLng;
  int currentIndex = 0;
  List<CountryModel> countries=[];
  List<StateModel> cities=[];
  List<AreaModel> areas=[];
  GoogleMapsModel googleMapsModel;
  List<CountryModel> searchCountries = [];

  String addressName ;
  CountryModel selectedCountry ;
  StateModel selectedCity ;
  AreaModel selectedArea ;

  AddAddressBloc(this._repository) : super(InitialAddAddressState());

  static AddAddressBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<AddAddressStates> mapEventToState(AddAddressEvents event) async*
  {
    if (event is NextAddAddressEvent) {
      yield SuccessNextAddAddressState();
    }

    if (event is SubmitAddAddressEvent) {
      yield LoadingAddAddressState();
      final registerResponse =await _repository.saveNewAddressOfSender(addressModel: AddressModel(
        address_name: addressName,
        area_id: selectedArea?.id??'',
        area_name: selectedArea?.name??'',
        country_code: selectedCity.country_code,
        country_currency: selectedCountry.currency,
        country_id: selectedCountry.id,
        country_name: selectedCountry.name,
        country_phonecode: selectedCountry.phonecode,
        state_id: selectedCity.id,
        state_name: selectedCity.name,
      ),pickResult: event.pickResult);

      yield* registerResponse.fold((l)async* {
        yield ErrorAddAddressState(l,false);
      }, (r) async*{
        yield SuccessAddAddressState();
        print('dadadad');
        print(r);
        });
    }

    if (event is FetchAddAddressEvent) {
      yield LoadingProgressAddAddressState();
      location =  await Geolocator.getCurrentPosition();
      latLng = LatLng(location.latitude, location.longitude);
      final countriesResponse =await _repository.getAllCountries();
      final googleMapsResponse =await _repository.getGoogleMaps();

      yield* countriesResponse.fold((l)async* {

        yield ErrorAddAddressState(l,true);
      }, (r) async*{
        countries = r;
        });

      yield* googleMapsResponse.fold((l)async* {
        print('llllllllllllll');
        print(l);
        yield ErrorAddAddressState(l,true);
      }, (r) async*{
        googleMapsModel = r;
        yield SuccessAddAddressState();
        });
    }
    if (event is FetchCitiesAddAddressEvent) {
      yield LoadingProgressAddAddressState();
      final citiesResponse =await _repository.getCities(countyID: event.countryId);
      yield* citiesResponse.fold((l)async* {
        showToast(l,false);
        yield ErrorAddAddressState(l,true);
      }, (r) async*{
        cities = r;
        print('cities');
        print(cities.length);
        yield SuccessAddAddressState();
        });
    }
    if (event is FetchAreasAddAddressEvent) {
      yield LoadingProgressAddAddressState();
      final areasResponse =await _repository.getAreas(cityID: event.cityId);
      yield* areasResponse.fold((l)async* {
        showToast(l,false);
        yield ErrorAddAddressState(l,true);
      }, (r) async*{
        areas = r;
        print('areas');
        print(areas.length);
        yield SuccessAddAddressState();
        });
    }
  }


}
