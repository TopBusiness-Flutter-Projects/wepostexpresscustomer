import 'dart:convert';
import 'dart:io';

import 'package:wepostexpresscustomer/models/user/user_model.dart';

class NotificationModel {
    NotificationModel({
        this.sender,
        this.created_at,
        this.subject,
        this.id,
        this.code,
        this.content,
        this.url,
        this.icon,
        this.type,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    Map<String, String> toJson() {
        return  {
            'sender': sender.toString(),
            'code': code,
            'subject': subject,
            'created_at': created_at,
            'id': id,
            'content': content,
            'url': url,
            'icon': icon,
            'type': type,
        };
    }

    static fromJson(user) {
        print('userfromJson');
        print(user);
        return NotificationModel(
            sender: user['sender'],
            subject: user['message']['subject'].toString(),
            id: user['message']['id'].toString(),
            content: user['message']['content'].toString(),
            url: user['message']['url'].toString(),
            code: user['message']['code'],
            icon: user['icon'].toString(),
            type: user['type'].toString(),
            created_at: user['created_at'],
        );
    }

    final int sender;
    final String subject;
    final String created_at;
    final String id;
    final String content;
    final String url;
    final String icon;
    final String type;
    final String code;
}
/*
{
        "data": {
            "message": {
                "subject": "There is update shipment",
                "content": "Please check the a shipment which is just updated right now!",
                "url": "your_base_url/admin/shipments/12",
                "id": 12,
                "code": "AWB00012"
            },
            "icon": "flaticon2-bell-4",
            "type": "update_shipment"
        },
        "created_at": "2021-06-20 12:46:59"
    }
*/