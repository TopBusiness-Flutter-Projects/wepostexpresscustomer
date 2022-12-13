import 'package:flutter/foundation.dart';

@immutable
abstract class HomeEvents
{
  const HomeEvents();
}

class FetchHomeEvent extends HomeEvents {
  bool forFirstTime = false ;
  FetchHomeEvent({
    @required this.forFirstTime,
});
}
class FetchUserWalletEvent extends HomeEvents {}
class FetchMoreHomeEvent extends HomeEvents {}
class FetchMoreMissionsHomeEvent extends HomeEvents {}
class HomePageChangedEvent extends HomeEvents {}
class LogoutHomeEvent extends HomeEvents {}