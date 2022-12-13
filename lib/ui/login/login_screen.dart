import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/components/main_button.dart';
import 'package:wepostexpresscustomer/components/my_svg.dart';
import 'package:wepostexpresscustomer/ui/config_loader/bloc/config_loader_bloc.dart';
import 'package:wepostexpresscustomer/ui/config_loader/config_loader_screen.dart';
import 'package:wepostexpresscustomer/ui/home/home_screen.dart';
import 'package:wepostexpresscustomer/ui/login/bloc/login_bloc.dart';
import 'package:wepostexpresscustomer/ui/login/bloc/login_events.dart';
import 'package:wepostexpresscustomer/ui/login/bloc/login_states.dart';
import 'package:wepostexpresscustomer/ui/register/register_screen.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => di<LoginBloc>()..add(FetchLoginEvent()),
      child: BlocListener<LoginBloc, LoginStates>(
        listener: (BuildContext context, LoginStates state) async {
          if (state is ErrorLoginState) {
            print('asdasdasd');
            showToast(state.error, false);
          }
          if (state is LoggedInSuccessfully) {
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>HomeScreen(false)));
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Builder(
              builder: (context) => SizedBox.expand(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (6.4 / 100),
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: MySVG(
                                    size: MediaQuery.of(context).size.height * (11 / 100),
                                    imagePath: 'assets/images/logo.png',
                            fromFiles: true,
                                  ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (8.9 / 100),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: TextFormField(
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
                                  controller: emailController,
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
                                height: MediaQuery.of(context).size.height * (3.9 / 100),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Text(
                                  tr(LocalKeys.password),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              BlocBuilder<LoginBloc, LoginStates>(
                                builder: (context, state) =>  Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                  child: TextFormField(
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return tr(LocalKeys.this_field_cant_be_empty);
                                      } else {
                                        return null;
                                      }
                                    },
                                      keyboardType: TextInputType.visiblePassword,
                                    obscureText: !BlocProvider.of<LoginBloc>(context).showPassword,
                                      controller: passwordController,
                                    decoration: InputDecoration(
                                      hintText: tr(LocalKeys.password),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          BlocProvider.of<LoginBloc>(context).showPassword = !BlocProvider.of<LoginBloc>(context).showPassword;
                                          BlocProvider.of<LoginBloc>(context).add(PasswordToggleChangedLoginEvent());
                                        },
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: BlocProvider.of<LoginBloc>(context).showPassword  ? Colors.blue : Colors.grey,
                                        ),
                                        ),
                                      hintStyle: TextStyle(fontSize: 11),
                                      focusedBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                          borderSide: BorderSide(color: Colors.black, width: 2)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (4.1 / 100),
                              ),
                              BlocBuilder<LoginBloc, LoginStates>(
                                builder: (context, state) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                  child: MainButton(
                                      isLoading: state is LoadingLoginState,
                                    borderColor: rgboOrHex(
                                        Config.get.styling[Config.get.themeMode].secondaryVariant),
                                    borderRadius: 0,
                                    onPressed: () {
                                      formKey.currentState.save();
                                      if (formKey.currentState.validate()) {
                                        BlocProvider.of<LoginBloc>(context).add(
                                          SubmitLoginEvent(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                                    text: tr(LocalKeys.login),
                                    textColor: rgboOrHex(
                                        Config.get.styling[Config.get.themeMode].buttonTextColor),
                                    color: rgboOrHex(Config
                                        .get.styling[Config.get.themeMode].primary),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (4.1 / 100),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: MainButton(
                                  borderColor: rgboOrHex(
                                      Config.get.styling[Config.get.themeMode].secondaryVariant),
                                  borderRadius: 0.5,
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen(true))).then((value) {
                                    if(value == true){
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                                    }
                                    });
                                  },
                                  text: tr(LocalKeys.login_as_a_guest),
                                  textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                                  color: rgboOrHex(Config
                                      .get.styling[Config.get.themeMode].scaffoldBackgroundColor),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (4.1 / 100),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  tr(tr(LocalKeys.forget_password)),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                        color: rgboOrHex(Config.get.styling[Config.get.themeMode]
                                            .primary),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (4.1 / 100),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(text: tr(LocalKeys.do_not_have_an_account)),
                                      TextSpan(
                                        text: ' '+tr(LocalKeys.sign_up),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
                                        style: TextStyle(
                                          color: rgboOrHex(Config.get.styling[Config.get.themeMode]
                                              .primary),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                    height: MediaQuery.of(context).size.height * (2.5 / 100),
                                ),
                              Container(
                                    height: MediaQuery.of(context).size.height * (19 / 100),
                                    width: double.infinity,
                                    child: Stack(
                                        children: [
                                            Image.asset(
                                                'assets/icons/login_bg.png',
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                            ),
                                        ],
                                    ),
                                ),
                            ],
                          ),
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
