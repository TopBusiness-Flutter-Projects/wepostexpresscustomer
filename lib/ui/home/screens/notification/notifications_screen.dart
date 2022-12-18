import 'dart:ffi';

import 'package:wepostexpresscustomer/components/empty_content.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wepostexpresscustomer/components/my_svg.dart';
import 'package:wepostexpresscustomer/components/step_tracker.dart';
import 'package:wepostexpresscustomer/ui/home/screens/notification/bloc/notification_events.dart';
import 'package:wepostexpresscustomer/ui/home/screens/notification/bloc/notification_states.dart';
import 'package:wepostexpresscustomer/ui/shipment_details/shipment_details_screen.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:wepostexpresscustomer/utils/global/global_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bloc/notification_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd hh:mm');
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (BuildContext context) => di<NotificationBloc>()..add(FetchNotificationEvent()),
      child: BlocListener<NotificationBloc, NotificationStates>(
        listener: (BuildContext context, NotificationStates state) async {
          if (state is ErrorNotificationState) {
            showToast(state.error, false);
          }
        },
        child:  Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * (15.67 / 100)),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.zero,
                color: rgboOrHex(Config.get.styling[Config.get.themeMode].background),
                alignment: Alignment.topCenter,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/notifications_bg.svg',
                      fit: BoxFit.cover,
                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].background),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
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
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<NotificationBloc,NotificationStates>(
                  builder:(context, state) =>  ConditionalBuilder(
                    condition: state is !LoadingNotificationState,
                    builder: (context) =>  Container(
                      color: Color(0xffF7F7FB),
                      child: buildNotification(context),
                    ),
                    fallback: (context) => Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
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

  Widget buildNotification(BuildContext blocContext) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: (){
        BlocProvider.of<NotificationBloc>(blocContext).add(FetchNotificationEvent());
        _refreshController.loadComplete();
      },
      child: ConditionalBuilder(
        condition: BlocProvider.of<NotificationBloc>(blocContext).notifications.length>0,
        builder: (context) =>  Column(
          children: [
            if(BlocProvider.of<NotificationBloc>(context).errorOccurred)
              Container(
                color: Colors.redAccent,
                padding:
                EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        tr(LocalKeys.server_error),
                        style: TextStyle(
                          color: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 100,
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width* 0.02,vertical: MediaQuery.of(context).size.height* 0.01),
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: () {
                          BlocProvider.of<NotificationBloc>(context).add(FetchNotificationEvent());
                        },
                        child: Text(
                          tr(LocalKeys.retry),
                          style: TextStyle(
                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: BlocProvider.of<NotificationBloc>(blocContext).notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 10,
                    shadowColor: Color(0xffF7F7FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (4.2 / 100),
                        vertical: MediaQuery.of(context).size.height * (2.4 / 100)),
                    clipBehavior:Clip.antiAlias ,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (_)=> ShipmentDetailsScreen(null,code: BlocProvider.of<NotificationBloc>(blocContext).notifications[index].code,)));
                      },
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * (4.2 / 100),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * (1.4 / 100),
                                    ),
                                    Text(
                                      BlocProvider.of<NotificationBloc>(blocContext).notifications[index].code??'',
                                      style: TextStyle(
                                        color: rgboOrHex(
                                            Config.get.styling[Config.get.themeMode].primary),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * (1.4 / 100),
                                    ),
                                    Text(
                                      BlocProvider.of<NotificationBloc>(blocContext).notifications[index].created_at!=null?
                                      dateFormat.format(dateFormat.parse(BlocProvider.of<NotificationBloc>(blocContext).notifications[index].created_at))
                                      :'',
                                      style: TextStyle(
                                        color: rgboOrHex(
                                            Config.get.styling[Config.get.themeMode].primary),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.height * (1.4 / 100),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * (2.6 / 100),
                                  vertical: MediaQuery.of(context).size.height * (0.80 / 100),
                                ),
                                child: Icon(Icons.notifications,color: Colors.white,),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).size.height * (1.2 / 100)) ,
                          ),
                         Container(
                           height: 0.5,
                           width: double.infinity,
                           color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                           margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (4.2 / 100)),
                         ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * (4.2 / 100),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * (4.2 / 100),
                              ),
                              Expanded(
                                child: Text(
                                  BlocProvider.of<NotificationBloc>(blocContext).notifications[index].content,
                                  maxLines: null,
                                  style: TextStyle(
                                    // color: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * (4.2 / 100),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        fallback: (context) => EmptyContent(
          svgIconPath: 'assets/icons/empty.svg',
          message: tr(LocalKeys.noDataFound),

        ),
      ),
    );
  }
}
