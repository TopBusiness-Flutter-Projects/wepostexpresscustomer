import 'package:flutter/foundation.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:wepostexpresscustomer/models/user/user_model.dart';

@immutable
abstract class AddAddressEvents
{
  const AddAddressEvents();
}

class SubmitAddAddressEvent extends AddAddressEvents {
  final UserModel userModel;
  final PickResult pickResult;

  SubmitAddAddressEvent({
    @required this.userModel,
    @required this.pickResult,
});
}
class FetchAddAddressEvent extends AddAddressEvents {}
class NextAddAddressEvent extends AddAddressEvents {}
class ChangeAddAddressEvent extends AddAddressEvents {}
class ChangeBackwardEvent extends AddAddressEvents {}

class FetchCitiesAddAddressEvent extends AddAddressEvents {
  final String countryId ;
  FetchCitiesAddAddressEvent({
    @required this.countryId,
  });
}

class FetchAreasAddAddressEvent extends AddAddressEvents {
  final String cityId ;
  FetchAreasAddAddressEvent({
    @required this.cityId,
  });
}
