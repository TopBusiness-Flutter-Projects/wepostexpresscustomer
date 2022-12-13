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
import 'package:wepostexpresscustomer/ui/home/home_screen.dart';
import 'package:wepostexpresscustomer/ui/register/bloc/register_bloc.dart';
import 'package:wepostexpresscustomer/ui/register/bloc/register_events.dart';
import 'package:wepostexpresscustomer/ui/register/bloc/register_states.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final pageController = PageController();
  final formKey = GlobalKey<FormState>();
  final formKeyMap = GlobalKey<FormState>();
  PickResult pickResult;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (BuildContext context) => di<RegisterBloc>()..add(FetchRegisterEvent()),
      child: BlocListener<RegisterBloc, RegisterStates>(
        listener: (BuildContext context, RegisterStates state) async {
          if (state is ErrorRegisterState) {
            showToast(state.error, false);
            if (state.canPop) {
              Navigator.pop(context);
            }
          }
          if (state is SuccessRegisterState) {
            Navigator.pop(context);
          }
          if (state is RegisteredSuccessfully) {
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(false)));
          }
          if (state is LoadingProgressRegisterState) {
            showProgressDialog(context);
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            if (pageController.page != 0) {
              pageController.previousPage(
                  duration: Duration(milliseconds: 250), curve: Curves.easeIn);
              return false;
            } else {
              return true;
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
                            SizedBox(width:  MediaQuery.of(context).size.width * (2 / 100),),
                            Expanded(
                              child: Container(
                                child: MySVG(
                                  size: MediaQuery.of(context).size.width * (4.9 / 100),
                                  imagePath: 'assets/images/logo.png',
                            fromFiles: true,
                                ),

                              ),
                            ),
                            SizedBox(width:  MediaQuery.of(context).size.width * (1 / 100),),
                            Expanded(
                              child: Center(
                                child: Text(
                                  tr(LocalKeys.createAccount),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: Text(
                                  tr(LocalKeys.login),
                                  style: TextStyle(
                                    color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (1.97 / 100),
                        ),
                        BlocConsumer<RegisterBloc, RegisterStates>(
                          listener: (context, state) => null,
                          builder: (context, state) => LinearProgressIndicator(
                            value: state is LoadingRegisterState
                                ? null
                                : (BlocProvider.of<RegisterBloc>(context).currentIndex + 1) * 0.33,
                            backgroundColor:
                                rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant)
                                    .withOpacity(0.205),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              rgboOrHex(
                                Config.get.styling[Config.get.themeMode].primary,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: PageView(
                            controller: pageController,
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              BlocProvider.of<RegisterBloc>(context).currentIndex = index;
                              BlocProvider.of<RegisterBloc>(context).add(NextRegisterEvent());
                            },
                            children: [
                              buildFirst(),
                              buildSecond(),
                              buildThird(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildFirst() {
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
                tr(LocalKeys.name),
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
              child: TextFormField(
                controller: nameController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return tr(LocalKeys.this_field_cant_be_empty);
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: tr(LocalKeys.name),
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
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: Text(
                tr(LocalKeys.mobile),
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
              child: TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return tr(LocalKeys.this_field_cant_be_empty);
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: tr(LocalKeys.mobile),
                  hintStyle: TextStyle(fontSize: 11),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (3.9 / 100),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: Text(
                tr(LocalKeys.email),
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
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return tr(LocalKeys.this_field_cant_be_empty);
                  }
                  else if(!RegExp(
                    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
                  ).hasMatch(v.toLowerCase().trim())){
                    return tr(LocalKeys.thisIsNotEmail);
                  }else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: tr(LocalKeys.email),
                  hintStyle: TextStyle(fontSize: 11),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (4.1 / 100),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: Text(
                tr(LocalKeys.password),
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            BlocBuilder<RegisterBloc,RegisterStates>(
              builder: (context, state) => Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                child: TextFormField(
                  controller: passwordController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return tr(LocalKeys.this_field_cant_be_empty);
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.visiblePassword,

                  obscureText: !BlocProvider.of<RegisterBloc>(context).showPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        BlocProvider.of<RegisterBloc>(context).showPassword = !BlocProvider.of<RegisterBloc>(context).showPassword;
                        BlocProvider.of<RegisterBloc>(context).add(PasswordToggleChangedRegisterEvent());
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: BlocProvider.of<RegisterBloc>(context).showPassword  ? Colors.blue : Colors.grey,
                      ),
                    ),
                    hintText: tr(LocalKeys.password),
                    hintStyle: TextStyle(fontSize: 11),
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0)),
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (25 / 100),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: MainButton(
                borderColor: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                borderRadius: 0,
                onPressed: () {
                  formKey.currentState.save();
                  if (formKey.currentState.validate()) {
                    pageController.nextPage(
                        duration: Duration(milliseconds: 250), curve: Curves.ease);
                  }
                },
                text: tr(LocalKeys.next),
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
                tr(LocalKeys.addressName),
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
              child: TextFormField(
                controller: addressController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return tr(LocalKeys.this_field_cant_be_empty);
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: tr(LocalKeys.addressName),
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
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              hasError: BlocProvider.of<RegisterBloc>(context).selectedCountry == null,
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
                            BlocProvider.of<RegisterBloc>(context).selectedCountry != null
                                ? BlocProvider.of<RegisterBloc>(context).selectedCountry.name
                                : tr(LocalKeys.country),
                            style: TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
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
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              hasError: BlocProvider.of<RegisterBloc>(context).selectedCity == null,
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
                            BlocProvider.of<RegisterBloc>(context).selectedCity != null
                                ? BlocProvider.of<RegisterBloc>(context).selectedCity.name
                                : tr(LocalKeys.region),
                            style: TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
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
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
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
                            BlocProvider.of<RegisterBloc>(context).selectedArea != null
                                ? BlocProvider.of<RegisterBloc>(context).selectedArea.name
                                : tr(LocalKeys.area),
                            style: TextStyle(fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24,
                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
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
            SizedBox(
              height: MediaQuery.of(context).size.height * (6.1 / 100),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: MainButton(
                borderRadius: 0,
                onPressed: () {
                  formKey.currentState.save();
                  if (formKey.currentState.validate()) {
                    pageController.nextPage(
                        duration: Duration(milliseconds: 250), curve: Curves.ease);
                  }
                },
                text: tr(LocalKeys.next),
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

  buildThird() {
    return Builder(
        builder: (context) => Form(
          key: formKeyMap,
          child: Stack(
            children: [
              Column(
                    children: [
                      BlocBuilder<RegisterBloc,RegisterStates>(
                        builder: (context, state) => ConditionalBuilder(
                          condition:BlocProvider.of<RegisterBloc>(context).googleMapsModel!=null&& BlocProvider.of<RegisterBloc>(context).googleMapsModel.value == '1',
                          builder:(context) =>  Expanded(
                            child: MyFormField(
                              context: context,
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                              hasError: false,
                              error: tr(LocalKeys.this_field_cant_be_empty),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height* 0.4,
                                child: PlacePicker(
                                  apiKey: Config.get.google_maps_ApiKey,
                                  initialPosition: LatLng(BlocProvider.of<RegisterBloc>(context).latLng?.latitude??0,
                                          BlocProvider.of<RegisterBloc>(context).latLng?.longitude??0),
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
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (1.1 / 100),
                      ),
                    ],
                  ),
              Column(
                children: [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                    child: MainButton(
                      borderColor:
                      rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                      borderRadius: 0,
                      onPressed: () {
                        formKeyMap.currentState.save();
                        if(formKeyMap.currentState.validate()){
                          BlocProvider.of<RegisterBloc>(context).add(SubmitRegisterEvent(
                                  pickResult: pickResult,
                                  addressName: addressController.text,
                                  userModel: UserModel(
                                    email: emailController.text,
                                    name: nameController.text,
                                    password: passwordController.text,
                                    responsible_mobile: mobileController.text,
                                  )));
                        }
                      },
                      text: tr(LocalKeys.create_my_account),
                      textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  showCountries(BuildContext context) async {
    final blocContext = context;
    CountryModel countryModel = BlocProvider.of<RegisterBloc>(blocContext).selectedCountry;
    await Navigator.push(context,MaterialPageRoute(builder: (_)=>Countries(blocContext,BlocProvider.of<RegisterBloc>(blocContext).countries))).then((value) {
      setState(() {});
      if (BlocProvider.of<RegisterBloc>(blocContext).selectedCountry != null &&
          countryModel != BlocProvider.of<RegisterBloc>(blocContext).selectedCountry) {
        BlocProvider.of<RegisterBloc>(blocContext).selectedCity = null;
        BlocProvider.of<RegisterBloc>(blocContext).selectedArea = null;
        BlocProvider.of<RegisterBloc>(blocContext).add(FetchCitiesEvent(
            countryId: BlocProvider.of<RegisterBloc>(blocContext).selectedCountry.id));
      }
      return null;
    });
  }

  showCities(BuildContext context) async {
    final blocContext = context;
    StateModel stateModel = BlocProvider.of<RegisterBloc>(blocContext).selectedCity;
    await Navigator.push(context,MaterialPageRoute(builder: (_)=>CitiesSearch(blocContext,BlocProvider.of<RegisterBloc>(blocContext).cities))).then((value) {
      setState(() {});
      if (BlocProvider.of<RegisterBloc>(blocContext).selectedCity != null &&
              stateModel != BlocProvider.of<RegisterBloc>(blocContext).selectedCity) {
        BlocProvider.of<RegisterBloc>(blocContext).selectedArea = null;
        BlocProvider.of<RegisterBloc>(blocContext).add(FetchAreasEvent(cityId: BlocProvider.of<RegisterBloc>(blocContext).selectedCity.id));
      }
      return null;
    });
  }
  showAreas(BuildContext context) async {
    final blocContext = context;
    await Navigator.push(context,MaterialPageRoute(builder: (_)=>AreaSearch(blocContext,BlocProvider.of<RegisterBloc>(blocContext).areas))).then((value) {
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
        value: BlocProvider.of<RegisterBloc>(context),
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
                        widget.searchCountries = BlocProvider.of<RegisterBloc>(widget.blocContext).countries.where((element) {

                          return element.name.toLowerCase().contains(v.toLowerCase());
                        }).toList();
                        // BlocProvider.of<RegisterBloc>(blocContext).add(ChangeSearchReceiverAddressEvent());
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
                  BlocBuilder<RegisterBloc,RegisterStates>(
                    builder: (context, state) {
                      print('AddReceiverAddressStates');
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:widget.searchCountries.length,
                        itemBuilder: (context, index) => MaterialButton(
                          onPressed: () {
                            BlocProvider.of<RegisterBloc>(widget.blocContext).selectedCountry = widget.searchCountries[index];
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
                                if (BlocProvider.of<RegisterBloc>(widget.blocContext).selectedCountry != null &&
                                        BlocProvider.of<RegisterBloc>(widget.blocContext).selectedCountry ==
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
        value: BlocProvider.of<RegisterBloc>(context),
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
                        widget.searchCitiesSearch = BlocProvider.of<RegisterBloc>(widget.blocContext).cities.where((element) {

                          return element.name.toLowerCase().contains(v.toLowerCase());
                        }).toList();
                        // BlocProvider.of<RegisterBloc>(blocContext).add(ChangeSearchReceiverAddressEvent());
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
                  BlocBuilder<RegisterBloc,RegisterStates>(
                    builder: (context, state) {
                      print('AddReceiverAddressStates');
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:widget.searchCitiesSearch.length,
                        itemBuilder: (context, index) => MaterialButton(
                          onPressed: () {
                            BlocProvider.of<RegisterBloc>(widget.blocContext).selectedCity = widget.searchCitiesSearch[index];
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
                                if (BlocProvider.of<RegisterBloc>(widget.blocContext).selectedCity != null &&
                                        BlocProvider.of<RegisterBloc>(widget.blocContext).selectedCity ==
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
        value: BlocProvider.of<RegisterBloc>(context),
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
                        widget.searchAreaSearch = BlocProvider.of<RegisterBloc>(widget.blocContext).areas.where((element) {

                          return element.name.toLowerCase().contains(v.toLowerCase());
                        }).toList();
                        // BlocProvider.of<RegisterBloc>(blocContext).add(ChangeSearchReceiverAddressEvent());
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
                  BlocBuilder<RegisterBloc,RegisterStates>(
                    builder: (context, state) {
                      print('AddReceiverAddressStates');
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:widget.searchAreaSearch.length,
                        itemBuilder: (context, index) => MaterialButton(
                          onPressed: () {
                            BlocProvider.of<RegisterBloc>(widget.blocContext).selectedArea = widget.searchAreaSearch[index];
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
                                if (BlocProvider.of<RegisterBloc>(widget.blocContext).selectedArea != null &&
                                        BlocProvider.of<RegisterBloc>(widget.blocContext).selectedArea ==
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
