import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../contact_atributes/contact.dart';
import '../contact_atributes/invite_contact.dart';

class DataManager extends ChangeNotifier {
  static DataManager mInStance = DataManager._();

  DataManager._() : themeMode = ThemeMode.light;

  factory DataManager() => mInStance;

  final Map<String, Contact> _contacts = {};
  final Map<String, InvitedContact> _invitedContacts = {};
  bool isSyncedOnLaunch = false;
  ThemeMode themeMode;

  List<Contact> get contacts => _contacts.values.toList();

  List<InvitedContact> get invitedContacts => _invitedContacts.values.toList();

  bool get isDarkTheme => themeMode == ThemeMode.dark;

  addContacts(List<Contact> contacts) {
    for (var element in contacts) {
      _contacts.update(
        element.id,
        (value) => element,
        ifAbsent: () => element,
      );
    }
  }

  toggleTheme() {
    themeMode = isDarkTheme ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  addInvitedContacts(List<InvitedContact> contacts) {
    for (InvitedContact contact in contacts) {
      _invitedContacts.update(
        contact.id,
        (value) => contact,
        ifAbsent: () => contact,
      );
    }
  }

  makeAppSynced() {
    isSyncedOnLaunch = true;
    notifyListeners();
  }

  static notify() => mInStance.notifyListeners();
}
