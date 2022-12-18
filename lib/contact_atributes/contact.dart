// {"contact_id":"6160a332-bc6b-41d6-989c-d33a0363c091","email":"xihoh55496@dineroa.com","firstname":"irshad",
// "lastname":"ahmed","mobile":"9997776666","dob":"2022-06-22T00:00:00.000Z","contact_address_line_1":"address1",
// "contact_address_line_2":"address2","city":null,"county_id":null,"country_id":null,"isactive":true,"role":1,"role_name":"Admin"}

import 'package:flutter/material.dart';

import 'role.dart';
import 'address.dart';
import 'name.dart';

class Contact {
  final String id, email;
  final String? mobile;
  final Name name;
  final DateTime? birthday;
  final Address address;
  final bool isActive;
  final Role role;

  Contact({
    required this.id,
    required this.email,
    this.mobile,
    required this.name,
    this.birthday,
    required this.address,
    this.isActive = false,
    required this.role,
  });

  factory Contact.fromJson(Map json) {
    DateTime? birthday;
    try {
      birthday = json['dob'] != null ? DateTime.tryParse(json['dob']) : null;
    } catch (e) {
      // dob not provided or parsing issue
    }
    return Contact(
      id: json['contact_id'],
      email: json['email'],
      mobile: json['mobile'],
      name: Name.fromJson(json),
      birthday: birthday,
      address: Address.fromJson(json),
      isActive: json['isactive'] ?? false,
      role: Role.values[json['role']],
    );
  }

  Widget getAvatar({double? iconSize}) {
    String avatarText = name.isUnknownName
        ? email.substring(0, 1)
        : '${name.firstName?.substring(0, 1)} ${name.lastName?.substring(0, 1)}'.trim();
    return Container(
      height: iconSize ?? 50,
      width: iconSize ?? 50,
      decoration: BoxDecoration(
        color: const Color(0xFF1A62C6),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          avatarText.toUpperCase(),
          style: TextStyle(
            fontSize: iconSize ?? 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String get displayName => name.isUnknownName ? email : name.displayName;
}
