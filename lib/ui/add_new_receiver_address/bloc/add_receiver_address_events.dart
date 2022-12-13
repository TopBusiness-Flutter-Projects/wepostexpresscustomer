import 'package:flutter/foundation.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:wepostexpresscustomer/models/user/user_model.dart';

@immutable
abstract class AddReceiverAddressEvents
{
  const AddReceiverAddressEvents();
}

class SubmitAddReceiverAddressEvent extends AddReceiverAddressEvents {
  final UserModel userModel;
  final PickResult pickResult;

  SubmitAddReceiverAddressEvent({
    @required this.userModel,
    @required this.pickResult,
});
}
class FetchAddReceiverAddressEvent extends AddReceiverAddressEvents {}
class NextAddReceiverAddressEvent extends AddReceiverAddressEvents {}
class ChangeAddReceiverAddressEvent extends AddReceiverAddressEvents {}
class ChangeSearchReceiverAddressEvent extends AddReceiverAddressEvents {}
class ChangeBackwardEvent extends AddReceiverAddressEvents {}

class FetchCitiesAddReceiverAddressEvent extends AddReceiverAddressEvents {
  final String countryId ;
  FetchCitiesAddReceiverAddressEvent({
    @required this.countryId,
  });
}

class FetchAreasAddReceiverAddressEvent extends AddReceiverAddressEvents {
  final String cityId ;
  FetchAreasAddReceiverAddressEvent({
    @required this.cityId,
  });
}
