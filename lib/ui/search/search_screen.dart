import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:wepostexpresscustomer/components/empty_content.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:wepostexpresscustomer/components/main_button.dart';
import 'package:wepostexpresscustomer/components/my_form_field.dart';
import 'package:wepostexpresscustomer/components/my_svg.dart';
import 'package:wepostexpresscustomer/components/qr_code.dart';
import 'package:wepostexpresscustomer/components/step_tracker.dart';
import 'package:wepostexpresscustomer/models/county_model.dart';
import 'package:wepostexpresscustomer/models/user/user_model.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_bloc.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_events.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_states.dart';
import 'package:wepostexpresscustomer/ui/home/home_screen.dart';
import 'package:wepostexpresscustomer/ui/login/login_screen.dart';
import 'package:wepostexpresscustomer/ui/search/bloc/search_bloc.dart';
import 'package:wepostexpresscustomer/ui/search/bloc/search_events.dart';
import 'package:wepostexpresscustomer/ui/search/bloc/search_states.dart';
import 'package:wepostexpresscustomer/ui/shipment_details/shipment_details_screen.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/app_keys.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchScreen extends StatefulWidget {
  final String code;

  SearchScreen({@required this.code});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AfterLayoutMixin {
  final formKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd hh:mm');
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    print('sadasdasd');
    return BlocProvider<SearchBloc>(
      create: (BuildContext context) {
        return di<SearchBloc>()..add(FetchSearchEvent(widget.code));
      },
      child: BlocListener<SearchBloc, SearchStates>(
        listener: (BuildContext context, SearchStates state) async {
          if (state is SuccessSearchState) {
          }
          if (state is SearchedSuccessfully) {
          }
          if (state is LoadingProgressSearchState) {
            showProgressDialog(context);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Form(
              key: formKey,
              child: Builder(
                builder: (context) => SizedBox.expand(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (1.3 / 100)),
                                    decoration: BoxDecoration(
                                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].background),
                                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            focusNode: focusNode,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            onSubmitted: (code){
                                              if(code!= null && code.trim().isNotEmpty){
                                                BlocProvider.of<SearchBloc>(context).add(FetchSearchEvent(code));
                                              }
                                            },
                                            textInputAction: TextInputAction.search,
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
                                                          color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary).withOpacity(0.5)),
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
                                                Timer(Duration(milliseconds: 500),(){
                                                  print('barcodebarcode value');
                                                  Navigator.push(context,MaterialPageRoute(builder: (_)=>QRViewExample())).then((value) {
                                                    print('barcode value');
                                                    print(value);
                                                    if(value !=null){
                                                      BlocProvider.of<SearchBloc>(context).add(FetchSearchEvent(value));
                                                    }
                                                    return null;
                                                  });
                                                });

                                              }else{
                                              Navigator.push(context,MaterialPageRoute(builder: (_)=>QRViewExample())).then((value) {
                                                print('barcode value');
                                                print(value);
                                                if(value !=null){
                                                  BlocProvider.of<SearchBloc>(context).add(FetchSearchEvent(value));
                                                }
                                                return null;
                                              });

                                              }
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
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * (1.2 / 100),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (1.1 / 100),
                      ),
                      Expanded(
                          child: BlocBuilder<SearchBloc,SearchStates>(
                            builder: (context, state) {
                              print('statestatestate');
                              print(state);
                              return ConditionalBuilder(
                                condition: state is !LoadingSearchState,
                                builder:(context) =>   ConditionalBuilder(
                                  condition: state is SuccessSearchState &&BlocProvider.of<SearchBloc>(context).shipment != null,
                                  builder: (context) =>     SingleChildScrollView(
                                    child: Column(
                                      children: [
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
                                                      ShipmentDetailsScreen(BlocProvider.of<SearchBloc>(context).shipment)));
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
                                                            (BlocProvider.of<SearchBloc>(context)?.shipment?.code??'')+'  ['+(BlocProvider.of<SearchBloc>(context)?.shipment?.type??'')+']',
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
                                                        tr(AppKeys.getShipmentStatus(int.parse((BlocProvider.of<SearchBloc>(context).shipment.status_id == null ||BlocProvider.of<SearchBloc>(context).shipment.status_id == '')?'0':BlocProvider.of<SearchBloc>(context).shipment?.status_id))),
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
                                                              title: BlocProvider.of<SearchBloc>(context).shipment.from_address.address,
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
                                                              title: BlocProvider.of<SearchBloc>(context).shipment.reciver_address,
                                                              icon: null,
                                                              isLast: true,
                                                            )),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context).size.width * (4.2 / 100),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * (3.2 / 100),
                                                    ),
                                                    Expanded(child: Container(
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.symmetric(
                                                            horizontal: MediaQuery.of(context).size.width * (1 / 100),
                                                            vertical: MediaQuery.of(context).size.height * (2.4 / 100)),
                                                            child: Text(tr(LocalKeys.date),
                                                            ),
                                                    ),
                                                    ),
                                                    Expanded(child: Container( margin: EdgeInsets.symmetric(
                                                            horizontal: MediaQuery.of(context).size.width * (1 / 100),
                                                            vertical: MediaQuery.of(context).size.height * (2.4 / 100)),
                                                            child: Text(tr(LocalKeys.status),
                                                            ),
                                                      alignment: Alignment.center,
                                                    ),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.of(context).size.width * (3.2 / 100),
                                                    ),
                                                  ],
                                                ),
                                                ListView.builder(itemCount: BlocProvider.of<SearchBloc>(context).logs.length,
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) => Container(
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width * (3.2 / 100),
                                                        ),
                                                        Expanded(child: Container(
                                                                alignment: Alignment.center,
                                                                margin: EdgeInsets.symmetric(
                                                                horizontal: MediaQuery.of(context).size.width * (1 / 100),
                                                                vertical: MediaQuery.of(context).size.height * (2.4 / 100)),
                                                                child: Text(
                                                                        (){
                                                                         return BlocProvider.of<SearchBloc>(context).logs[index]?.created_at!=null?
                                                                          timeago.format(dateFormat.parse(BlocProvider.of<SearchBloc>(context).logs[index]?.created_at))
                                                                                  :'';
                                                                        }(),
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                        ),
                                                        ),
                                                        Expanded(child: Container(
                                                                alignment: Alignment.center,
                                                                margin: EdgeInsets.symmetric(
                                                                        horizontal: MediaQuery.of(context).size.width * (1 / 100),
                                                                vertical: MediaQuery.of(context).size.height * (2.4 / 100)),
                                                                child: Text(tr(AppKeys.getShipmentLogStatus(int.parse(BlocProvider.of<SearchBloc>(context).logs[index]?.to??'0'))),
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                        ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width * (3.2 / 100),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  fallback: (context) => EmptyContent(
                                    svgIconPath: 'assets/icons/empty.svg',
                                    message: tr(LocalKeys.noDataFound),
                                    hasEmptyHeight: true,

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
                              );
                            },
                          ),
                      ),
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

  @override
  void afterFirstLayout(BuildContext context) {
    focusNode.requestFocus();
  }

}
