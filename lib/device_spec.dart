import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:funny_memes/rest.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

Size deviceSpec;
Map<String, dynamic> appConfig;
PlatformInfo platformInfo;

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
  } catch (error) {
    print(error);
    return true;
  }
}

Future<void> setShowTutorial(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('showTutorial', value);
}

Future<bool> shouldFetchConfig() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var currentTime = new DateTime.now().millisecondsSinceEpoch;
  var lastFetchedTime = prefs.getInt('lastConfigFetchTime');
  if (lastFetchedTime == null) {
    return true;
  }
  // fetch config once every 6 hours.
  // 1 sec = 1000 millis
  // 1 hrs = 60 mins = 60 * 60 seconds
  const HOURS_6_MILLIS = 1000 * 60 * 60 * 6;
  //const HOURS_6_MILLIS = 1000 * 30; // 30 seconds
  return (currentTime - lastFetchedTime) > HOURS_6_MILLIS;
}

Future<Map<String, dynamic>> getLocalConfig() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var configString = prefs.getString('appConfig');

  if (configString == null) {
    return getDefaultConfig();
  }

  return json.decode(configString);
}

///
/// Get app config.
/// 1. check if last time fetched more than 6 hours ago or not even fetched once.
/// 2. If true => get config. If fails, then use default hard coded config
/// 2. If success, use config and store to local shared prefs. Update last fetched time.
/// 3. If not more than 6 hours, use local prefs config. If missing, use local hard coded config.
///
Future<Map<String, dynamic>> getConfig() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool shouldFetch = await shouldFetchConfig();

  if (shouldFetch) {
    var config = await getAppConfig();
    if (config == null) {
      return getLocalConfig();
    }

    await prefs.setString('appConfig', json.encode(config));

    // set last fetched time to current time
    var currentTime = new DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('lastConfigFetchTime', currentTime);

    return config;
  } else {
    return getLocalConfig();
  }
}

Future<void> setPlatformInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  platformInfo = PlatformInfo(
    appName: packageInfo.appName,
    packageName: packageInfo.packageName,
    version: packageInfo.version,
    buildNumber: int.parse(packageInfo.buildNumber),
  );
}

class PlatformInfo {
  String appName;
  String packageName;
  String version;
  int buildNumber;

  PlatformInfo({
    @required this.appName,
    @required this.packageName,
    @required this.version,
    @required this.buildNumber,
  });

  @override
  String toString() {
    return {
      'appName': appName,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    }.toString();
  }
}
