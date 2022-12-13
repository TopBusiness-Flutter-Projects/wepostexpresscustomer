import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:wepostexpresscustomer/models/package_model.dart';

import 'new_order/address_new_order.dart';

class CreateOrderModel {
  CreateOrderModel(
      {@required this.shipment_type,
      @required this.shipment_branch_id,
      @required this.shipment_shipping_date,
      @required this.shipment_client_phone,
      @required this.shipment_client_address,
      @required this.shipment_reciver_name,
      @required this.shipment_client_lat,
      @required this.shipment_client_lng,
      @required this.shipment_client_street_address_map,
      @required this.shipment_client_url,
      @required this.delivery_time,
      @required this.shipment_reciver_street_address_map,
      @required this.shipment_reciver_lat,
      @required this.shipment_reciver_lng,
      @required this.shipment_reciver_url,
      @required this.shipment_reciver_phone,
      @required this.shipment_reciver_address,
      @required this.amount_to_be_collected,
      @required this.shipment_from_country_id,
      @required this.shipment_to_country_id,
      @required this.shipment_from_state_id,
      @required this.shipment_to_state_id,
      @required this.shipment_payment_type,
      @required this.shipment_payment_method_id,
      @required this.packages});

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
      Map<String,String> shipmentPackages={};
      print('shipment_client_phone');
      print(shipment_client_phone);
      for (var index = 0; index <packages.length; index++) {
          print('shipmentsssss');
          print(packages[index].packageModel.toJson());
        shipmentPackages.addAll({
            'Package[$index][description]': packages[index].description??'',
            'Package[$index][package_id]': packages[index].packageModel.id,
            'Package[$index][qty]': packages[index].quantity??'',
            'Package[$index][weight]': packages[index].weight??'',
            'Package[$index][length]': packages[index].length??'',
            'Package[$index][width]': packages[index].width??'',
            'Package[$index][height]': packages[index].height??'',
        });
      }
      shipmentPackages.addAll({
          'Shipment[type]': shipment_type,
          'Shipment[branch_id]': shipment_branch_id,
          'Shipment[shipping_date]': shipment_shipping_date,
          'Shipment[client_phone]': shipment_client_phone,
          'Shipment[delivery_time]': delivery_time,
          'Shipment[client_address]': shipment_client_address,
          'Shipment[reciver_name]': shipment_reciver_name,
          'Shipment[reciver_phone]': shipment_reciver_phone,
          'Shipment[reciver_address]': shipment_reciver_address,
          'Shipment[amount_to_be_collected]': amount_to_be_collected,
          'Shipment[from_country_id]': shipment_from_country_id,
          'Shipment[to_country_id]': shipment_to_country_id,
          'Shipment[from_state_id]': shipment_from_state_id,
          'Shipment[to_state_id]': shipment_to_state_id,
          'Shipment[payment_type]': shipment_payment_type,
          'Shipment[payment_method_id]': shipment_payment_method_id,
          'Shipment[reciver_street_address_map]': shipment_reciver_street_address_map,
          'Shipment[reciver_lat]': shipment_reciver_lat,
          'Shipment[reciver_lng]': shipment_reciver_lng,
          'Shipment[reciver_url]': shipment_reciver_url,
          'Shipment[client_street_address_map]': shipment_reciver_street_address_map,
          'Shipment[client_lat]': shipment_reciver_lat,
          'Shipment[client_lng]': shipment_reciver_lng,
          'Shipment[client_url]': shipment_reciver_url,
      });
    return shipmentPackages;
  }

  // static fromJson(user) {
  //   return CreateOrderModel();
  // }

  final String shipment_type;
  final String shipment_branch_id;
  final String shipment_shipping_date;
  final String shipment_client_phone;
  final String shipment_client_address;
  final String delivery_time;
  final String shipment_reciver_name;
  final String shipment_reciver_phone;
  final String shipment_reciver_address;
  final String shipment_from_country_id;
  final String shipment_to_country_id;
  final String shipment_from_state_id;
  final String shipment_to_state_id;
  final String amount_to_be_collected;
  final String shipment_reciver_street_address_map;
  final String shipment_reciver_lat;
  final String shipment_reciver_lng;
  final String shipment_reciver_url;
  final String shipment_client_street_address_map;
  final String shipment_client_lat;
  final String shipment_client_lng;
  final String shipment_client_url;
  final String shipment_payment_type;
  final String shipment_payment_method_id;
  final List<AddressOrderModel> packages;
}
