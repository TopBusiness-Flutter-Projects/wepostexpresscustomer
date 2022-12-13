import 'package:flutter/foundation.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:wepostexpresscustomer/models/user/user_model.dart';

@immutable
abstract class RegisterEvents
{
  const RegisterEvents();
}

class SubmitRegisterEvent extends RegisterEvents {
  final UserModel userModel;
  final String addressName;
  final PickResult pickResult;
  SubmitRegisterEvent({
    @required this.userModel,
    @required this.addressName,
    @required this.pickResult,
});
}
class FetchRegisterEvent extends RegisterEvents {}
class NextRegisterEvent extends RegisterEvents {}
class PasswordToggleChangedRegisterEvent extends RegisterEvents {}
class ChangeEvent extends RegisterEvents {}
class ChangeBackwardEvent extends RegisterEvents {}

class FetchCitiesEvent extends RegisterEvents {
  final String countryId ;
  FetchCitiesEvent({
    @required this.countryId,
  });
}

class FetchAreasEvent extends RegisterEvents {
  final String cityId ;
  FetchAreasEvent({
    @required this.cityId,
  });
}
