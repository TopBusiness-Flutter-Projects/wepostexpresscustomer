import 'package:conditional_builder/conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wepostexpresscustomer/components/my_form_field.dart';
import 'package:wepostexpresscustomer/components/step_tracker.dart';
import 'package:wepostexpresscustomer/ui/create_mission/bloc/create_mission_bloc.dart';
import 'package:wepostexpresscustomer/ui/create_mission/bloc/create_mission_events.dart';
import 'package:wepostexpresscustomer/ui/create_mission/bloc/create_mission_states.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/app_keys.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CreateMissionScreen extends StatelessWidget {
  TextEditingController addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateMissionBloc>(
      create: (BuildContext context) =>
          di<CreateMissionBloc>()..add(FetchCreateMissionEvent()),
      child: BlocListener<CreateMissionBloc, CreateMissionStates>(
        listener: (BuildContext context, CreateMissionStates state) async {
          if (state is ErrorCreateMissionState) {
            showToast(state.error, false);
          }

          if (state is LoadingCreatingMissionState) {
            showProgressDialog(context);
          }

          if (state is MissionCreatedSuccessfullyMissionState) {
            Navigator.pop(context);
            Navigator.pop(context);
            showToast(tr(LocalKeys.mission_created_successfully), true);
          }
        },
        child: SafeArea(
          child: Scaffold(
            body: Form(
              key: formKey,
              child: BlocBuilder<CreateMissionBloc, CreateMissionStates>(
                builder: (context, state) => Column(
                  children: [
                    if (BlocProvider.of<CreateMissionBloc>(context)
                        .errorOccurred)
                      Container(
                        color: Colors.redAccent,
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width *
                                (6.4 / 100)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                tr(LocalKeys.server_error),
                                style: TextStyle(
                                  color: rgboOrHex(Config
                                      .get
                                      .styling[Config.get.themeMode]
                                      .buttonTextColor),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 100,
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.02,
                                  vertical: MediaQuery.of(context).size.height *
                                      0.01),
                              alignment: Alignment.bottomCenter,
                              child: TextButton(
                                onPressed: () {
                                  BlocProvider.of<CreateMissionBloc>(context)
                                      .add(FetchCreateMissionEvent());
                                },
                                child: Text(
                                  tr(LocalKeys.retry),
                                  style: TextStyle(
                                    color: rgboOrHex(Config
                                        .get
                                        .styling[Config.get.themeMode]
                                        .buttonTextColor),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      color: rgboOrHex(
                          Config.get.styling[Config.get.themeMode].primary),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height *
                                (1.2 / 100),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.height *
                                    (1.2 / 100),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height *
                                    (5.91 / 100),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: rgboOrHex(Config
                                        .get
                                        .styling[Config.get.themeMode]
                                        .buttonTextColor),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    tr(LocalKeys.create_mission),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: rgboOrHex(Config
                                          .get
                                          .styling[Config.get.themeMode]
                                          .buttonTextColor),
                                    ),
                                  ),
                                ),
                              ),
                              BlocBuilder<CreateMissionBloc,
                                  CreateMissionStates>(
                                builder: (context, state) => Container(
                                  width: MediaQuery.of(context).size.height *
                                      (5.91 / 100),
                                  height: MediaQuery.of(context).size.height *
                                      (5.91 / 100),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.done,
                                      size: 30,
                                      color: rgboOrHex(Config
                                          .get
                                          .styling[Config.get.themeMode]
                                          .buttonTextColor),
                                    ),
                                    onPressed: () {
                                      formKey.currentState.save();
                                      if (formKey.currentState.validate()) {
                                        BlocProvider.of<CreateMissionBloc>(
                                                context)
                                            .address = addressController.text;
                                        BlocProvider.of<CreateMissionBloc>(
                                                context)
                                            .add(CreateMissionEvent());
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height *
                                (1.2 / 100),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ConditionalBuilder(
                        condition: state is! LoadingCreateMissionState,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            child: Column(
                              children: [
                                Card(
                                  elevation: 10,
                                  shadowColor: Color(0xffF7F7FB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              (4.2 / 100),
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              (2.4 / 100)),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (6.4 / 100)),
                                        child: TextFormField(
                                          controller: addressController,
                                          validator: (v) {
                                            if (v == null || v.isEmpty) {
                                              return tr(LocalKeys
                                                  .this_field_cant_be_empty);
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            hintText: tr(LocalKeys.address),
                                            hintStyle: TextStyle(fontSize: 14),
                                            focusedBorder: UnderlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(0.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 2)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                (1.4 / 100),
                                      ),
                                      // BlocBuilder<CreateMissionBloc, CreateMissionStates>(
                                      //     builder: (context, state) => MyFormField(
                                      //         padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      //         context: context,
                                      //         error: tr(LocalKeys.this_field_cant_be_empty),
                                      //         hasError: BlocProvider.of<CreateMissionBloc>(context).selectedBranch == null,
                                      //         child: InkWell(
                                      //             onTap: () {
                                      //                 return showBranches(context, true);
                                      //             },
                                      //             child: Padding(
                                      //                 padding: EdgeInsets.symmetric(
                                      //                         horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
                                      //                 child: Column(
                                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                                      //                     children: [
                                      //                         Row(
                                      //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //                             children: [
                                      //                                 Padding(
                                      //                                     padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * (1 / 100)),
                                      //                                     child: Text(
                                      //                                         tr(LocalKeys.branch),
                                      //                                         style: TextStyle(
                                      //                                             color: Colors.grey,
                                      //                                             fontWeight: FontWeight.w600,
                                      //                                             fontSize: 13,
                                      //                                         ),
                                      //                                     ),
                                      //                                 ),
                                      //                             ],
                                      //                         ),
                                      //                         Row(
                                      //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //                             children: [
                                      //                                 Text(
                                      //                                     BlocProvider.of<CreateMissionBloc>(context).selectedBranch != null
                                      //                                             ? BlocProvider.of<CreateMissionBloc>(context)
                                      //                                             .selectedBranch
                                      //                                             .name
                                      //                                             : tr(LocalKeys.branch),
                                      //                                     style: TextStyle(fontSize: 14),
                                      //                                 ),
                                      //                                 Icon(
                                      //                                     Icons.arrow_drop_down,
                                      //                                     size: 24,
                                      //                                     color: rgboOrHex(Config
                                      //                                             .get.styling[Config.get.themeMode].primary),
                                      //                                 ),
                                      //                             ],
                                      //                         ),
                                      //                         SizedBox(
                                      //                             height: MediaQuery.of(context).size.height * (0.9 / 100),
                                      //                         ),
                                      //                         Container(
                                      //                             height: 1,
                                      //                             color: rgboOrHex(Config.get.styling[Config.get.themeMode].secondary),
                                      //                             width: double.infinity,
                                      //                         ),
                                      //                     ],
                                      //                 ),
                                      //             ),
                                      //         ),
                                      //     ),
                                      // ),
                                      // SizedBox(
                                      //     height: MediaQuery.of(context).size.height * (1.4 / 100),
                                      // ),
                                      BlocBuilder<CreateMissionBloc,
                                          CreateMissionStates>(
                                        builder: (context, state) =>
                                            MyFormField(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (6.4 / 100)),
                                          context: context,
                                          error: tr(LocalKeys
                                              .this_field_cant_be_empty),
                                          hasError: false,
                                          child: InkWell(
                                            onTap: () {
                                              return showMissionTypes(
                                                  context, true);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          (6.4 / 100)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                (1 / 100)),
                                                        child: Text(
                                                          tr(LocalKeys
                                                              .mission_type),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        tr(AppKeys.getMissionType(
                                                            BlocProvider.of<
                                                                        CreateMissionBloc>(
                                                                    context)
                                                                .missionType)),
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_drop_down,
                                                        size: 24,
                                                        color: rgboOrHex(Config
                                                            .get
                                                            .styling[Config
                                                                .get.themeMode]
                                                            .primary),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            (0.9 / 100),
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    color: rgboOrHex(Config
                                                        .get
                                                        .styling[Config
                                                            .get.themeMode]
                                                        .secondary),
                                                    width: double.infinity,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                (1.4 / 100),
                                      ),
                                      BlocBuilder<CreateMissionBloc,
                                          CreateMissionStates>(
                                        builder: (context, state) =>
                                            MyFormField(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (6.4 / 100)),
                                          context: context,
                                          error: tr(LocalKeys
                                              .this_field_cant_be_empty),
                                          hasError: false,
                                          child: InkWell(
                                            onTap: () {
                                              return showPaymentMethods(
                                                context,
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          (6.4 / 100)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                (1 / 100)),
                                                        child: Text(
                                                          tr(LocalKeys
                                                              .paymentMethod),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        BlocProvider.of<CreateMissionBloc>(
                                                                        context)
                                                                    .paymentMethod !=
                                                                null
                                                            ? BlocProvider.of<
                                                                        CreateMissionBloc>(
                                                                    context)
                                                                .paymentMethod
                                                                .name
                                                            : tr(LocalKeys
                                                                .paymentMethod),
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_drop_down,
                                                        size: 24,
                                                        color: rgboOrHex(Config
                                                            .get
                                                            .styling[Config
                                                                .get.themeMode]
                                                            .primary),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            (0.9 / 100),
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    color: rgboOrHex(Config
                                                        .get
                                                        .styling[Config
                                                            .get.themeMode]
                                                        .secondary),
                                                    width: double.infinity,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                (2.4 / 100),
                                      ),
                                    ],
                                  ),
                                ),
                                BlocBuilder<CreateMissionBloc,
                                    CreateMissionStates>(
                                  builder: (context, state) =>
                                      ConditionalBuilder(
                                    condition:
                                        BlocProvider.of<CreateMissionBloc>(
                                                    context)
                                                .missionType ==
                                            AppKeys.PICKUP_TYPE,
                                    builder: (context) => ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          BlocProvider.of<CreateMissionBloc>(
                                                  context)
                                              .pickShipments
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        print(
                                            'BlocProvider.of<CreateMissionBloc>(context).checkedShipments[index]');
                                        print(
                                            BlocProvider.of<CreateMissionBloc>(
                                                    context)
                                                .pickShipments[index]);
                                        final bool canAdd = ((BlocProvider.of<
                                                            CreateMissionBloc>(
                                                        context)
                                                    .checkedShipments
                                                    .length ==
                                                0) ||
                                            (BlocProvider.of<CreateMissionBloc>(
                                                            context)
                                                        .pickShipments[index]
                                                        .payment_type ==
                                                    BlocProvider.of<CreateMissionBloc>(
                                                            context)
                                                        .pickShipments
                                                        .first
                                                        .payment_type) &&
                                                (BlocProvider.of<CreateMissionBloc>(
                                                            context)
                                                        .pickShipments[index]
                                                        .payment_method_id ==
                                                    BlocProvider.of<CreateMissionBloc>(
                                                            context)
                                                        .checkedShipments
                                                        .first
                                                        .payment_method_id));
                                        return Row(
                                          children: [
                                            IgnorePointer(
                                              ignoring: !canAdd,
                                              child: Checkbox(
                                                value: BlocProvider.of<
                                                            CreateMissionBloc>(
                                                        context)
                                                    .checkedShipments
                                                    .contains(BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .pickShipments[index]),
                                                onChanged: (v) {
                                                  if (v) {
                                                    print(BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .pickShipments[index]);
                                                    BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .checkedShipments
                                                        .add(BlocProvider.of<
                                                                    CreateMissionBloc>(
                                                                context)
                                                            .pickShipments[index]);
                                                    BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .add(
                                                            CheckedShipmentCreateMissionEvent());
                                                  } else {
                                                    BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .checkedShipments
                                                        .remove(BlocProvider.of<
                                                                    CreateMissionBloc>(
                                                                context)
                                                            .pickShipments[index]);
                                                    BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .add(
                                                            CheckedShipmentCreateMissionEvent());
                                                  }
                                                },
                                                fillColor:
                                                    MaterialStateProperty.all(
                                                        rgboOrHex(Config
                                                                .get
                                                                .styling[Config
                                                                    .get
                                                                    .themeMode]
                                                                .primary)
                                                            .withOpacity(canAdd
                                                                ? 1.0
                                                                : 0.50)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (2.2 / 100),
                                            ),
                                            Expanded(
                                              child: Card(
                                                elevation: 10,
                                                shadowColor: Color(0xffF7F7FB),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            (2.4 / 100)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              (4.2 / 100),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    (4.2 / 100),
                                                              ),
                                                              Text(
                                                                BlocProvider.of<CreateMissionBloc>(
                                                                            context)
                                                                        .pickShipments[
                                                                            index]
                                                                        .code +
                                                                    '  [' +
                                                                    BlocProvider.of<CreateMissionBloc>(
                                                                            context)
                                                                        .shipments[
                                                                            index]
                                                                        .type +
                                                                    ']',
                                                                style:
                                                                    TextStyle(
                                                                  color: rgboOrHex(Config
                                                                      .get
                                                                      .styling[Config
                                                                          .get
                                                                          .themeMode]
                                                                      .primary),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .redAccent,
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        15.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15.0)),
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    (5.0 / 100),
                                                            vertical: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                (2.0 / 100),
                                                          ),
                                                          child: Text(
                                                            tr(AppKeys.getShipmentStatus(int.parse(BlocProvider.of<
                                                                            CreateMissionBloc>(
                                                                        context)
                                                                    .shipments[
                                                                        index]
                                                                    .status_id ??
                                                                '0'))),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              (2.2 / 100)) /
                                                          3,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              (4.2 / 100),
                                                        ),
                                                        Expanded(
                                                            child: StepTracker(
                                                          title: BlocProvider
                                                                  .of<CreateMissionBloc>(
                                                                      context)
                                                              .pickShipments[
                                                                  index]
                                                              .from_address
                                                              .address,
                                                          icon: null,
                                                          isLast: false,
                                                        )),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              (4.2 / 100),
                                                        ),
                                                        Expanded(
                                                          child: StepTracker(
                                                            title: BlocProvider
                                                                    .of<CreateMissionBloc>(
                                                                        context)
                                                                .pickShipments[
                                                                    index]
                                                                .reciver_address,
                                                            icon: null,
                                                            isLast: true,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              (1.2 / 100),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  (4.2 / 100)),
                                                      width: double.infinity,
                                                      child: Text(
                                                        BlocProvider.of<
                                                                    CreateMissionBloc>(
                                                                context)
                                                            .paymentTypes
                                                            .firstWhere(
                                                                (element) {
                                                          return element.id
                                                                  .toString() ==
                                                              BlocProvider.of<
                                                                          CreateMissionBloc>(
                                                                      context)
                                                                  .pickShipments[
                                                                      index]
                                                                  .payment_method_id
                                                                  .toString();
                                                        }).name,
                                                        style: TextStyle(
                                                          color: rgboOrHex(Config
                                                              .get
                                                              .styling[Config
                                                                  .get
                                                                  .themeMode]
                                                              .secondary),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              (4.2 / 100),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (2.2 / 100),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    fallback: (context) => ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          BlocProvider.of<CreateMissionBloc>(
                                                  context)
                                              .deliveryShipments
                                              .length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final bool canAdd = ((BlocProvider.of<
                                                            CreateMissionBloc>(
                                                        context)
                                                    .checkedShipments
                                                    .length ==
                                                0) ||
                                            (BlocProvider.of<CreateMissionBloc>(context)
                                                        .deliveryShipments[
                                                            index]
                                                        .payment_type ==
                                                    BlocProvider.of<CreateMissionBloc>(context)
                                                        .deliveryShipments
                                                        .first
                                                        .payment_type) &&
                                                (BlocProvider.of<CreateMissionBloc>(context)
                                                        .deliveryShipments[
                                                            index]
                                                        .type ==
                                                    BlocProvider.of<CreateMissionBloc>(
                                                            context)
                                                        .deliveryShipments
                                                        .first
                                                        .type));
                                        return Row(
                                          children: [
                                            IgnorePointer(
                                              ignoring: !canAdd,
                                              child: Checkbox(
                                                value: BlocProvider.of<
                                                            CreateMissionBloc>(
                                                        context)
                                                    .checkedShipments
                                                    .contains(BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .deliveryShipments[index]),
                                                onChanged: (v) {
                                                  if (v) {
                                                    print(BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .deliveryShipments[index]);
                                                    BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .checkedShipments
                                                        .add(BlocProvider.of<
                                                                    CreateMissionBloc>(
                                                                context)
                                                            .deliveryShipments[index]);
                                                    BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .add(
                                                            CheckedShipmentCreateMissionEvent());
                                                  } else {
                                                    BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .checkedShipments
                                                        .remove(BlocProvider.of<
                                                                    CreateMissionBloc>(
                                                                context)
                                                            .deliveryShipments[index]);
                                                    BlocProvider.of<
                                                                CreateMissionBloc>(
                                                            context)
                                                        .add(
                                                            CheckedShipmentCreateMissionEvent());
                                                  }
                                                },
                                                fillColor:
                                                    MaterialStateProperty.all(
                                                        rgboOrHex(Config
                                                                .get
                                                                .styling[Config
                                                                    .get
                                                                    .themeMode]
                                                                .primary)
                                                            .withOpacity(canAdd
                                                                ? 1.0
                                                                : 0.50)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (2.2 / 100),
                                            ),
                                            Expanded(
                                              child: Card(
                                                elevation: 10,
                                                shadowColor: Color(0xffF7F7FB),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            (2.4 / 100)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              (4.2 / 100),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    (4.2 / 100),
                                                              ),
                                                              Text(
                                                                BlocProvider.of<CreateMissionBloc>(
                                                                            context)
                                                                        .shipments[
                                                                            index]
                                                                        .code +
                                                                    '  [' +
                                                                    BlocProvider.of<CreateMissionBloc>(
                                                                            context)
                                                                        .shipments[
                                                                            index]
                                                                        .type +
                                                                    ']',
                                                                style:
                                                                    TextStyle(
                                                                  color: rgboOrHex(Config
                                                                      .get
                                                                      .styling[Config
                                                                          .get
                                                                          .themeMode]
                                                                      .primary),
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .redAccent,
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        15.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15.0)),
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    (5.0 / 100),
                                                            vertical: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                (2.0 / 100),
                                                          ),
                                                          child: Text(
                                                            tr(AppKeys.getShipmentStatus(int.parse(BlocProvider.of<
                                                                            CreateMissionBloc>(
                                                                        context)
                                                                    .deliveryShipments[
                                                                        index]
                                                                    .status_id ??
                                                                '0'))),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              (2.2 / 100)) /
                                                          3,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              (4.2 / 100),
                                                        ),
                                                        Expanded(
                                                            child: StepTracker(
                                                          title: BlocProvider
                                                                  .of<CreateMissionBloc>(
                                                                      context)
                                                              .deliveryShipments[
                                                                  index]
                                                              .from_address
                                                              .address,
                                                          icon: null,
                                                          isLast: false,
                                                        )),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              (4.2 / 100),
                                                        ),
                                                        Expanded(
                                                          child: StepTracker(
                                                            title: BlocProvider
                                                                    .of<CreateMissionBloc>(
                                                                        context)
                                                                .deliveryShipments[
                                                                    index]
                                                                .reciver_address,
                                                            icon: null,
                                                            isLast: true,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              (1.2 / 100),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  (4.2 / 100)),
                                                      width: double.infinity,
                                                      child: Text(
                                                        BlocProvider.of<
                                                                    CreateMissionBloc>(
                                                                context)
                                                            .paymentTypes
                                                            .elementAt(index)
                                                            .name,
                                                        // BlocProvider.of<CreateMissionBloc>(context).paymentTypes.firstWhere((element) {
                                                        //     return element.id.toString()== BlocProvider.of<CreateMissionBloc>(context).deliveryShipments[index].payment_method_id.toString();
                                                        // }).name,
                                                        style: TextStyle(
                                                          color: rgboOrHex(Config
                                                              .get
                                                              .styling[Config
                                                                  .get
                                                                  .themeMode]
                                                              .secondary),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              (4.2 / 100),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (2.2 / 100),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        fallback: (context) => Container(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  CircularProgressIndicator(),
                                  Spacer(),
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
        ),
      ),
    );
  }

  // showBranches(BuildContext context, bool isSender) async {
  //     final blocContext = context;
  //     await showMaterialModalBottomSheet(
  //         backgroundColor: Colors.transparent,
  //         context: context,
  //         builder: (context) => Container(
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                     topRight: Radius.circular(20),
  //                     topLeft: Radius.circular(20),
  //                 ),
  //                 color: Colors.white,
  //             ),
  //             child: SingleChildScrollView(
  //                 child: Column(
  //                     children: [
  //                         ListView.builder(
  //                             shrinkWrap: true,
  //                             physics: NeverScrollableScrollPhysics(),
  //                             itemCount: BlocProvider.of<CreateMissionBloc>(blocContext).branches.length,
  //                             itemBuilder: (context, index) => MaterialButton(
  //                                 onPressed: () {
  //                                     BlocProvider.of<CreateMissionBloc>(blocContext).selectedBranch = BlocProvider.of<CreateMissionBloc>(blocContext).branches[index];
  //                                     BlocProvider.of<CreateMissionBloc>(blocContext).add(SetBranchCreateMissionEvent());
  //                                     Navigator.pop(context);
  //                                 },
  //                                 padding: EdgeInsets.symmetric(
  //                                         horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
  //                                         vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
  //                                 child: Container(
  //                                     width: double.infinity,
  //                                     child: Text(
  //                                             BlocProvider.of<CreateMissionBloc>(blocContext).branches[index].name),
  //                                 ),
  //                             ),
  //                         ),
  //                         MaterialButton(
  //                             onPressed: () => Navigator.pop(context),
  //                             padding: EdgeInsets.symmetric(
  //                                     horizontal: MediaQuery.of(context).size.width * (6.4 / 100),
  //                                     vertical: MediaQuery.of(context).size.width * (3.4 / 100)),
  //                             child: Container(
  //                                 width: double.infinity,
  //                                 child: Text(tr(LocalKeys.cancel)),
  //                             ),
  //                         ),
  //                         SizedBox(
  //                             height: MediaQuery.of(context).size.width * (3.4 / 100),
  //                         ),
  //                     ],
  //                 ),
  //             ),
  //         ),
  //     );
  // }

  showMissionTypes(BuildContext context, bool isSender) async {
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
                itemCount: AppKeys.missionTypes.length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    BlocProvider.of<CreateMissionBloc>(blocContext)
                        .missionType = AppKeys.missionTypes[index];
                    BlocProvider.of<CreateMissionBloc>(blocContext)
                        .checkedShipments
                        .clear();
                    BlocProvider.of<CreateMissionBloc>(blocContext)
                        .add(SetBranchCreateMissionEvent());
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical:
                          MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                    child: Text(tr(
                        AppKeys.getMissionType(AppKeys.missionTypes[index]))),
                  ),
                ),
              ),
              MaterialButton(
                color: rgboOrHex(
                    Config.get.styling[Config.get.themeMode].dividerColor),
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
                itemCount: BlocProvider.of<CreateMissionBloc>(blocContext)
                    .paymentTypes
                    .length,
                itemBuilder: (context, index) => MaterialButton(
                  onPressed: () {
                    BlocProvider.of<CreateMissionBloc>(blocContext)
                            .paymentMethod =
                        BlocProvider.of<CreateMissionBloc>(blocContext)
                            .paymentTypes[index];
                    BlocProvider.of<CreateMissionBloc>(blocContext)
                        .add(SetPaymentMethodCreateMissionEvent());
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width * (6.4 / 100),
                      vertical:
                          MediaQuery.of(context).size.width * (3.4 / 100)),
                  child: Container(
                    width: double.infinity,
                    child: Text(BlocProvider.of<CreateMissionBloc>(blocContext)
                        .paymentTypes[index]
                        .name),
                  ),
                ),
              ),
              MaterialButton(
                color: rgboOrHex(
                    Config.get.styling[Config.get.themeMode].dividerColor),
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
  }
}
