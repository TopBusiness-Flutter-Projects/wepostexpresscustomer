import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/components/my_svg.dart';
import 'package:wepostexpresscustomer/models/user/user_model.dart';
import 'package:wepostexpresscustomer/ui/config_loader/config_loader_screen.dart';
import 'package:wepostexpresscustomer/ui/home/home_screen.dart';
import 'package:wepostexpresscustomer/ui/login/login_screen.dart';
import 'package:wepostexpresscustomer/ui/onboard/onboard_screen.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_bloc.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_events.dart';
import 'package:wepostexpresscustomer/ui/splash/bloc/splash_states.dart';
import 'package:wepostexpresscustomer/utils/cache/cache_helper.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/app_keys.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:wepostexpresscustomer/utils/global/global_bloc.dart';
import 'package:wepostexpresscustomer/utils/global/global_states.dart';
import 'package:wepostexpresscustomer/utils/network/repository.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Config.get');
    print(Config.get);
    return BlocProvider<SplashBloc>(
      create: (BuildContext context) => di<SplashBloc>()..add(FetchSplashEvent()),
      child: BlocListener<SplashBloc, SplashStates>(
        listener: (BuildContext context, SplashStates state) async {
          if (state is ErrorSplashState) {
            showToast(state.error, false);
          }
          if (state is NavigateToConfigLoader) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ConfigLoaderScreen()));
          }
          if (state is SuccessSplashState) {
            Timer(Duration(seconds: 1), () async {
              final userData = await di<CacheHelper>().get(AppKeys.userData);
              if (userData != null ) {
                di<Repository>().user = UserModel.fromJson(userData);
                // print('userData');
                // print(di<Repository>().user);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(false)));
              } else {
                final onOnBoardOpened = await di<CacheHelper>().get(AppKeys.onOnBoardOpened);
                if (onOnBoardOpened != null &&onOnBoardOpened ) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                } else {
                  di<CacheHelper>().put(AppKeys.onOnBoardOpened,true);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => OnBoardScreen()));
                }
              }

            });
          }
        },
        child: Scaffold(
          backgroundColor:
              rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: MySVG(
                    svgPath: 'assets/icons/splash_background.svg',
                  )),
                  Spacer(),
                ],
              ),
              BlocBuilder<GlobalBloc, GlobalStates>(
                builder: (context, state) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: MySVG(
                                    size: MediaQuery.of(context).size.height * (11 / 100),
                                    imagePath: 'assets/images/logo.png',
                            fromFiles: true,
                                  ),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
