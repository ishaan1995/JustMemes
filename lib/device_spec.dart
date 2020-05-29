import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Size deviceSpec;

void setDeviceSpec(BuildContext context) {
  deviceSpec = MediaQuery.of(context).size;
}

Future<bool> showTutorial() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    var result = prefs.getBool('showTutorial');
    if (result == null) {
      return true;
    }
    return result;
  } catch(error) {
    print(error);
    return true;
  }
}

Future<void> setShowTutorial(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('showTutorial', value);
}