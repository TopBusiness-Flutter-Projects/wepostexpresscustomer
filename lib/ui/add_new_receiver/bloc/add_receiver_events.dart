import 'package:flutter/foundation.dart';
import 'package:wepostexpresscustomer/models/user/user_model.dart';

@immutable
abstract class AddReceiverEvents
{
  const AddReceiverEvents();
}

class SubmitAddReceiverEvent extends AddReceiverEvents {
  final UserModel userModel;
  SubmitAddReceiverEvent({
    @required this.userModel,
});
}
class FetchAddReceiverEvent extends AddReceiverEvents {}
class NextAddReceiverEvent extends AddReceiverEvents {}
class ChangeAddReceiverEvent extends AddReceiverEvents {}
class ChangeBackwardEvent extends AddReceiverEvents {}

class FetchCitiesAddReceiverEvent extends AddReceiverEvents {
  final String countryId ;
  FetchCitiesAddReceiverEvent({
    @required this.countryId,
  });
}

class FetchAreasAddReceiverEvent extends AddReceiverEvents {
  final String cityId ;
  FetchAreasAddReceiverEvent({
    @required this.cityId,
  });
}
