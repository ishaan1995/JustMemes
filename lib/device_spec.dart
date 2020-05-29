import 'package:flutter/material.dart';

Size deviceSpec;

void setDeviceSpec(BuildContext context) {
  deviceSpec = MediaQuery.of(context).size;
}