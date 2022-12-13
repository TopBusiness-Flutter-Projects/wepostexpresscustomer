import 'package:after_layout/after_layout.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wepostexpresscustomer/components/main_button.dart';
import 'package:wepostexpresscustomer/ui/login/login_screen.dart';
import 'package:wepostexpresscustomer/utils/cache/cache_helper.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/app_keys.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:wepostexpresscustomer/utils/theme/theme_bloc.dart';
import 'package:wepostexpresscustomer/utils/theme/theme_states.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoardScreen> with AfterLayoutMixin {
  var isLast = false;
  final controller = PageController();
  final List<String> images = [
    "assets/icons/splash_1.svg",
    "assets/icons/splash_2.svg",
    "assets/icons/splash_3.svg"
  ];

  final List<String> titles = [
    LocalKeys.splash_title_1,
    LocalKeys.splash_title_2,
    LocalKeys.splash_title_3,
  ];

  final List<String> subtitles = [
    LocalKeys.splash_content_1,
    LocalKeys.splash_content_2,
    LocalKeys.splash_content_3,
  ];

  @override
  void initState() {
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (BuildContext context) => di<ThemeBloc>(),
      child: BlocListener<ThemeBloc, ThemeStates>(
        listener: (BuildContext context, state) {},
        child: SafeArea(
          child: Scaffold(
            body: Builder(
              builder: (context) => SizedBox.expand(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (1.8 / 100)),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (60 / 100),
                      child: PageView.builder(
                        onPageChanged: (i) {
                          if (i == (images.length - 1) && !isLast)
                            setState(() => isLast = true);
                          else if (isLast) setState(() => isLast = false);
                        },
                        controller: controller,
                        itemCount: images.length,
                        itemBuilder: (ctx, i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: toPx(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: MediaQuery.of(context).size.height * (1 / 100)),
                              SvgPicture.asset(
                                images[i],
                                height: MediaQuery.of(context).size.height * (43 / 100),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * (4.31 / 100)),
                              Text(
                                tr(titles[i]),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * (1 / 100)),
                              Text(
                                tr(subtitles[i]),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Theme.of(context).colorScheme.secondaryVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (3 / 100),
                    ),
                    DotsIndicator(
                        dotsCount: images.length,
                        position: controller?.positions?.isNotEmpty == true ? controller?.page : 0,
                        decorator: DotsDecorator(
                            color: rgboOrHex(
                                Config.get.styling[Config.get.themeMode].secondaryVariant),
                            activeSize: Size(25.0, toPx(2)),
                            size: Size(8.0, toPx(2)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            activeShape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            activeColor: rgboOrHex(
                                Config.get.styling[Config.get.themeMode].primary))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (6 / 100),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: toPx(15)),
                      child: MainButton(
                        borderRadius: 0,
                        onPressed: () {
                          if (controller.page == 2) {
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>LoginScreen()));
                          }else{
                            controller.nextPage(duration: Duration(milliseconds: 100), curve: Curves.ease);
                          }
                        },
                        text: isLast? tr(LocalKeys.register): tr(LocalKeys.next),
                        textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                        color: rgboOrHex( Config.get.styling[Config.get.themeMode].primary),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (1.6 / 100)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: toPx(15)),
                      child: MainButton(
                        borderColor: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                        borderRadius: 0.5,
                        onPressed: () {
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>LoginScreen()));
                        },
                        text: tr(LocalKeys.skip),
                        textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].scaffoldBackgroundColor),
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

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
  }
}
