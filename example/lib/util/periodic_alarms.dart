// Let's say we want to set a periodic alarm for each Monday, Wednesday and Friday at 9:41.
// Run this function on app launch when Alarm.init is done.
// It will make sure your periodic alarms are set for the following week.
import 'package:alarm/alarm.dart';
import 'package:alarm_example/util/GroupAlarmStoarge.dart';
import 'package:flutter/material.dart';

import 'GroupAlarm.dart';

//
Future<bool> periodicAlarms(
  int? groupId,List<int> days,
  int hour,
  int minute,
  String notificationTitle,
  String notificationBody,
  String assetAudioPath) async {
  const nbDays = 7; // Number of following days to potentially set alarm
  var time = TimeOfDay(hour: hour, minute: minute); // Time of the periodic alarm
  // Days of the week to set the alarm
  final now = DateTime.now();
  List<AlarmSettings> groupAlarmSettings = [];
// Loop through the next days
  for (var i = 0; i < nbDays; i++) {
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    ).add(Duration(days: i));

    if (days.contains(dateTime.weekday)) {
      final alarmSettings = AlarmSettings(
        id: dateTime.hashCode,
        dateTime: dateTime,
        assetAudioPath: assetAudioPath,
        notificationTitle: notificationTitle,
        notificationBody: notificationBody,
      );
      groupAlarmSettings.add(alarmSettings);
    }
  }
  if(groupId != null){
    GroupAlarmStorage.removeGroupAlarm(groupId);
  }
  GroupAlarm groupAlarm = GroupAlarm(groupId: DateTime.now().millisecondsSinceEpoch, alarms: groupAlarmSettings,notificationTitle: notificationTitle,notificationBody: notificationBody,assetAudioPath: assetAudioPath);
  
  await groupAlarm.setGroupAlarm();
  return true;
}
