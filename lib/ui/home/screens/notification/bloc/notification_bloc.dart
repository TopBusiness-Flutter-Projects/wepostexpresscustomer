import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/models/notification_model.dart';
import 'package:wepostexpresscustomer/models/shipment_model.dart';
import 'package:wepostexpresscustomer/ui/home/bloc/home_events.dart';
import 'package:wepostexpresscustomer/ui/home/bloc/home_states.dart';
import 'package:wepostexpresscustomer/ui/home/screens/notification/bloc/notification_states.dart';
import 'package:wepostexpresscustomer/ui/login/bloc/login_events.dart';
import 'package:wepostexpresscustomer/ui/login/bloc/login_states.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpresscustomer/utils/network/repository.dart';

import 'notification_events.dart';

class NotificationBloc extends Bloc<NotificationEvents, NotificationStates> {
  final Repository _repository;
  List<NotificationModel> notifications=[];
  bool errorOccurred= true ;


  NotificationBloc(this._repository) : super(InitialNotificationState());

  static NotificationBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<NotificationStates> mapEventToState(NotificationEvents event) async*
  {
    if (event is FetchNotificationEvent) {
      errorOccurred = false;
      yield LoadingNotificationState();

      final no =await  _repository.getNotifications();
      yield* no.fold((l) async*{
        errorOccurred = true;
        yield ErrorNotificationState(l);
      }, (r) async*{
        notifications = r;
        print(r.length);
        yield SuccessNotificationState();
      });
    }
  }
}
