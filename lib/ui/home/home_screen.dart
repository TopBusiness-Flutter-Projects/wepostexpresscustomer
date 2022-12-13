import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/components/main_button.dart';
import 'package:wepostexpresscustomer/components/my_svg.dart';
import 'package:wepostexpresscustomer/ui/home/bloc/home_bloc.dart';
import 'package:wepostexpresscustomer/ui/home/bloc/home_events.dart';
import 'package:wepostexpresscustomer/ui/home/bloc/home_states.dart';
import 'package:wepostexpresscustomer/ui/home/screens/notification/notifications_screen.dart';
import 'package:wepostexpresscustomer/ui/home/screens/profile/profile_screen.dart';
import 'package:wepostexpresscustomer/ui/home/screens/single_home/single_home_screen.dart';
import 'package:wepostexpresscustomer/ui/login/bloc/login_bloc.dart';
import 'package:wepostexpresscustomer/ui/login/bloc/login_events.dart';
import 'package:wepostexpresscustomer/ui/login/bloc/login_states.dart';
import 'package:wepostexpresscustomer/ui/register/register_screen.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:wepostexpresscustomer/utils/global/global_bloc.dart';
import 'package:wepostexpresscustomer/utils/global/global_states.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest ;

  HomeScreen(this.isGuest);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
@override
  void initState() {
  FirebaseMessaging.onMessage.listen((message) {
    showFlash(
      context: context,
      duration: Duration(seconds: 5),
      builder: (context, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.transparent,
          barrierBlur: 3.0,
          barrierDismissible: false,
          position: FlashPosition.top,
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          onTap: () {
            if(message != null && message.data !=null){
              

            }
          },
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                        color: Color(0x3f06112a),
                        offset: Offset(0, 12),
                        blurRadius: 32,
                        spreadRadius: -5),
                BoxShadow(
                        color: Color(0x3f06112a),
                        offset: Offset(0, 0),
                        blurRadius: 1,
                        spreadRadius: 0)
              ],
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Image.asset('assets/images/app_icon.png'),
              SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: message.notification.body,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () => controller.dismiss(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                height: 0,
                minWidth: 0,
                elevation: 0,
                highlightElevation: 0,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary).withOpacity(0.1),
                child: Text(tr(LocalKeys.dismiss), style: TextStyle(fontSize: 12)),
              ),
            ],
            ),
          ),
        );
      },
    );
  });

  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) {
        BlocProvider.of<GlobalBloc>(context).checkConnectivity();
        return widget.isGuest ?di<HomeBloc>():(di<HomeBloc>()..add(FetchHomeEvent(forFirstTime: true)));
      },
      child: BlocListener<GlobalBloc,GlobalStates>(
        listener: (c, state) {

          if(state is ConnectionChangedGlobalState){
            print(state.isOnline);
            if(state.isOnline){
              if(BlocProvider.of<GlobalBloc>(context).popupOpened){
              Navigator.pop(context);
              BlocProvider.of<GlobalBloc>(context).popupOpened= false;
              }
            }else{
              if(!BlocProvider.of<GlobalBloc>(context).popupOpened){
                BlocProvider.of<GlobalBloc>(context).popupOpened= true;
                return showConnectionDialog(c);
              }
            }
          }
        } ,
        child:  BlocListener<HomeBloc, HomeStates>(
          listener: (BuildContext context, HomeStates state) async {
            if (state is ErrorHomeState) {
              showToast(state.error, false);
            }
          },
          child: Scaffold(
            bottomNavigationBar: widget.isGuest ?Container(
              height: 60,
              color: Colors.black12,
              child: InkWell(
                onTap: () => print('tap on close'),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.home_outlined,
                        color: Theme.of(context).accentColor,
                      ),
                      Text(tr(LocalKeys.home),
                        style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),),
                    ],
                  ),
                ),
              ),
        ):BlocBuilder<HomeBloc,HomeStates>(
              builder: (context, state) => BottomNavigationBar(
                onTap: (index) {
                  BlocProvider.of<HomeBloc>(context).currentIndex = index;
                  pageController.animateToPage(index, duration: Duration(milliseconds: 10), curve: Curves.bounceIn);
                  BlocProvider.of<HomeBloc>(context).add(HomePageChangedEvent());
                },
                currentIndex: BlocProvider.of<HomeBloc>(context).currentIndex,
                items: [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: tr(LocalKeys.home)),
                BottomNavigationBarItem(icon: Icon(Icons.notifications),label: tr(LocalKeys.notifications)),
                BottomNavigationBarItem(icon: Icon(Icons.account_box_rounded),label: tr(LocalKeys.profile)),
              ],
              ),
            ),
            body: SafeArea(
              child: Builder(
                builder: (context) => BlocBuilder<HomeBloc,HomeStates>(
                  builder: (context, state) => PageView(
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    allowImplicitScrolling: false,
                    onPageChanged: (index){
                    },
                    children: [
                      HomeSingleScreen(widget.isGuest),
                      if(!widget.isGuest)
                        NotificationsScreen(),
                      if(!widget.isGuest)
                        ProfileScreen(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showConnectionDialog(BuildContext context) async {
    final blocContext = context;
    return await showMaterialModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
            return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max, children: <Widget>[
                        Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                          MySVG(
                            size: 11,
                            imagePath: 'assets/images/logo.png',
                            fromFiles: true,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.50,
                            child: MySVG(
                              size: 11,
                              svgPath: 'assets/icons/no-internet.svg',
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Text(
                            tr(LocalKeys.noConnection),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.10),
                            child: MainButton(onPressed: (){
                              BlocProvider.of<GlobalBloc>(context).checkConnectivity();
                            }, text: tr(LocalKeys.refresh), color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary), textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor)),
                          )
                        ],
                        ),
                        // SizedBox(height: 82.7 * 1.5),
                      ]),
                    )
            ),
          ),
        ),
      ),
    ).then((value) {
      BlocProvider.of<GlobalBloc>(context).popupOpened= false;
      return null;
    });
  }
}
