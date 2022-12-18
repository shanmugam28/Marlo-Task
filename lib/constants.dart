import 'dart:io';

import 'package:flutter/material.dart';

const accentColor = MaterialColor(0xFF0CABDF, {
  50: Color.fromRGBO(12, 171, 223, .1),
  100: Color.fromRGBO(12, 171, 223, .2),
  200: Color.fromRGBO(12, 171, 223, .3),
  300: Color.fromRGBO(12, 171, 223, .4),
  400: Color.fromRGBO(12, 171, 223, .5),
  500: Color.fromRGBO(12, 171, 223, .6),
  600: Color.fromRGBO(12, 171, 223, .7),
  700: Color.fromRGBO(12, 171, 223, .8),
  800: Color.fromRGBO(12, 171, 223, .9),
  900: Color.fromRGBO(12, 171, 223, 1),
});

const primaryColor = Color(0x00f7f7f7);
const disabledColor = Color(0xFF88919A);

const darkPrimaryColor = Colors.black;

ThemeData theme = ThemeData(
    brightness: Brightness.light,
    accentColor: accentColor,
    primarySwatch: accentColor,
    primaryColor: primaryColor,
    bottomNavigationBarTheme: bottomNavigationBarTheme,
    appBarTheme: const AppBarTheme(
      color: primaryColor,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30.0,
        color: Colors.black,
      ),
      actionsIconTheme: IconThemeData(color: disabledColor),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      elevation: 5,
    ));

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: darkPrimaryColor,
  accentColor: accentColor,
  primarySwatch: accentColor,
  bottomNavigationBarTheme: bottomNavigationBarTheme,
);

BottomNavigationBarThemeData get bottomNavigationBarTheme => const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(
        color: accentColor,
      ),
      selectedItemColor: accentColor,
      selectedLabelStyle: TextStyle(color: accentColor),
      unselectedIconTheme: IconThemeData(color: disabledColor),
      unselectedItemColor: disabledColor,
      unselectedLabelStyle: TextStyle(
        color: disabledColor,
      ),
    );

Future<bool> isNetworkAvailable() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}
