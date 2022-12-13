import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/components/main_button.dart';
import 'package:wepostexpresscustomer/components/my_svg.dart';
import 'package:wepostexpresscustomer/ui/login/login_screen.dart';
import 'package:wepostexpresscustomer/ui/register/bloc/register_bloc.dart';
import 'package:wepostexpresscustomer/ui/register/bloc/register_events.dart';
import 'package:wepostexpresscustomer/ui/register/bloc/register_states.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';

class RegisteredSuccessfullyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (BuildContext context) => di<RegisterBloc>()..add(FetchRegisterEvent()),
      child: BlocListener<RegisterBloc, RegisterStates>(
        listener: (BuildContext context, RegisterStates state) async {
          if (state is ErrorRegisterState) {
            showToast(state.error, false);
          }
        },
        child: Scaffold(
          body: SafeArea(
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
                          child: Center(
                            child: Text(
                              tr(LocalKeys.createAccount),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * (3.8 / 100),
                    ),
                    BlocConsumer<RegisterBloc, RegisterStates>(
                      listener: (context, state) => null,
                      builder: (context, state) => LinearProgressIndicator(
                        value: 1,
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
                      child: Container(
                          width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              Container(
                                  height: MediaQuery.of(context).size.height * (17 / 100),
                                  child: MySVG(
                                      svgPath: 'assets/icons/success_register.svg',
                                  ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height * (3.9 / 100),
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                              TextSpan(text: tr(LocalKeys.your_account_created_successfully)),
                                              TextSpan(
                                                  text: '\n' + tr(LocalKeys.panda_account),
                                                  style: TextStyle(
                                                      // color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                                      fontWeight: FontWeight.bold,
                                                  ),
                                              ),
                                          ],
                                      ),
                                  ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height * (2.9 / 100),
                              ),
                              MainButton(
                              isFullWidth: true,
                              horizontalPadding: 20,
                              borderColor: rgboOrHex(
                                  Config.get.styling[Config.get.themeMode].secondaryVariant),
                              borderRadius: 0,
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginScreen()));
                              },
                              text: tr(LocalKeys.login_now),
                              textColor:
                                  rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                              color: rgboOrHex(
                                  Config.get.styling[Config.get.themeMode].primary),
                            ),
                          ],
                        ),
                      ),
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
