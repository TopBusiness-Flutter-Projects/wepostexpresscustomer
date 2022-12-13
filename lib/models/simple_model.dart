import 'dart:convert';
import 'dart:io';

import 'package:wepostexpresscustomer/models/details_model.dart';

class SimpleModel {
  SimpleModel({
    this.id,
  });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'id': id,
      'status': status,
    };
  }

  static fromJson(user) {
    return SimpleModel(
      id: user['id'],
    );
  }

  bool status;
  bool followed;
  bool favorite;
  bool readed;
  bool password_changed;
  bool user_activated;
  bool blocked;
  int id;
  String error;
  String message;
  DetailsModel user;
}
