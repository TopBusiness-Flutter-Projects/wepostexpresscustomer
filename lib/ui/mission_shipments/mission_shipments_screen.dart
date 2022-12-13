import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/components/step_tracker.dart';
import 'package:wepostexpresscustomer/ui/create_mission/bloc/create_mission_bloc.dart';
import 'package:wepostexpresscustomer/ui/create_mission/bloc/create_mission_events.dart';
import 'package:wepostexpresscustomer/ui/create_mission/bloc/create_mission_states.dart';
import 'package:wepostexpresscustomer/ui/mission_shipments/bloc/mission_shipments_bloc.dart';
import 'package:wepostexpresscustomer/ui/mission_shipments/bloc/mission_shipments_events.dart';
import 'package:wepostexpresscustomer/ui/mission_shipments/bloc/mission_shipments_states.dart';
import 'package:wepostexpresscustomer/ui/shipment_details/shipment_details_screen.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';

class MissionShipmentsScreen extends StatelessWidget {
    final  String missionID;

  MissionShipmentsScreen(this.missionID) ;

    @override
    Widget build(BuildContext context) {
        return BlocProvider<MissionShipmentsBloc>(
            create: (BuildContext context) => di<MissionShipmentsBloc>()..add(FetchMissionShipmentsEvent(missionID)),
            child: BlocListener<MissionShipmentsBloc, MissionShipmentsStates>(
                listener: (BuildContext context, MissionShipmentsStates state) async {
                    if (state is ErrorMissionShipmentsState) {
                        showToast(state.error, false);
                    }
                },
                child: SafeArea(
                  child: Scaffold(
                      body: Column(
                        children: [
                            Container(
                                color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                child: Column(
                                    children: [
                                        SizedBox(
                                            height: MediaQuery.of(context).size.height * (1.2 / 100),
                                        ),
                                        Row(
                                            children: [
                                                SizedBox(
                                                    width: MediaQuery.of(context).size.height * (1.2 / 100),
                                                ),
                                                Container(
                                                    height: MediaQuery.of(context).size.height * (5.91 / 100),
                                                    child: IconButton(
                                                        icon: Icon(Icons.arrow_back_ios,
                                                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                                                        ),
                                                        onPressed: () {
                                                            Navigator.pop(context);
                                                        },
                                                    ),
                                                ),
                                                Expanded(
                                                    child: Center(
                                                        child: Text(
                                                            tr(LocalKeys.mission_shipments),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                                                            ),
                                                        ),
                                                    ),
                                                ),
                                                Container(
                                                    width: MediaQuery.of(context).size.height * (5.91 / 100),
                                                ),
                                            ],
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context).size.height * (1.97 / 100),
                                        ),
                                    ],
                                ),
                            ),
                            Expanded(
                              child: BlocBuilder<MissionShipmentsBloc,MissionShipmentsStates>(
                                  builder: (context, state) => ConditionalBuilder(
                                          condition: state is !LoadingMissionShipmentsState,
                                          builder:(context) =>  ListView.builder(
                                              itemCount: BlocProvider.of<MissionShipmentsBloc>(context).shipments.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                  return Row(
                                                    children: [
                                                      SizedBox(
                                                          width: MediaQuery.of(context).size.width * (2.2 / 100),
                                                      ),
                                                      Expanded(
                                                        child: Card(
                                                            elevation: 10,
                                                            shadowColor: Color(0xffF7F7FB),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(15),
                                                            ),
                                                            margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * (2.4 / 100)),
                                                            clipBehavior:Clip.antiAlias ,
                                                            child: InkWell(
                                                                onTap: (){
                                                                    Navigator.push(context,MaterialPageRoute(builder: (_)=>
                                                                            ShipmentDetailsScreen(BlocProvider.of<MissionShipmentsBloc>(context).shipments[index])));
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
                                                                                              BlocProvider.of<MissionShipmentsBloc>(context).shipments[index].code,
                                                                                              style: TextStyle(
                                                                                                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
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
                                                                                      BlocProvider.of<MissionShipmentsBloc>(context).shipments[index].type,
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
                                                                                          title: BlocProvider.of<MissionShipmentsBloc>(context).shipments[index].client_address,
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
                                                                                          title: BlocProvider.of<MissionShipmentsBloc>(context).shipments[index].reciver_address,
                                                                                          icon: null,
                                                                                          isLast: true,
                                                                                      )),
                                                                          ],
                                                                      ),
                                                                      SizedBox(
                                                                          height: MediaQuery.of(context).size.width * (1.2 / 100),
                                                                      ),
                                                                      Container(
                                                                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (4.2 / 100)),
                                                                        width:double.infinity,
                                                                        child: Text(
                                                                            BlocProvider.of<MissionShipmentsBloc>(context).paymentTypes.firstWhere((element) {
                                                                              return element.id.toString()== BlocProvider.of<MissionShipmentsBloc>(context).shipments[index].payment_method_id.toString()||BlocProvider.of<MissionShipmentsBloc>(context).shipments[index].payment_type.toString()=='1';
                                                                            }).name,
                                                                            style: TextStyle(
                                                                                color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500,
                                                                            ),
                                                                            textAlign: TextAlign.end,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height: MediaQuery.of(context).size.width * (4.2 / 100),
                                                                      ),
                                                                  ],
                                                              ),
                                                            ),
                                                        ),
                                                      ),
                                                        SizedBox(
                                                            width: MediaQuery.of(context).size.width * (2.2 / 100),
                                                        ),
                                                    ],
                                                  );
                                              },
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
            ),
        );
    }
}
