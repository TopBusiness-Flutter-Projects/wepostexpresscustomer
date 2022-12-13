import 'dart:convert';
import 'dart:io';

class AuthResponse {
    AuthResponse({
        this.error,
        this.token_type,
        this.email,
        this.api_token,
        this.expires_at,
        this.user,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    Map<String, String> toJson() {
        return {

        };
    }

    static fromJson(user) {
        List<String> list = [];
        if(user['email'] != null){
            list = [];
            for(int index= 0; index < (user['email'] as List).length;index++){
                list.add((user['email'] as List)[index]);
            }
        }
        print('listlistlist');
        print(list);

        AuthResponse authResponse = AuthResponse(
            expires_at: user['expires_at'],
            token_type: user['token_type'],
            user: user['user'],
            email: list,
            api_token: user['api_token'],
            error: user['error']??user['message'],
        );
        print('dddasds');
        print(authResponse);
        print(authResponse);
        return authResponse;
    }

    final String expires_at;
    final String api_token;
    final List<String> email;
    final String token_type;
    final String error;
    Map user;
}
