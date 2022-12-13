import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/ui/config_loader/bloc/config_loader_events.dart';
import 'package:wepostexpresscustomer/ui/config_loader/bloc/config_loader_states.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpresscustomer/utils/cache/cache_helper.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/app_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:wepostexpresscustomer/utils/network/repository.dart';

class ConfigLoaderBloc extends Bloc<ConfigLoaderEvents, ConfigLoaderStates> {
  final Repository _repository;


  ConfigLoaderBloc(this._repository) : super(InitialConfigLoaderState());

  static ConfigLoaderBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<ConfigLoaderStates> mapEventToState(ConfigLoaderEvents event) async*
  {
    if (event is FetchConfigLoaderEvent) {
      yield LoadingConfigLoaderState();
    }

    if (event is FetchedConfigLoaderEvent) {
      // final path = await di<CacheHelper>().get(AppKeys.APP_LOGO_PATH) ;
      // print('dasdsadadasdsadadasdsada');
      // print(path);
      // if(path==null){
      //   await _repository.downloadImage(url: Config.get.logo.dark);
      // }
      yield SuccessConfigLoaderState();
    }
  }


}
