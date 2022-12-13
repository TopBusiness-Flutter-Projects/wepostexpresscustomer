import 'package:wepostexpresscustomer/models/area_model.dart';
import 'package:wepostexpresscustomer/models/state_model.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:wepostexpresscustomer/components/main_button.dart';
import 'package:wepostexpresscustomer/components/my_form_field.dart';
import 'package:wepostexpresscustomer/components/my_svg.dart';
import 'package:wepostexpresscustomer/models/county_model.dart';
import 'package:wepostexpresscustomer/models/user/user_model.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_bloc.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_events.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_states.dart';
import 'package:wepostexpresscustomer/ui/add_new_receiver_address/bloc/add_receiver_address_bloc.dart';
import 'package:wepostexpresscustomer/ui/add_new_receiver_address/bloc/add_receiver_address_events.dart';
import 'package:wepostexpresscustomer/ui/add_new_receiver_address/bloc/add_receiver_address_states.dart';
import 'package:wepostexpresscustomer/ui/home/home_screen.dart';
import 'package:wepostexpresscustomer/ui/login/login_screen.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddReceiverAddressScreen extends StatefulWidget {
  @override
  _AddReceiverAddressScreenState createState() => _AddReceiverAddressScreenState();
}

class _AddReceiverAddressScreenState extends State<AddReceiverAddressScreen> {
  final formKey = GlobalKey<FormState>();
  PickResult pickResult;
  TextEditingController addressController = TextEditingController();
  TextEditingController addressSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddReceiverAddressBloc>(
      create: (BuildContext context) => di<AddReceiverAddressBloc>()..add(FetchAddReceiverAddressEvent()),
      child: BlocListener<AddReceiverAddressBloc, AddReceiverAddressStates>(
        listener: (BuildContext context, AddReceiverAddressStates state) async {
          if (state is ErrorAddReceiverAddressState) {
            showToast(state.error, false);
            if(state.canPop){
              Navigator.pop(context);
            }
          }
          if (state is SuccessAddReceiverAddressState) {
            Navigator.pop(context);
          }
          if (state is AddReceiverAddressedSuccessfully) {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=> HomeScreen(false)));
          }
          if (state is LoadingProgressAddReceiverAddressState) {
            showProgressDialog(context);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Form(
              key: formKey,
              child: Builder(
                builder: (context) => SizedBox.expand(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (1.2 / 100),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * (6.91 / 100),
                              child: Center(
                                child: Text(
                                  tr(LocalKeys.addAddress),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (1.97 / 100),
                      ),
                      Expanded(
                          child: buildSecond(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSecond() {
    return Builder(
      builder: (context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * (4.9 / 100),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: Text(
                tr(LocalKeys.address),
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child:  TextFormField(
                controller: addressController,
                validator: (v){
                  if(v == null ||v.isEmpty){
                    return tr(LocalKeys.this_field_cant_be_empty);
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: tr(LocalKeys.address),
                  hintStyle: TextStyle(fontSize: 11),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (4.9 / 100),
            ),
            MyFormField(
              context: context,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              hasError: BlocProvider.of<AddReceiverAddressBloc>(context).selectedCountry == null,
              error: tr(LocalKeys.this_field_cant_be_empty),
              child: InkWell(
                onTap: () {
                  showCountries(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LocalKeys.country),
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            BlocProvider.of<AddReceiverAddressBloc>(context).selectedCountry != null
                                ? BlocProvider.of<AddReceiverAddressBloc>(context).selectedCountry.name
                                : tr(LocalKeys.country),
                            style: TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: rgboOrHex(
                                Config.get.styling[Config.get.themeMode].primary),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                      ),
                      Container(
                        height: 1,
                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (4.9 / 100),
            ),
            MyFormField(
              context: context,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              hasError: BlocProvider.of<AddReceiverAddressBloc>(context).selectedCity == null,
              error: tr(LocalKeys.this_field_cant_be_empty),
              child: InkWell(
                onTap: () {
                  return showCities(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LocalKeys.region),
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            BlocProvider.of<AddReceiverAddressBloc>(context).selectedCity != null
                                ? BlocProvider.of<AddReceiverAddressBloc>(context).selectedCity.name
                                : tr(LocalKeys.region),
                            style: TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: rgboOrHex(
                                Config.get.styling[Config.get.themeMode].primary),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                      ),
                      Container(
                        height: 1,
                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (4.9 / 100),
            ),
            MyFormField(
              context: context,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              hasError: false,
              error: tr(LocalKeys.this_field_cant_be_empty),
              child: InkWell(
                onTap: () {
                  return showAreas(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LocalKeys.area),
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            BlocProvider.of<AddReceiverAddressBloc>(context).selectedArea != null
                                    ? BlocProvider.of<AddReceiverAddressBloc>(context).selectedArea.name
                                    : tr(LocalKeys.area),
                            style: TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: rgboOrHex(
                                    Config.get.styling[Config.get.themeMode].primary),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                      ),
                      Container(
                        height: 1,
                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (4.9 / 100),
            ),
            BlocBuilder<AddReceiverAddressBloc,AddReceiverAddressStates>(
              builder: (context, state) => ConditionalBuilder(
                condition:BlocProvider.of<AddReceiverAddressBloc>(context).googleMapsModel!=null&& BlocProvider.of<AddReceiverAddressBloc>(context).googleMapsModel.value == '1',
                builder:(context) =>  MyFormField(
                  context: context,
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                  hasError: false,
                  error: tr(LocalKeys.this_field_cant_be_empty),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height* 0.4,
                    child: PlacePicker(
                      apiKey: Config.get.google_maps_ApiKey,
                      initialPosition: LatLng(BlocProvider.of<AddReceiverAddressBloc>(context).latLng?.latitude??0,
                              BlocProvider.of<AddReceiverAddressBloc>(context).latLng?.longitude??0),
                      selectedPlaceWidgetBuilder: (context, selectedPlace, state, isSearchBarFocused) => Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width* 0.25,vertical: MediaQuery.of(context).size.height* 0.01),
                            alignment: Alignment.bottomCenter,
                            child: MainButton(
                              borderRadius: 0,
                              onPressed: () {
                                setState(() {
                                  pickResult = selectedPlace;
                                });
                              },
                              text: tr(LocalKeys.select),
                              textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                              color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                            ),
                          ),
                        ],
                      ),
                      useCurrentLocation: true,
                      selectInitialPosition: true,
                      usePlaceDetailSearch: false,
                      strictbounds: false,
                      searchForInitialValue: false,
                      enableMapTypeButton: false,
                      usePinPointingSearch: false,
                      autocompleteOnTrailingWhitespace: false,
                      automaticallyImplyAppBarLeading: false,
                      enableMyLocationButton: true,
                      resizeToAvoidBottomInset: false,
                      hidePlaceDetailsWhenDraggingPin: false,
                      forceAndroidLocationManager: false,
                      forceSearchOnZoomChanged: false,
                      //usePlaceDetailSearch: true,
                      onPlacePicked: (result) {
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (4.9 / 100),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (6.1 / 100),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: MainButton(
                borderRadius: 0,
                onPressed: () {
                  formKey.currentState.save();
                  if(formKey.currentState.validate()){
                    BlocProvider.of<AddReceiverAddressBloc>(context).addressName = addressController.text;
                    BlocProvider.of<AddReceiverAddressBloc>(context).add(SubmitAddReceiverAddressEvent(userModel: UserModel(),pickResult: pickResult));
                  }
                },
                text: tr(LocalKeys.add_new_address),
                textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (1.1 / 100),
            ),
          ],
        ),
      ),
    );
  }

  showCountries(BuildContext context) async {
    final blocContext = context;
    CountryModel  countryModel = BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedCountry;
    BlocProvider.of<AddReceiverAddressBloc>(blocContext).searchCountries = BlocProvider.of<AddReceiverAddressBloc>(blocContext).countries;

    Navigator.push(context,MaterialPageRoute(builder: (_)=>Countries(blocContext,BlocProvider.of<AddReceiverAddressBloc>(blocContext).countries))).then((value) {
      setState(() {});
      if (BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedCountry != null&&countryModel != BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedCountry) {

        BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedCity = null;
        BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedArea =null;
        BlocProvider.of<AddReceiverAddressBloc>(blocContext).add(FetchCitiesAddReceiverAddressEvent(countryId: BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedCountry.id));
      }
      return null;
    });
  }
  showCities(BuildContext context) async {
    final blocContext = context;
    StateModel stateModel = BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedCity;
    await Navigator.push(context,MaterialPageRoute(builder: (_)=>CitiesSearch(blocContext,BlocProvider.of<AddReceiverAddressBloc>(blocContext).cities))).then((value) {
      setState(() {});
      if (BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedCity != null &&
              stateModel != BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedCity) {
        BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedArea = null;
        BlocProvider.of<AddReceiverAddressBloc>(blocContext).add(FetchAreasAddReceiverAddressEvent(cityId: BlocProvider.of<AddReceiverAddressBloc>(blocContext).selectedCity.id));
      }
      return null;
    });
  }
  showAreas(BuildContext context) async {
    final blocContext = context;
    await Navigator.push(context,MaterialPageRoute(builder: (_)=>AreaSearch(blocContext,BlocProvider.of<AddReceiverAddressBloc>(blocContext).areas))).then((value) {
      setState(() {});
    });
  }
}

class Countries extends StatefulWidget{
  final BuildContext blocContext;
  List<CountryModel> searchCountries ;
  Countries(this.blocContext,this.searchCountries);

  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {

  @override
  Widget build(BuildContext context) {return SafeArea(
    child: Scaffold(
      body:BlocProvider.value(
        value: BlocProvider.of<AddReceiverAddressBloc>(context),
        child: Builder(
          builder: (context) =>  Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: TextFormField(
                      onChanged: (v){
                        widget.searchCountries = BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).countries.where((element) {

                          return element.name.toLowerCase().contains(v.toLowerCase());
                        }).toList();
                        // BlocProvider.of<AddReceiverAddressBloc>(blocContext).add(ChangeSearchReceiverAddressEvent());
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: tr(LocalKeys.country),
                        hintStyle: TextStyle(fontSize: 11),
                        focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(color: Colors.black, width: 2)),
                      ),
                    ),
                  ),
                  BlocBuilder<AddReceiverAddressBloc,AddReceiverAddressStates>(
                    builder: (context, state) {
                      print('AddReceiverAddressStates');
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:widget.searchCountries.length,
                        itemBuilder: (context, index) => MaterialButton(
                          onPressed: () {
                            BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).selectedCountry = widget.searchCountries[index];
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                                  vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              widget.searchCountries[index].name,
                              style: TextStyle(fontWeight: () {
                                if (BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).selectedCountry != null &&
                                        BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).selectedCountry ==
                                                widget.searchCountries[index]) {
                                  return FontWeight.bold;
                                } else {
                                  return FontWeight.normal;
                                }
                              }()),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  MaterialButton(
                     color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                            vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Container(
                      width: double.infinity,
                      child: Text(tr(LocalKeys.cancel)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * (3.4 / 100),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  }
}

class CitiesSearch extends StatefulWidget{
  final BuildContext blocContext;
  List<StateModel> searchCitiesSearch ;
  CitiesSearch(this.blocContext,this.searchCitiesSearch);

  @override
  _CitiesSearchState createState() => _CitiesSearchState();
}

class _CitiesSearchState extends State<CitiesSearch> {

  @override
  Widget build(BuildContext context) {return SafeArea(
    child: Scaffold(
      body:BlocProvider.value(
        value: BlocProvider.of<AddReceiverAddressBloc>(context),
        child: Builder(
          builder: (context) =>  Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: TextFormField(
                      onChanged: (v){
                        widget.searchCitiesSearch = BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).cities.where((element) {

                          return element.name.toLowerCase().contains(v.toLowerCase());
                        }).toList();
                        // BlocProvider.of<AddReceiverAddressBloc>(blocContext).add(ChangeSearchReceiverAddressEvent());
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: tr(LocalKeys.region),
                        hintStyle: TextStyle(fontSize: 11),
                        focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(color: Colors.black, width: 2)),
                      ),
                    ),
                  ),
                  BlocBuilder<AddReceiverAddressBloc,AddReceiverAddressStates>(
                    builder: (context, state) {
                      print('AddReceiverAddressStates');
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:widget.searchCitiesSearch.length,
                        itemBuilder: (context, index) => MaterialButton(
                          onPressed: () {
                            BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).selectedCity = widget.searchCitiesSearch[index];
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                                  vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              widget.searchCitiesSearch[index].name,
                              style: TextStyle(fontWeight: () {
                                if (BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).selectedCity != null &&
                                        BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).selectedCity ==
                                                widget.searchCitiesSearch[index]) {
                                  return FontWeight.bold;
                                } else {
                                  return FontWeight.normal;
                                }
                              }()),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  MaterialButton(
                     color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                            vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Container(
                      width: double.infinity,
                      child: Text(tr(LocalKeys.cancel)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * (3.4 / 100),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  }
}

class AreaSearch extends StatefulWidget{
  final BuildContext blocContext;
  List<AreaModel> searchAreaSearch ;
  AreaSearch(this.blocContext,this.searchAreaSearch);

  @override
  _AreaSearchState createState() => _AreaSearchState();
}

class _AreaSearchState extends State<AreaSearch> {

  @override
  Widget build(BuildContext context) {return SafeArea(
    child: Scaffold(
      body:BlocProvider.value(
        value: BlocProvider.of<AddReceiverAddressBloc>(context),
        child: Builder(
          builder: (context) =>  Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: TextFormField(
                      onChanged: (v){
                        widget.searchAreaSearch = BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).areas.where((element) {

                          return element.name.toLowerCase().contains(v.toLowerCase());
                        }).toList();
                        // BlocProvider.of<AddReceiverAddressBloc>(blocContext).add(ChangeSearchReceiverAddressEvent());
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: tr(LocalKeys.area),
                        hintStyle: TextStyle(fontSize: 11),
                        focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(color: Colors.black, width: 2)),
                      ),
                    ),
                  ),
                  BlocBuilder<AddReceiverAddressBloc,AddReceiverAddressStates>(
                    builder: (context, state) {
                      print('AddReceiverAddressStates');
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:widget.searchAreaSearch.length,
                        itemBuilder: (context, index) => MaterialButton(
                          onPressed: () {
                            BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).selectedArea = widget.searchAreaSearch[index];
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                                  vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              widget.searchAreaSearch[index].name,
                              style: TextStyle(fontWeight: () {
                                if (BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).selectedArea != null &&
                                        BlocProvider.of<AddReceiverAddressBloc>(widget.blocContext).selectedArea ==
                                                widget.searchAreaSearch[index]) {
                                  return FontWeight.bold;
                                } else {
                                  return FontWeight.normal;
                                }
                              }()),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  MaterialButton(
                     color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                            vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                    child: Container(
                      width: double.infinity,
                      child: Text(tr(LocalKeys.cancel)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * (3.4 / 100),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  }
}
