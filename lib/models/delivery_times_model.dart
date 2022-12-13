import 'dart:convert';

class DeliveryTimeModel {
  DeliveryTimeModel({this.id, this.name, this.hours, this.created_at, this.updated_at});

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'hours': hours,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  static fromJson(user) {
    return DeliveryTimeModel(
      id: user['id'].toString(),
      name: user['name'].toString(),
      hours: user['hours'].toString(),
      created_at: user['created_at'].toString(),
      updated_at: user['updated_at'].toString(),
    );
  }

  final String id;
  final String name;
  final String hours;
  final String created_at;
  final String updated_at;
}
