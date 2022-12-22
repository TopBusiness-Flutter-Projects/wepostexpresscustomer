import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/components/main_button.dart';
import 'package:wepostexpresscustomer/components/my_form_field.dart';
import 'package:wepostexpresscustomer/components/step_tracker_horizontal.dart';
import 'package:wepostexpresscustomer/models/new_order/address_new_order.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/add_address_screen.dart';
import 'package:wepostexpresscustomer/ui/add_new_receiver/add_receiver_screen.dart';
import 'package:wepostexpresscustomer/ui/add_new_receiver_address/add_receiver_address_screen.dart';
import 'package:wepostexpresscustomer/ui/new_order/new_order_bloc/new_order_bloc.dart';
import 'package:wepostexpresscustomer/ui/new_order/new_order_bloc/new_order_events.dart';
import 'package:wepostexpresscustomer/ui/new_order/new_order_bloc/new_order_states.dart';
import 'package:wepostexpresscustomer/ui/new_order/settings_new_order.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/app_keys.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderState createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrderScreen> with AfterLayoutMixin {
  final pageController = PageController();
  ScrollController scrollController = ScrollController();
  GlobalKey<FormState> firstFormKey= GlobalKey<FormState>();
  GlobalKey<FormState> secondFormKey= GlobalKey<FormState>();
  GlobalKey<FormState> thirdFormKey= GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController(text: '0');
  var isLast = false;
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
    pageController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewOrderBloc>(
      create: (BuildContext context) => di<NewOrderBloc>()..add(FetchNewOrderEvent()),
      child: BlocListener<NewOrderBloc, NewOrderStates>(
        listener: (BuildContext context, state) {
          if (state is ErrorNewOrderState) {
            Navigator.pop(context);
            showToast(state.error,false);
          }
          if (state is LoadingNewOrderState) {
            showProgressDialog(context);
          }
          if (state is SuccessNewOrderState) {
            Navigator.pop(context);
          }
          if (state is SuccessCreateOrderState) {
            Navigator.pop(context);
            Navigator.pop(context,true);
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            print('tttttttttttttttt');
            print(BlocProvider.of<NewOrderBloc>(context).currentIndex);
            if (pageController.page != 0) {
              pageController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);
              return false;
            } else {
              return true;
            }
          },
          child: SafeArea(
            child: Scaffold(
              body: Builder(
                builder: (context) => SizedBox.expand(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].background),
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
                                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                    ),
                                    onPressed: () {
                                      if (BlocProvider.of<NewOrderBloc>(context).currentIndex !=
                                          0) {
                                        pageController.previousPage(
                                            duration: Duration(milliseconds: 250),
                                            curve: Curves.easeIn);
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      tr(LocalKeys.add_shipment),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.height * (5.91 / 100),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * (1.97 / 100),
                            ),
                          ],
                        ),
                      ),
                      BlocConsumer<NewOrderBloc, NewOrderStates>(
                        listener: (context, state) => null,
                        builder: (context, state) => Container(
                          color: Color(0xff281B13),
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (2.3 / 100),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * (7.7 / 100),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        StepTrackerHorizontal(
                                          circleSizeStart:
                                              MediaQuery.of(context).size.height * (4.9 / 100),
                                          circleSizeEnd:
                                              MediaQuery.of(context).size.height * (5.9 / 100),
                                          index: 0,
                                          firstFilled: false,
                                          secondFilled: false,
                                          iconFilled:
                                              BlocProvider.of<NewOrderBloc>(context).currentIndex ==
                                                  0,
                                          stepDone:
                                              BlocProvider.of<NewOrderBloc>(context).currentIndex >
                                                  0,
                                          isLast: true,
                                          icon: 'assets/icons/house.svg',
                                          title: 'sss',
                                          screenSize: MediaQuery.of(context).size.width,
                                        ),
                                        Expanded(
                                            child: StepTrackerHorizontal(
                                          screenSize: MediaQuery.of(context).size.width,
                                          circleSizeStart:
                                              MediaQuery.of(context).size.height * (4.9 / 100),
                                          circleSizeEnd:
                                              MediaQuery.of(context).size.height * (5.9 / 100),
                                          index: 1,
                                          iconFilled:
                                              BlocProvider.of<NewOrderBloc>(context).currentIndex ==
                                                  1,
                                          stepDone:
                                              BlocProvider.of<NewOrderBloc>(context).currentIndex >
                                                  1,
                                          firstFilled:
                                              BlocProvider.of<NewOrderBloc>(context).currentIndex >
                                                  0,
                                          secondFilled:
                                              BlocProvider.of<NewOrderBloc>(context).currentIndex >
                                                  1,
                                          isLast: false,
                                          icon: 'assets/icons/clipboard.svg',
                                          title: 'ssssssssss',
                                        )),
                                        StepTrackerHorizontal(
                                          screenSize: MediaQuery.of(context).size.width,
                                          circleSizeStart:
                                              MediaQuery.of(context).size.height * (4.9 / 100),
                                          circleSizeEnd:
                                              MediaQuery.of(context).size.height * (5.9 / 100),
                                          index: 2,
                                          iconFilled:
                                              BlocProvider.of<NewOrderBloc>(context).currentIndex ==
                                                  2,
                                          stepDone:
                                              BlocProvider.of<NewOrderBloc>(context).currentIndex >
                                                  2,
                                          firstFilled: false,
                                          secondFilled: false,
                                          isLast: true,
                                          icon: 'assets/icons/shield.svg',
                                          title: 'sss',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * (7.7 / 100),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (0.7 / 100),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * (27 / 100),
                                          alignment: Alignment.center,
                                          child: Text(
                                            tr(LocalKeys.shipment_info),
                                            textAlign: TextAlign.center,
                                            strutStyle: StrutStyle(
                                              fontSize: 8.3 * 1.5,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                              leading: 0,
                                              forceStrutHeight: true,
                                            ),
                                            style: TextStyle(
                                              fontSize: 9.3 * 1.5,
                                              height: 1.5,
                                              color: BlocProvider.of<NewOrderBloc>(context)
                                                          .currentIndex >
                                                      0
                                                  ? rgboOrHex(Config
                                                      .get
                                                      .styling[Config.get.themeMode]
                                                      .primary)
                                                  : BlocProvider.of<NewOrderBloc>(context)
                                                              .currentIndex ==
                                                          0
                                                      ? Colors.white
                                                      : rgboOrHex(Config
                                                          .get
                                                          .styling[Config.get.themeMode]
                                                          .secondaryVariant),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              tr(LocalKeys.shipment_details),
                                              strutStyle: StrutStyle(
                                                fontSize: 9.3 * 1.5,
                                                height: 1,
                                                fontWeight: FontWeight.bold,
                                                leading: 0,
                                                forceStrutHeight: true,
                                              ),
                                              style: TextStyle(
                                                fontSize: 8.3 * 1.5,
                                                height: 1.5,
                                                color: BlocProvider.of<NewOrderBloc>(context)
                                                            .currentIndex >
                                                        1
                                                    ? rgboOrHex(Config
                                                        .get
                                                        .styling[Config.get.themeMode]
                                                        .primary)
                                                    : BlocProvider.of<NewOrderBloc>(context)
                                                                .currentIndex ==
                                                            1
                                                        ? Colors.white
                                                        : rgboOrHex(Config
                                                            .get
                                                            .styling[Config.get.themeMode]
                                                            .secondaryVariant),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * (27 / 100),
                                          alignment: Alignment.center,
                                          child: Text(
                                            tr(LocalKeys.shipment_review),
                                            textAlign: TextAlign.center,
                                            strutStyle: StrutStyle(
                                              fontSize: 9.3 * 1.5,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                              leading: 0,
                                              forceStrutHeight: true,
                                            ),
                                            style: TextStyle(
                                              fontSize: 8.3 * 1.5,
                                              height: 1.5,
                                              color: BlocProvider.of<NewOrderBloc>(context)
                                                          .currentIndex >
                                                      2
                                                  ? rgboOrHex(Config
                                                      .get
                                                      .styling[Config.get.themeMode]
                                                      .primary)
                                                  : BlocProvider.of<NewOrderBloc>(context)
                                                              .currentIndex ==
                                                          2
                                                      ? Colors.white
                                                      : rgboOrHex(Config
                                                          .get
                                                          .styling[Config.get.themeMode]
                                                          .secondaryVariant),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (2.3 / 100),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if(BlocProvider.of<NewOrderBloc>(context).errorOccurred)
                        BlocBuilder<NewOrderBloc,NewOrderStates>(
                          builder:(context, state) =>   Container(
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
                                      BlocProvider.of<NewOrderBloc>(context).add(FetchNewOrderEvent());
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
                        ),
                      Expanded(
                        child: PageView(
                          controller: pageController,
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            if (BlocProvider.of<NewOrderBloc>(context).currentIndex <= index) {
                              print('sdasd 11');
                              BlocProvider.of<NewOrderBloc>(context).currentIndex = index;
                              BlocProvider.of<NewOrderBloc>(context).add(NewOrderChangeEvent());
                            } else {
                              print('sdasd 22');
                              BlocProvider.of<NewOrderBloc>(context).currentIndex = index;
                              BlocProvider.of<NewOrderBloc>(context)
                                  .add(NewOrderChangeBackwardEvent());
                            }
                          },
                          children: [
                            buildFirst(),
                            Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                      BlocBuilder<NewOrderBloc, NewOrderStates>(
                                            builder: (context, state) {
                                              return Form(
                                                key: secondFormKey,
                                                child: Column(
                                                  children: [
                                                    ListView.builder(
                                                      itemBuilder: (context, index) => buildSecond(index),
                                                      itemCount: BlocProvider.of<NewOrderBloc>(context).packageWidgets.length,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                    ),
                                            ],
                                          ),
                                              );
                                            },
                                        ),
                                        Card(
                                          margin: EdgeInsets.all(15),
                                          elevation: 10,
                                          child: InkWell(
                                            onTap: () {
                                              BlocProvider.of<NewOrderBloc>(context).packageWidgets.add(AddressOrderModel(
                                                packageModel: BlocProvider.of<NewOrderBloc>(context).defaultPackage,
                                                weightUnit: AppKeys.weights.first,
                                                heightUnit: AppKeys.heights.first,
                                                widthUnit: AppKeys.heights.first,
                                                lengthUnit: AppKeys.heights.first,
                                                quantity: 1.toString(),
                                                weight: 1.toString(),
                                                height: 1.toString(),
                                                width: 1.toString(),
                                                length: 1.toString(),
                                              ));
                                              BlocProvider.of<NewOrderBloc>(context).add(AddPackageNewOrderEvent());

                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.add_circle_outline),
                                                  SizedBox(width:5,),
                                                  Text(tr(LocalKeys.add_new_package)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                          child: MainButton(
                                            borderColor: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                                            borderRadius: 0,
                                            onPressed: () {
                                              secondFormKey.currentState.save();
                                              if(secondFormKey.currentState.validate())
                                                {
                                                  pageController.nextPage(
                                                          duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                                                }
                                            },
                                            text: tr(LocalKeys.next),
                                            textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                                            color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * (1.1 / 100),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            buildThird(),
                          ],
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
    // TODO: implement afterFirstLayout
  }

  Widget buildFirst() {
    return Builder(
      builder: (context) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: firstFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (4.9 / 100),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr(LocalKeys.shipment_type),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (1.4 / 100),
                    ),
                    BlocConsumer<NewOrderBloc, NewOrderStates>(
                      listener: (context, state) => null,
                      builder: (context, state) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                        child: Row(
                          children: [
                            Expanded(
                              child: MainButton(
                                hasIcon: BlocProvider.of<NewOrderBloc>(context).isPickup,
                                icon: Icons.done_sharp,
                                borderColor: BlocProvider.of<NewOrderBloc>(context).isPickup
                                    ? rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor)
                                    : rgboOrHex(
                                        Config.get.styling[Config.get.themeMode].secondaryVariant),
                                borderRadius: 0,
                                onPressed: () {
                                  if (!BlocProvider.of<NewOrderBloc>(context).isPickup) {
                                    BlocProvider.of<NewOrderBloc>(context)
                                        .add(ChangeSendReceiveNewOrderEvent());
                                  }
                                },
                                text: tr(LocalKeys.pickup),
                                textColor: BlocProvider.of<NewOrderBloc>(context).isPickup
                                    ? rgboOrHex(
                                        Config.get.styling[Config.get.themeMode].buttonTextColor)
                                    : rgboOrHex(
                                        Config.get.styling[Config.get.themeMode].secondaryVariant),
                                color: BlocProvider.of<NewOrderBloc>(context).isPickup
                                    ? rgboOrHex(Config
                                        .get.styling[Config.get.themeMode].primary)
                                    : Colors.transparent,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * (5.6 / 100),
                            ),
                            Expanded(
                              child: MainButton(
                                hasIcon: !BlocProvider.of<NewOrderBloc>(context).isPickup,
                                icon: Icons.done_sharp,
                                borderColor: !BlocProvider.of<NewOrderBloc>(context).isPickup
                                    ? rgboOrHex(
                                        Config.get.styling[Config.get.themeMode].buttonTextColor)
                                    : rgboOrHex(
                                        Config.get.styling[Config.get.themeMode].secondaryVariant),
                                borderRadius: 0,
                                onPressed: () {
                                  if (BlocProvider.of<NewOrderBloc>(context).isPickup) {
                                    BlocProvider.of<NewOrderBloc>(context)
                                        .add(ChangeSendReceiveNewOrderEvent());
                                  }
                                },
                                text: tr(LocalKeys.dropOff),
                                textColor: !BlocProvider.of<NewOrderBloc>(context).isPickup
                                    ? rgboOrHex(
                                        Config.get.styling[Config.get.themeMode].buttonTextColor)
                                    : rgboOrHex(
                                        Config.get.styling[Config.get.themeMode].secondaryVariant),
                                color: !BlocProvider.of<NewOrderBloc>(context).isPickup
                                    ? rgboOrHex(Config
                                        .get.styling[Config.get.themeMode].primary)
                                    : Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (4.9 / 100),
                    ),
                    BlocBuilder<NewOrderBloc, NewOrderStates>(
                      builder: (context, state) => MyFormField(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                        context: context,
                        error: tr(LocalKeys.this_field_cant_be_empty),
                        hasError: BlocProvider.of<NewOrderBloc>(context).selectedBranch == null,
                        child: InkWell(
                          onTap: () {
                            return showBranches(context, true);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * (1 / 100)),
                                      child: Text(
                                        tr(LocalKeys.branch),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      BlocProvider.of<NewOrderBloc>(context).selectedBranch != null
                                              ? BlocProvider.of<NewOrderBloc>(context)
                                              .selectedBranch
                                              .name
                                              : tr(LocalKeys.branch),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 24,
                                      color: rgboOrHex(Config
                                              .get.styling[Config.get.themeMode].primary),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (0.9 / 100),
                                ),
                                Container(
                                  height: 1,
                                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<NewOrderBloc, NewOrderStates>(
                      builder: (context, state) => Visibility(
                        visible: BlocProvider.of<NewOrderBloc>(context).settings.isNotEmpty && BlocProvider.of<NewOrderBloc>(context).settings?.firstWhere((element) => element.key ==SettingsNewOrder.is_date_required)?.value!="0"??false,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * (3.9 / 100),
                            ),
                            MyFormField(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                              context: context,
                              error: tr(LocalKeys.this_field_cant_be_empty),
                              hasError: BlocProvider.of<NewOrderBloc>(context).dateTime == null,
                              child: InkWell(
                                onTap: () async {
                                  final DateTime date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now().add(Duration(days: int.parse(BlocProvider.of<NewOrderBloc>(context).settings?.firstWhere((element) => element.key ==SettingsNewOrder.is_date_required)?.value??'0'))),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(Duration(days: 100)),
                                  );
                                  if (date != null) {
                                    BlocProvider.of<NewOrderBloc>(context).dateTime=date;
                                    BlocProvider.of<NewOrderBloc>(context).add(AddDateNewOrderEvent());
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            tr(LocalKeys.date),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            BlocProvider.of<NewOrderBloc>(context).dateTime != null
                                                    ? (
                                                    BlocProvider.of<NewOrderBloc>(context).dateTime.year.toString()+
                                                            '/'+
                                                            (BlocProvider.of<NewOrderBloc>(context).dateTime.month > 9?'':'0')+
                                                            BlocProvider.of<NewOrderBloc>(context).dateTime.month.toString()+
                                                            '/'+
                                                            (BlocProvider.of<NewOrderBloc>(context).dateTime.day >9?'':'0')+
                                                            BlocProvider.of<NewOrderBloc>(context).dateTime.day.toString()
                                            )
                                                    : tr(LocalKeys.date),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            size: 24,
                                            color: rgboOrHex(Config
                                                    .get.styling[Config.get.themeMode].primary),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * (0.9 / 100),
                                      ),
                                      Container(
                                        height: 1,
                                        color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                        width: double.infinity,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (3.9 / 100),
                    ),
                    BlocBuilder<NewOrderBloc, NewOrderStates>(
                      builder: (context, state) => MyFormField(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                        context: context,
                        error: tr(LocalKeys.this_field_cant_be_empty),
                        hasError: BlocProvider.of<NewOrderBloc>(context).senderAddress == null,
                        child: InkWell(
                          onTap: () {
                            return showAddresses(context, true);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tr(LocalKeys.sender_address),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) => AddAddressScreen())).then((value) => BlocProvider.of<NewOrderBloc>(context).add(FetchNewOrderEvent()));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.height * (1 / 100)),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add,
                                              size: 14,
                                              color: rgboOrHex(Config.get.styling[Config.get.themeMode]
                                                  .primary),
                                            ),
                                            Text(
                                              tr(LocalKeys.add_new_address),
                                              style: TextStyle(
                                                color: rgboOrHex(Config
                                                    .get
                                                    .styling[Config.get.themeMode]
                                                    .primary),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      BlocProvider.of<NewOrderBloc>(context).senderAddress != null
                                          ? BlocProvider.of<NewOrderBloc>(context)
                                              .senderAddress
                                              .address
                                          : tr(LocalKeys.sender_address),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 24,
                                      color: rgboOrHex(Config
                                          .get.styling[Config.get.themeMode].primary),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (0.9 / 100),
                                ),
                                Container(
                                  height: 1,
                                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (3.9 / 100),
                    ),
                    BlocBuilder<NewOrderBloc, NewOrderStates>(
                      builder: (context, state) =>   MyFormField(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                        context: context,
                        error: tr(LocalKeys.this_field_cant_be_empty),
                        hasError: BlocProvider.of<NewOrderBloc>(context).receiverModel == null,
                        child: InkWell(
                          onTap: () {
                            showReceivers(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tr(LocalKeys.receiver),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (_)=>AddReceiverScreen())).then((value) => BlocProvider.of<NewOrderBloc>(context).add(FetchNewOrderEvent()));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.height * (1 / 100)),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add,
                                              size: 14,
                                              color: rgboOrHex(Config.get.styling[Config.get.themeMode]
                                                  .primary),
                                            ),
                                            Text(
                                              tr(LocalKeys.add_new_receiver),
                                              style: TextStyle(
                                                color: rgboOrHex(Config.get.styling[Config.get.themeMode]
                                                    .primary),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      BlocProvider.of<NewOrderBloc>(context).receiverModel == null?tr(LocalKeys.receiver):BlocProvider.of<NewOrderBloc>(context).receiverModel.receiver_name,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 24,
                                      color: rgboOrHex(
                                          Config.get.styling[Config.get.themeMode].primary),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (0.9 / 100),
                                ),
                                Container(
                                  height: 1,
                                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (4.9 / 100),
                    ),
                    BlocBuilder<NewOrderBloc, NewOrderStates>(
                      builder: (context, state) => MyFormField(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                        context: context,
                        error: tr(LocalKeys.this_field_cant_be_empty),
                        hasError: BlocProvider.of<NewOrderBloc>(context).receiverAddress == null,
                        child: InkWell(
                          onTap: () {
                            return showReceiverAddresses(context, false);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tr(LocalKeys.receiver_address),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (_)=>AddReceiverAddressScreen())).then((value) => BlocProvider.of<NewOrderBloc>(context).add(FetchNewOrderEvent()));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.height * (1 / 100)),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add,
                                              size: 14,
                                              color: rgboOrHex(Config.get.styling[Config.get.themeMode]
                                                  .primary),
                                            ),
                                            Text(
                                              tr(LocalKeys.add_new_receiver_address),
                                              style: TextStyle(
                                                color: rgboOrHex(Config
                                                    .get
                                                    .styling[Config.get.themeMode]
                                                    .primary),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      BlocProvider.of<NewOrderBloc>(context).receiverAddress != null
                                          ? BlocProvider.of<NewOrderBloc>(context)
                                              .receiverAddress
                                              .address
                                          : tr(LocalKeys.receiver_address),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 24,
                                      color: rgboOrHex(Config
                                          .get.styling[Config.get.themeMode].primary),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (0.9 / 100),
                                ),
                                Container(
                                  height: 1,
                                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (3.9 / 100),
                    ),
                    BlocBuilder<NewOrderBloc, NewOrderStates>(
                      builder: (context, state) => MyFormField(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                        context: context,
                        error: tr(LocalKeys.this_field_cant_be_empty),
                        hasError: BlocProvider.of<NewOrderBloc>(context).paymentMethodModel == null,
                        child: InkWell(
                          onTap: () {
                            return showPaymentMethods(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tr(LocalKeys.paymentType),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (1 / 100),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      BlocProvider.of<NewOrderBloc>(context).paymentType != null
                                              ? BlocProvider.of<NewOrderBloc>(context)
                                              .paymentType ==AppKeys.PREPAID?tr(LocalKeys.prepaid):tr(LocalKeys.postpaid)
                                              : tr(LocalKeys.paymentType),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 24,
                                      color: rgboOrHex(Config
                                              .get.styling[Config.get.themeMode].primary),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (0.9 / 100),
                                ),
                                Container(
                                  height: 1,
                                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (3.9 / 100),
                    ),
                    BlocBuilder<NewOrderBloc, NewOrderStates>(
                      builder: (context, state) => MyFormField(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                        context: context,
                        error: tr(LocalKeys.this_field_cant_be_empty),
                        hasError: BlocProvider.of<NewOrderBloc>(context).paymentMethodModel == null,
                        child: InkWell(
                          onTap: () {
                            return showPaymentTypes(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tr(LocalKeys.paymentMethod),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (1 / 100),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      BlocProvider.of<NewOrderBloc>(context).paymentMethodModel != null
                                              ? BlocProvider.of<NewOrderBloc>(context)
                                              .paymentMethodModel
                                              .name
                                              : tr(LocalKeys.paymentMethod),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 24,
                                      color: rgboOrHex(Config
                                              .get.styling[Config.get.themeMode].primary),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * (0.9 / 100),
                                ),
                                Container(
                                  height: 1,
                                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (3.9 / 100),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                      child: Text(
                        tr(LocalKeys.amount_to_be_collected),
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    BlocBuilder<NewOrderBloc, NewOrderStates>(
                      builder: (context, state) => MyFormField(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                        context: context,
                        error: tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0',
                        hasError: (){
                          print('amount_to_be_collected');
                          print(BlocProvider.of<NewOrderBloc>(context).amount_to_be_collected);
                          print(BlocProvider.of<NewOrderBloc>(context).amount_to_be_collected.trim().isEmpty);
                          if(BlocProvider.of<NewOrderBloc>(context).amount_to_be_collected == null){
                            return true;
                          }
                          if(BlocProvider.of<NewOrderBloc>(context).amount_to_be_collected.trim().isEmpty){
                            return true;
                          }
                          if(double.parse(BlocProvider.of<NewOrderBloc>(context).amount_to_be_collected)<0.0){
                            return true;
                          }
                          return false;
                        }(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                            ],
                            onChanged: (value){
                              if(!value .replaceFirst('.','').contains('.')){
                                BlocProvider.of<NewOrderBloc>(context).amount_to_be_collected = value;
                                BlocProvider.of<NewOrderBloc>(context).add(SetAmountToBeCollectedNewOrderEvent());
                              }
                            },
                            decoration: InputDecoration(
                              hintText: tr(LocalKeys.amount_to_be_collected),
                              hintStyle: TextStyle(fontSize: 14),
                              focusedBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                      borderSide: BorderSide(color: Colors.black, width: 2)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<NewOrderBloc, NewOrderStates>(
                      builder: (context, state) => Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * (4.9 / 100),
                          ),
                          MyFormField(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                            context: context,
                            error: tr(LocalKeys.this_field_cant_be_empty),
                            hasError: BlocProvider.of<NewOrderBloc>(context).selectedDeliveryTime == null,
                            child: InkWell(
                              onTap: () async {
                                return showDeliveryTimes(context, true);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          tr(LocalKeys.deliveryTime),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          BlocProvider.of<NewOrderBloc>(context).selectedDeliveryTime != null
                                                  ? BlocProvider.of<NewOrderBloc>(context)
                                                  .selectedDeliveryTime
                                                  .name : tr(LocalKeys.deliveryTime),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          size: 24,
                                          color: rgboOrHex(Config
                                                  .get.styling[Config.get.themeMode].primary),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * (0.9 / 100),
                                    ),
                                    Container(
                                      height: 1,
                                      color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                      width: double.infinity,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (4.9 / 100),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (1.1 / 100),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                      child: MainButton(
                        borderColor:
                            rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                        borderRadius: 0,
                        onPressed: () {
                          firstFormKey.currentState.save();
                          if(firstFormKey.currentState.validate()){
                            pageController.nextPage(
                                    duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                          }
                        },
                        text: tr(LocalKeys.next),
                        textColor:
                            rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                        color:
                            rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (1.1 / 100),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSecond(int index) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(15),
      child: ExpandablePanel(
        header: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr(LocalKeys.package)+' '+'${index +1}'),
            ],
          ),
        ),
        collapsed: Container(),
        expanded: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(BlocProvider.of<NewOrderBloc>(context).packageWidgets.length !=1)
              Row(
                children: [
                  Spacer(),
                  IconButton(
                    onPressed:() async {
                      print('index');
                      print(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].quantity);
                      print(index);
                      final list = BlocProvider.of<NewOrderBloc>(context).packageWidgets;
                      List<AddressOrderModel> listToBeFilled = [];
                      for (var indexList = 0; indexList <BlocProvider.of<NewOrderBloc>(context).packageWidgets.length; indexList++) {
                        if (list[indexList] != BlocProvider.of<NewOrderBloc>(context).packageWidgets[index]) {
                          print('dddddddddddddd');
                          listToBeFilled.add(list[indexList]);
                        }
                      }
                        BlocProvider.of<NewOrderBloc>(context).packageWidgets = listToBeFilled;
                      BlocProvider.of<NewOrderBloc>(context).add(RemovePackageNewOrderEvent());
                      return ;
                    },

                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (1 / 100),
              ),
              BlocBuilder<NewOrderBloc, NewOrderStates>(
                builder: (context, state) => InkWell(
                  onTap: () {
                    return showPackages(context,index);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(LocalKeys.category),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].packageModel != null
                                      ? BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].packageModel.name
                                      : tr(LocalKeys.category),
                              style: TextStyle(fontSize: 14),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 24,
                              color: rgboOrHex(
                                      Config.get.styling[Config.get.themeMode].primary),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (0.9 / 100),
                        ),
                        Container(
                          height: 1,
                          color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (4.9 / 100),
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                child: Text(
                  tr(LocalKeys.quantity),
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                child: TextFormField(
                  controller: TextEditingController(text: BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].quantity),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                  ],
                  validator: (v){
                    if(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].quantity == null){
                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                    }
                    if(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].quantity.trim().isEmpty){
                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                    }
                    if(double.parse(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].quantity)<=0.0){
                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                    }
                    return null;
                  },
                  onChanged: (value){
                    if(!value .replaceFirst('.','').contains('.')){
                      BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].quantity = value;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: tr(LocalKeys.quantity),
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                          child: Text(
                            tr(LocalKeys.weight),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: TextEditingController(text: BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].weight),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                                  ],
                                  validator: (v){
                                    print('weightweight');
                                    print(double.parse(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].weight)<=0.0);
                                    print(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].weight);
                                    if(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].weight == null){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    if(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].weight.trim().isEmpty){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    if(double.parse(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].weight)<=0.0){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    return null;
                                  },
                                  onChanged: (value){
                                    if(!value .replaceFirst('.','').contains('.')){
                                      BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].weight = value;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: tr(LocalKeys.weight),
                                    hintStyle: TextStyle(fontSize: 11),
                                    focusedBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            borderSide: BorderSide(color: Colors.black, width: 2)),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: ()=>showWeights(context,index),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * (1 / 100),horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].weightUnit??tr(LocalKeys.kg),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 24,
                                        color: rgboOrHex(Config
                                                .get.styling[Config.get.themeMode].primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                          child: Text(
                            tr(LocalKeys.height),
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
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: TextEditingController(text: BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].height),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                                  ],
                                  validator: (v){
                                    if(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].height == null){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    if(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].height.trim().isEmpty){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    if(double.parse(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].height)<=0.0){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    return null;
                                  },
                                  onChanged: (value){
                                    if(!value .replaceFirst('.','').contains('.')){
                                      BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].height = value;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: tr(LocalKeys.height),
                                    hintStyle: TextStyle(fontSize: 11),
                                    focusedBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            borderSide: BorderSide(color: Colors.black, width: 2)),
                                  ),
                                ),
                              ),
                              BlocBuilder<NewOrderBloc, NewOrderStates>(
                                builder: (context, state) => InkWell(
                                  onTap: ()=>showHeights(context,index,true,false,false),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * (1 / 100),horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].heightUnit??tr(LocalKeys.cm),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          size: 24,
                                          color: rgboOrHex(Config
                                                  .get.styling[Config.get.themeMode].primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (3.9 / 100),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                          child: Text(
                            tr(LocalKeys.width),
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
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: TextEditingController(text: BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].width),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                                  ],
                                  validator: (v){
                                    if(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].width == null){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    if(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].width.trim().isEmpty){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    if(double.parse(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].width)<=0.0){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    return null;
                                  },
                                  onChanged: (value){
                                    if(!value .replaceFirst('.','').contains('.')){
                                      BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].width = value;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: tr(LocalKeys.width),
                                    hintStyle: TextStyle(fontSize: 11),
                                    focusedBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            borderSide: BorderSide(color: Colors.black, width: 2)),
                                  ),
                                ),
                              ),
                              BlocBuilder<NewOrderBloc, NewOrderStates>(
                                builder: (context, state) => InkWell(
                                  onTap: ()=>showHeights(context,index,false,true,false),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * (1 / 100),horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].widthUnit??tr(LocalKeys.cm),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          size: 24,
                                          color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                          child: Text(
                            tr(LocalKeys.length),
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
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: TextEditingController(text: BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].length),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
                                  ],
                                  validator: (v){
                                    if(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].length == null){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    if(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].length.trim().isEmpty){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    if(double.parse(BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].length)<=0.0){
                                      return tr(LocalKeys.this_field_cant_be_empty_or_less_than)+' 0';
                                    }
                                    return null;
                                  },
                                  onChanged: (value){
                                    if(!value .replaceFirst('.','').contains('.')){
                                      BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].length = value;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: tr(LocalKeys.length),
                                    hintStyle: TextStyle(fontSize: 11),
                                    focusedBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                            borderSide: BorderSide(color: Colors.black, width: 2)),
                                  ),
                                ),
                              ),
                              BlocBuilder<NewOrderBloc, NewOrderStates>(
                                builder: (context, state) => InkWell(
                                  onTap: ()=>showHeights(context,index,false,false,true),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * (1 / 100),horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].lengthUnit??tr(LocalKeys.cm),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          size: 24,
                                          color: rgboOrHex(Config
                                                  .get.styling[Config.get.themeMode].primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (4.4 / 100),
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                child: Text(
                  tr(LocalKeys.description),
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        minLines: 3,
                        maxLines: null,
                        onChanged: (value){
                          BlocProvider.of<NewOrderBloc>(context).packageWidgets[index].description = value;
                        },
                        decoration: InputDecoration(
                          hintText: tr(LocalKeys.description),
                          hintStyle: TextStyle(fontSize: 11),
                          focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                  borderSide: BorderSide(color: Colors.black, width: 2)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (4.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildThird() {
    return Builder(
      builder: (context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * (3.9 / 100),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: Text(
                tr(LocalKeys.shipment_info),
                style: TextStyle(
                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (1.9 / 100),
            ),
            BlocBuilder<NewOrderBloc, NewOrderStates>(
              builder: (context, state) =>Container(
                padding:
                EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (2.1 / 100)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Text(
                                  tr(LocalKeys.shipment_type),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (0.9 / 100),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Text(
                                  BlocProvider.of<NewOrderBloc>(context).isPickup?tr(LocalKeys.pickup):tr(LocalKeys.dropOff),
                                  style: TextStyle(
                                    // color: rgboOrHex(Config
                                    //         .get.styling[Config.get.themeMode].color),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Text(
                                  tr(LocalKeys.sender_address),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (0.9 / 100),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Text(
                                  BlocProvider.of<NewOrderBloc>(context).senderAddress.address,
                                  style: TextStyle(
                                    // color: rgboOrHex(Config
                                    //         .get.styling[Config.get.themeMode].color),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (4 / 100),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Text(
                                  tr(LocalKeys.receiver),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (0.9 / 100),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Text(
                                  BlocProvider.of<NewOrderBloc>(context).receiverModel.receiver_name,
                                  style: TextStyle(
                                    // color: rgboOrHex(Config
                                    //         .get.styling[Config.get.themeMode].color),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Text(
                                  tr(LocalKeys.receiver_address),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * (0.9 / 100),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                child: Text(
                                  BlocProvider.of<NewOrderBloc>(context).receiverAddress.address,
                                  style: TextStyle(
                                    // color: rgboOrHex(Config
                                    //         .get.styling[Config.get.themeMode].color),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (3.9 / 100),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: Text(
                tr(LocalKeys.shipment_info),
                style: TextStyle(
                  color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (1.9 / 100),
            ),
            BlocBuilder<NewOrderBloc, NewOrderStates>(
              builder: (context, state) => Column(
                children: [
                  ...BlocProvider.of<NewOrderBloc>(context).packageWidgets
                          .asMap().map((key, value) => MapEntry(
                    value, Card(
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                      child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *(2.1 / 100)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * (2 / 100),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        tr(LocalKeys.category),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * (0.9 / 100),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        value.packageModel?.name??'',
                                        style: TextStyle(
                                          // color: rgboOrHex(Config
                                          //         .get.styling[Config.get.themeMode].color),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        tr(LocalKeys.quantity),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * (0.9 / 100),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        value.quantity??'',
                                        style: TextStyle(
                                          // color: rgboOrHex(Config
                                          //         .get.styling[Config.get.themeMode].color),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * (4 / 100),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        tr(LocalKeys.weight),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * (0.9 / 100),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        (value.weight??'') +( value.weightUnit??''),
                                        style: TextStyle(
                                          // color: rgboOrHex(Config
                                          //         .get.styling[Config.get.themeMode].color),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        tr(LocalKeys.height),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * (0.9 / 100),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        (value.height??'' )+ (value.heightUnit??''),
                                        style: TextStyle(
                                          // color: rgboOrHex(Config
                                          //         .get.styling[Config.get.themeMode].color),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * (4 / 100),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        tr(LocalKeys.width),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * (0.9 / 100),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        (value.width??'' )+( value.widthUnit??''),
                                        style: TextStyle(
                                          // color: rgboOrHex(Config
                                          //         .get.styling[Config.get.themeMode].color),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        tr(LocalKeys.length),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * (0.9 / 100),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        (value.length??'' )+ (value.lengthUnit??''),
                                        style: TextStyle(
                                          // color: rgboOrHex(Config
                                          //         .get.styling[Config.get.themeMode].color),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * (4 / 100),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        tr(LocalKeys.description),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * (0.9 / 100),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      child: Text(
                                        value.description??'',
                                        style: TextStyle(
                                          // color: rgboOrHex(Config
                                          //         .get.styling[Config.get.themeMode].color),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * (4.1 / 100),
                          ),
                        ],
                      ),
                  ),
                    ),
                  )).values.toList()
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (1.9 / 100),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (8.1 / 100)),
              child: MainButton(
                borderColor: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                borderRadius: 0,
                onPressed: () {
                  BlocProvider.of<NewOrderBloc>(context).add(CreateNewOrderEvent());
                },
                text: tr(LocalKeys.placeOrder),
                textColor: rgboOrHex(Config.get.styling[Config.get.themeMode].buttonTextColor),
                color: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (2.1 / 100),
            ),
          ],
        ),
      ),
    );
  }

  showAddresses(BuildContext context, bool isSender) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: BlocProvider.of<NewOrderBloc>(blocContext).addresses.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    if (isSender) {
                      BlocProvider.of<NewOrderBloc>(blocContext).senderAddress =
                          BlocProvider.of<NewOrderBloc>(blocContext).addresses[index];
                      BlocProvider.of<NewOrderBloc>(blocContext)
                          .add(SetSenderAddressNewOrderEvent());
                    } else {
                      BlocProvider.of<NewOrderBloc>(blocContext).receiverAddress =
                          BlocProvider.of<NewOrderBloc>(blocContext).addresses[index];
                      BlocProvider.of<NewOrderBloc>(blocContext)
                          .add(SetReceiverAddressNewOrderEvent());
                    }
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                    child: Text(BlocProvider.of<NewOrderBloc>(blocContext).addresses[index].address),
                  ),
                ),
              ),
              MaterialButton(
                 color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                    vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.cancel)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  showReceiverAddresses(BuildContext context, bool isSender) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: BlocProvider.of<NewOrderBloc>(blocContext).receiverAddresses.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    if (isSender) {
                      BlocProvider.of<NewOrderBloc>(blocContext).senderAddress =
                          BlocProvider.of<NewOrderBloc>(blocContext).receiverAddresses[index];
                      BlocProvider.of<NewOrderBloc>(blocContext)
                          .add(SetSenderAddressNewOrderEvent());
                    } else {
                      BlocProvider.of<NewOrderBloc>(blocContext).receiverAddress =
                          BlocProvider.of<NewOrderBloc>(blocContext).receiverAddresses[index];
                      BlocProvider.of<NewOrderBloc>(blocContext)
                          .add(SetReceiverAddressNewOrderEvent());
                    }
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                    child: Text(BlocProvider.of<NewOrderBloc>(blocContext).receiverAddresses[index].address),
                  ),
                ),
              ),
              MaterialButton(
 color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                    vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.cancel)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  showBranches(BuildContext context, bool isSender) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: BlocProvider.of<NewOrderBloc>(blocContext).branches.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    BlocProvider.of<NewOrderBloc>(blocContext).selectedBranch = BlocProvider.of<NewOrderBloc>(blocContext).branches[index];
                    BlocProvider.of<NewOrderBloc>(blocContext).add(SetBranchNewOrderEvent());
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                        BlocProvider.of<NewOrderBloc>(blocContext).branches[index].name),
                  ),
                ),
              ),
              MaterialButton(
 color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                    vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.cancel)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  showDeliveryTimes(BuildContext context, bool isSender) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: BlocProvider.of<NewOrderBloc>(blocContext).deliveryTimes.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    BlocProvider.of<NewOrderBloc>(blocContext).selectedDeliveryTime = BlocProvider.of<NewOrderBloc>(blocContext).deliveryTimes[index];
                    BlocProvider.of<NewOrderBloc>(blocContext).add(SetBranchNewOrderEvent());
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                        BlocProvider.of<NewOrderBloc>(blocContext).deliveryTimes[index].name),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  showReceivers(BuildContext context) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: BlocProvider.of<NewOrderBloc>(blocContext).receivers.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    BlocProvider.of<NewOrderBloc>(blocContext).receiverModel =
                    BlocProvider.of<NewOrderBloc>(blocContext).receivers[index];
                    BlocProvider.of<NewOrderBloc>(blocContext).add(SetReceiverNewOrderEvent());
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: Text(BlocProvider.of<NewOrderBloc>(blocContext).receivers[index].receiver_name),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * (1 / 100),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: Text(BlocProvider.of<NewOrderBloc>(blocContext).receivers[index].receiver_mobile),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                 color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                    vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.cancel)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  showPackages(BuildContext context, int packageIndex) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: BlocProvider.of<NewOrderBloc>(blocContext).packages.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    print('ttttttttttt');
                    BlocProvider.of<NewOrderBloc>(blocContext).packageWidgets[packageIndex].packageModel = BlocProvider.of<NewOrderBloc>(blocContext).packages[index];
                    BlocProvider.of<NewOrderBloc>(blocContext).add(SetPackageNewOrderEvent());
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                    child: Text(BlocProvider.of<NewOrderBloc>(blocContext).packages[index].name),
                  ),
                ),
              ),
              MaterialButton(
                 color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                    vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.cancel)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  showPaymentTypes(BuildContext context) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: BlocProvider.of<NewOrderBloc>(blocContext).paymentMethods.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    print('ttttttttttt');
                    BlocProvider.of<NewOrderBloc>(blocContext).paymentMethodModel = BlocProvider.of<NewOrderBloc>(blocContext).paymentMethods[index];
                    BlocProvider.of<NewOrderBloc>(blocContext).add(SetPaymentNewOrderEvent());
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                     child: Text(BlocProvider.of<NewOrderBloc>(blocContext).paymentMethods[index].name),
                  ),
                ),
              ),
              MaterialButton(
 color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                    vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.cancel)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  showPaymentMethods(BuildContext context) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: AppKeys.paymentMethods.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    print('ttttttttttt');
                    BlocProvider.of<NewOrderBloc>(blocContext).paymentType = AppKeys.paymentMethods[index];
                    BlocProvider.of<NewOrderBloc>(blocContext).add(SetPaymentMethodNewOrderEvent());
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                    child: Text(AppKeys.paymentMethods[index]==AppKeys.PREPAID?tr(LocalKeys.prepaid):tr(LocalKeys.postpaid)),
                  ),
                ),
              ),
              MaterialButton(
 color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                    vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.cancel)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  showWeights(BuildContext context, int currentIndex) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: AppKeys.weights.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    BlocProvider.of<NewOrderBloc>(blocContext).packageWidgets[currentIndex].weightUnit =AppKeys.weights[index];
                    BlocProvider.of<NewOrderBloc>(blocContext).add(SetSenderAddressNewOrderEvent());
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                    child: Text(AppKeys.weights[index]),
                  ),
                ),
              ),
              MaterialButton(
               color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                    vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.cancel)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  showHeights(BuildContext context, int currentIndex,bool isHeight,bool isWidth,bool isLength) async {
    final blocContext = context;
    await showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: AppKeys.heights.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    if(isHeight){
                      BlocProvider.of<NewOrderBloc>(blocContext).packageWidgets[currentIndex].heightUnit =AppKeys.heights[index];
                    }
                    if(isWidth){
                      BlocProvider.of<NewOrderBloc>(blocContext).packageWidgets[currentIndex].widthUnit =AppKeys.heights[index];
                    }
                    if(isLength){
                      BlocProvider.of<NewOrderBloc>(blocContext).packageWidgets[currentIndex].lengthUnit =AppKeys.heights[index];
                    }

                    BlocProvider.of<NewOrderBloc>(blocContext).add(SetSenderAddressNewOrderEvent());
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                    child: Text(AppKeys.heights[index]),
                  ),
                ),
              ),
              MaterialButton(
 color: rgboOrHex(Config.get.styling[Config.get.themeMode].dividerColor),
                elevation: 0,
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
                    vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
                child: Container(
                  width: double.infinity,
                  child: Text(tr(LocalKeys.cancel)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * (3.4 / 100),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }
}
