import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:wepostexpresscustomer/components/main_button.dart';
import 'package:wepostexpresscustomer/components/my_form_field.dart';
import 'package:wepostexpresscustomer/components/my_svg.dart';
import 'package:wepostexpresscustomer/models/county_model.dart';
import 'package:wepostexpresscustomer/models/user/user_model.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_bloc.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_events.dart';
import 'package:wepostexpresscustomer/ui/add_new_address/bloc/add_address_states.dart';
import 'package:wepostexpresscustomer/ui/add_new_receiver/bloc/add_receiver_bloc.dart';
import 'package:wepostexpresscustomer/ui/add_new_receiver/bloc/add_receiver_events.dart';
import 'package:wepostexpresscustomer/ui/add_new_receiver/bloc/add_receiver_states.dart';
import 'package:wepostexpresscustomer/ui/home/home_screen.dart';
import 'package:wepostexpresscustomer/ui/login/login_screen.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';
import 'package:wepostexpresscustomer/utils/constants/local_keys.dart';
import 'package:wepostexpresscustomer/utils/di/di.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddReceiverScreen extends StatefulWidget {
  @override
  _AddReceiverScreenState createState() => _AddReceiverScreenState();
}

class _AddReceiverScreenState extends State<AddReceiverScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddReceiverBloc>(
      create: (BuildContext context) => di<AddReceiverBloc>()..add(FetchAddReceiverEvent()),
      child: BlocListener<AddReceiverBloc, AddReceiverStates>(
        listener: (BuildContext context, AddReceiverStates state) async {
          if (state is ErrorAddReceiverState) {
            showToast(state.error, false);
            if(state.canPop){
              Navigator.pop(context);
            }
          }
          if (state is SuccessAddReceiverState) {
            Navigator.pop(context);
          }
          if (state is AddedReceiverSuccessfully) {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=> HomeScreen(false)));
          }
          if (state is LoadingProgressAddReceiverState) {
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (1.2 / 100),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * (6.91 / 100),
                              child: Center(
                                child: Text(
                                  tr(LocalKeys.add_new_receiver),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (1.97 / 100),
                      ),
                      Expanded(
                          child: buildSecond(),
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

  buildSecond() {
    return Builder(
      builder: (context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * (4.9 / 100),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: Text(
                tr(LocalKeys.receiver_name),
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
              child:  TextFormField(
                controller: nameController,
                validator: (v){
                  if(v == null ||v.isEmpty){
                    return tr(LocalKeys.this_field_cant_be_empty);
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: tr(LocalKeys.receiver_name),
                  hintStyle: TextStyle(fontSize: 11),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (2.9 / 100),
            ),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: Text(
                tr(LocalKeys.mobile),
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
              child:  TextFormField(
                controller: mobileController,
                validator: (v){
                  if(v == null ||v.isEmpty){
                    return tr(LocalKeys.this_field_cant_be_empty);
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: tr(LocalKeys.mobile),
                  hintStyle: TextStyle(fontSize: 11),
                  focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                          borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (2.9 / 100),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * (6.1 / 100),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * (6.4 / 100)),
              child: MainButton(
                borderRadius: 0,
                onPressed: () {
                  formKey.currentState.save();
                  if(formKey.currentState.validate()){
                    BlocProvider.of<AddReceiverBloc>(context).receiverName = nameController.text;
                    BlocProvider.of<AddReceiverBloc>(context).receiverEmail = '';
                    BlocProvider.of<AddReceiverBloc>(context).receiverMobile = mobileController.text;
                    BlocProvider.of<AddReceiverBloc>(context).add(
                            SubmitAddReceiverEvent(userModel: UserModel()));
                  }
                },
                text: tr(LocalKeys.add_new_receiver),
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
    );
  }
}
