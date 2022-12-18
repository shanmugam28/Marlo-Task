import 'package:flutter/material.dart';

import 'Role.dart';

class InvitedContact {
  final String id, email;
  final Role role;

  InvitedContact({
    required this.id,
    required this.email,
    required this.role,
  });

  factory InvitedContact.fromJson(Map json) => InvitedContact(
        id: json['invite_id'],
        email: json['email'],
        role: getRoleInstanceByString(json['config_name']),
      );

  factory InvitedContact.onInvitedJson(Map json) => InvitedContact(
        id: json['invite_id'],
        email: json['email'],
        role: Role.values[int.parse(json['role'])],
      );

  Map<String, dynamic> get map => {
        'email': email,
        'role': role.index.toString(),
      };

  Widget getAvatar({double? iconSize}) {
    return Container(
      height: iconSize ?? 45,
      width: iconSize ?? 45,
      decoration: BoxDecoration(
        color: const Color(0xFFAC816E),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          email.substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontSize: iconSize ?? 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
