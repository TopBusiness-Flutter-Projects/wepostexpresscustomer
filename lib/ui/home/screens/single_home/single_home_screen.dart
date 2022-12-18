import 'package:wepostexpresscustomer/components/empty_content.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wepostexpresscustomer/components/main_button.dart';
import 'package:wepostexpresscustomer/components/my_svg.dart';
import 'package:wepostexpresscustomer/components/qr_code.dart';
import 'package:wepostexpresscustomer/components/step_tracker.dart';
import 'package:wepostexpresscustomer/ui/create_mission/create_mission_screen.dart';
import 'package:wepostexpresscustomer/ui/home/bloc/home_bloc.dart';
import 'package:wepostexpresscustomer/ui/home/bloc/home_events.dart';
import 'package:wepostexpresscustomer/ui/home/bloc/home_states.dart';
import 'package:wepostexpresscustomer/ui/mission_shipments/mission_shipments_screen.dart';
import 'package:wepostexpresscustomer/ui/new_order/new_order_screen.dart';
import 'package:wepostexpresscustomer/ui/search/search_screen.dart';
import 'package:wepostexpresscustomer/ui/shipment_details/shipment_details_screen.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/app_keys.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/global/global_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeSingleScreen extends StatefulWidget {
  final bool isGuest ;
  HomeSingleScreen(this.isGuest);

  @override
  _HomeSingleScreenState createState() => _HomeSingleScreenState();
}

class _HomeSingleScreenState extends State<HomeSingleScreen> {
  ScrollController scrollControllerShipments = ScrollController(keepScrollOffset: true);
  bool gettingData = false;
  bool isLastValue = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    scrollControllerShipments.addListener(() {
      double maxHeight = scrollControllerShipments.position.maxScrollExtent;
      double currentScroll = scrollControllerShipments.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxHeight - currentScroll <= delta) {
        if (!gettingData && !isLastValue) {
          print(BlocProvider.of<HomeBloc>(context).currentIndex);
          // getMoreChatsList(context: context);
          if(BlocProvider.of<HomeBloc>(context).shipmentResponseModel != null &&int.parse(BlocProvider.of<HomeBloc>(context).shipmentResponseModel.last_page) > BlocProvider.of<HomeBloc>(context).shipmentPages)
          {
          BlocProvider.of<HomeBloc>(context).add(FetchMoreHomeEvent());
          }
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Container(
                height: (MediaQuery.of(context).size.height * (47.0 / 100)) -
                    (MediaQuery.of(context).size.height * (3.0 / 100)),
                color: rgboOrHex(Config.get.styling[Config.get.themeMode].background),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                              color: rgboOrHex(Config.get.styling[Config.get.themeMode].background).withOpacity(0.1),

                            // svgPath: 'assets/icons/splash_background.svg',
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(widget.isGuest)
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context,true);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(tr(LocalKeys.register),style: TextStyle(
                                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(tr(LocalKeys.login),style: TextStyle(
                                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (5.3 / 100)),
                                decoration: BoxDecoration(
                                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary).withOpacity(0.1),
                                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        maxLines: 1,
                                        readOnly: true,
                                        textAlign: TextAlign.start,
                                        onTap: (){
                                          Navigator.push(context,MaterialPageRoute(builder: (_)=>SearchScreen(code: null,)));
                                        },
                                        decoration: InputDecoration(
                                          hintText: tr(LocalKeys.your_tracking_id),
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary)),
                                          border: InputBorder.none,
                                          prefixIcon: SizedBox(
                                            width: MediaQuery.of(context).size.height * (1.72 / 100),
                                            height: MediaQuery.of(context).size.height * (1.72 / 100),
                                            child: Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: SvgPicture.asset('assets/icons/search1.svg',
                                                  color: rgboOrHex(Config
                                                          .get.styling[Config.get.themeMode].secondary)
                                                      .withOpacity(0.5)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: InkWell(
                                        onTap: ()async{
                                          FocusScopeNode currentFocus = FocusScope.of(context);

                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          Navigator.push(context,MaterialPageRoute(builder: (_)=>QRViewExample())).then((value) {
                                            print('barcode value');
                                            print(value);
                                            if(value !=null){
                                              Navigator.push(context,MaterialPageRoute(builder: (_)=>SearchScreen(code: value,)));
                                            }
                                            return null;
                                          });
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.height * (5.72 / 100),
                                          height: MediaQuery.of(context).size.height * (5.72 / 100),
                                          child: Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: SvgPicture.asset(
                                              'assets/icons/scan1.svg',
                                              color: rgboOrHex(Config.get.styling[Config.get.themeMode]
                                                      .primary),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if(!widget.isGuest)
                                SizedBox(
                                height: MediaQuery.of(context).size.height * (3.0 / 100),
                              ),
                              if(!widget.isGuest)
                                Container(
                                width: double.infinity,

                                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (5.3 / 100)),
                                child: MainButton(
                                  borderRadius: 0,
                                  onPressed: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (_)=> CreateMissionScreen())).then((value) {
                                      BlocProvider.of<HomeBloc>(context).add(FetchHomeEvent(forFirstTime: false));
                                      return null;
                                    });
                                  },
                                  text: tr(LocalKeys.create_mission),
                                  textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary).withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          body:  widget.isGuest?Container(): Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].background),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.height * (4.26 / 100),
                            ),
                            Expanded(
                              child: TabBar(
                                isScrollable: true,
                                indicatorColor: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),

                                tabs: [
                                  Tab(
                                    child: Text(
                                      tr(LocalKeys.shipments),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  // Tab(
                                  //   child: Text(
                                  //     tr(LocalKeys.missions),
                                  //     style: TextStyle(
                                  //       fontSize: 12,
                                  //       fontWeight: FontWeight.w500,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xffF7F7FB),
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          buildCurrent(),
                          // buildMissions(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16.0,),
                    decoration: BoxDecoration(
                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].background),
                            border: Border.all(width: 1,
                                color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary)
                                ,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add,
                          color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary)
                          ,
                      ),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (_)=> NewOrderScreen())).then((value) {
                          if(value == true){
                            BlocProvider.of<HomeBloc>(context).add(FetchHomeEvent(forFirstTime: false));
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * (4.6 / 100),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCurrent() {
    return BlocBuilder<HomeBloc,HomeStates>(
      builder: (context, state) => ConditionalBuilder(
        condition: state is !LoadingHomeState,
        builder:(context) =>  SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: (){
            BlocProvider.of<HomeBloc>(context).add(FetchHomeEvent(forFirstTime: false));
            _refreshController.loadComplete();
          },
          child: SingleChildScrollView(
            controller: scrollControllerShipments,
            child: Column(
              children: [
                ConditionalBuilder(
                  condition: BlocProvider.of<HomeBloc>(context).shipments.length>0,
                  builder: (context) =>     ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: BlocProvider.of<HomeBloc>(context).shipments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          if(index ==0)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * (2 / 100),
                            ),
                          Card(
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
                                Navigator.push(context,MaterialPageRoute(builder: (_)=>
                                        ShipmentDetailsScreen(BlocProvider.of<HomeBloc>(context).shipments[index])));
                              },
                              child: Column(
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
                                              height: MediaQuery.of(context).size.width * (4.2 / 100),
                                            ),
                                            Text(
                                              BlocProvider.of<HomeBloc>(context).shipments[index].code+'  ['+BlocProvider.of<HomeBloc>(context).shipments[index].type+']',
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
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * (5.0 / 100),
                                          vertical: MediaQuery.of(context).size.width * (2.0 / 100),
                                        ),
                                        child: Text(
                                          tr(AppKeys.getShipmentStatus(int.parse(BlocProvider.of<HomeBloc>(context).shipments[index].status_id??'0'))),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: (MediaQuery.of(context).size.height * (2.2 / 100)) / 3,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * (4.2 / 100),
                                      ),
                                      Expanded(
                                              child: StepTracker(
                                                title: BlocProvider.of<HomeBloc>(context).shipments[index].from_address.address,
                                                icon: null,
                                                isLast: false,
                                              )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * (4.2 / 100),
                                      ),
                                      Expanded(
                                              child: StepTracker(
                                                title: BlocProvider.of<HomeBloc>(context).shipments[index].reciver_address,
                                                icon: null,
                                                isLast: true,
                                              )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * (2.2 / 100),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * (4.2 / 100),
                                      ),
                                      if(BlocProvider.of<HomeBloc>(context).shipments[index].mission_id !=null && BlocProvider.of<HomeBloc>(context).shipments[index].mission_id.isNotEmpty)
                                        Icon(Icons.check_circle_outline_rounded,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      if(BlocProvider.of<HomeBloc>(context).shipments[index].mission_id !=null && BlocProvider.of<HomeBloc>(context).shipments[index].mission_id.isNotEmpty)
                                        SizedBox(
                                        width: MediaQuery.of(context).size.width * (2.2 / 100),
                                      ),
                                      if(BlocProvider.of<HomeBloc>(context).shipments[index].mission_id !=null && BlocProvider.of<HomeBloc>(context).shipments[index].mission_id.isNotEmpty)
                                        Expanded(
                                        child: Text(
                                          tr(LocalKeys.in_mission),
                                          style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * (4.2 / 100),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (4.2 / 100)),
                                          child: Text(
                                            BlocProvider.of<HomeBloc>(context).paymentTypes == null ||BlocProvider.of<HomeBloc>(context).paymentTypes.length == 0?'': BlocProvider.of<HomeBloc>(context).paymentTypes.firstWhere((element) {
                                              return element.id.toString()== BlocProvider.of<HomeBloc>(context).shipments[index].payment_method_id.toString();
                                            }).name,
                                            style: TextStyle(
                                              color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * (4.2 / 100),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * (4.2 / 100),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  fallback: (context) => EmptyContent(
                    svgIconPath: 'assets/icons/empty.svg',
                    message: tr(LocalKeys.noDataFound),
                    hasEmptyHeight: true,

                  ),
                ),

                BlocBuilder<HomeBloc,HomeStates>(
                  builder: (context, state) =>Visibility(
                    visible: state is LoadingMoreShipmentsHomeState,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    );
  }
}
