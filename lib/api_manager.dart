import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:marlo_task/contact_atributes/contact.dart';
import 'package:marlo_task/contact_atributes/invite_contact.dart';

import 'constants.dart';

class ApiManager {
  final Client _client;
  final String _token;

  ApiManager._(this._client, this._token);

  get _header => <String, String>{'authtoken': _token};

  static Future<ApiManager?> getInstance() async {
    Client client = Client();

    Uri uri = Uri.parse(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBFiEDfEaaK6lBtIdxLXspmxGux1TGsCmg');
    Response response = await client.post(
      uri,
      body: {
        'email': "xihoh55496@dineroa.com",
        'password': "Marlo@123",
        'returnSecureToken': 'true',
      },
    );

    debugPrint("ApiManager getInstance: response ${response.statusCode}");
    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['idToken'];
      return ApiManager._(client, token);
    }
    return null;
  }

  Future<Map<String, dynamic>> getPeopleData() async {
    List<Contact> allContacts = [];
    List<InvitedContact> invitedContacts = [];
    Uri uri = Uri.parse(
      'https://asia-southeast1-marlo-bank-dev.cloudfunctions.net/api_dev/company/6dc9858b-b9eb-4248-a210-0f1f08463658/teams',
    );
    Response response = await _client.get(uri, headers: _header);

    debugPrint("ApiManager getPeopleData: result ${response.statusCode} and ${response.body}");

    if (response.statusCode == 200) {
      Map decodedResponse = jsonDecode(response.body);
      if (decodedResponse['error_flag'] == 'SUCCESS') {
        decodedResponse['data']['contacts'].forEach((contact) {
          allContacts.add(Contact.fromJson(contact));
        });
        decodedResponse['data']['invites'].forEach((invite) {
          invitedContacts.add(
            InvitedContact.fromJson(invite),
          );
        });
      }
    }
    return {
      'contacts': allContacts,
      'invitedContacts': invitedContacts,
    };
  }

  Future<ApiResponse<InvitedContact?>> inviteContact(InvitedContact contact) async {
    Uri uri = Uri.parse('https://asia-southeast1-marlo-bank-dev.cloudfunctions.net/api_dev/invites');

    Response response = await _client.post(
      uri,
      headers: _header,
      body: contact.map,
    );

    debugPrint("ApiManager invitePeople: result ${response.statusCode} and ${response.body}");

    Map decodedResponse = jsonDecode(response.body);
    if ([200, 201].contains(response.statusCode)) {
      var json = decodedResponse['data'];
      return ApiResponse.success(data: InvitedContact.onInvitedJson(json));
    } else if (decodedResponse['error_flag'] == 'EMAIL_EXISTS') {
      return ApiResponse.error(error: 'EMAIL_EXISTS');
    } else if (decodedResponse['error'] != null &&
        decodedResponse['error']['message'] == 'email must be a valid email') {
      return ApiResponse.error(error: 'INVALID_EMAIL');
    }
    return ApiResponse.error();
  }
}

class ApiResponse<T> {
  T? data;
  String? error;
  bool status;

  ApiResponse.success({this.data}) : status = true;

  ApiResponse.error({this.error}) : status = false;
}
