import 'dart:convert';
import 'dart:io';

class MissionModel {
    MissionModel(
            {this.client_id,
      this.address,
      this.to_branch_id,
      this.status_id,
      this.type,
      this.updated_at,
      this.created_at,
      this.id,
      this.code});

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'client_id': client_id,
            'address': address,
            'to_branch_id': to_branch_id,
            'status_id': status_id,
            'type': type,
            'updated_at': updated_at,
            'created_at': created_at,
            'id': id,
            'code': code,
        };
    }

    static fromJson(user) {
        return MissionModel(
            client_id: user['client_id'].toString(),
            address: user['address'].toString(),
            to_branch_id: user['to_branch_id'].toString(),
            status_id: user['status_id'].toString(),
            type: user['type'].toString(),
            updated_at: user['updated_at'].toString(),
            created_at: user['created_at'].toString(),
            id: user['id'].toString(),
            code: user['code'].toString(),
        );
    }

    final String client_id;
    final String address;
    final String to_branch_id;
    final String status_id;
    final String type;
    final String updated_at;
    final String created_at;
    final String id;
    final String code;
}

