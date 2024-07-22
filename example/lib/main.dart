import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm_example/screens/home.dart';
import 'package:alarm_example/screens/loginScreen.dart';
import 'package:alarm_example/util/GroupAlarmStoarge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GroupAlarmStorage.init();
  await Alarm.init();

  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: false),
      home: const ExampleAlarmHomeScreen(),
    ),
  );
}
