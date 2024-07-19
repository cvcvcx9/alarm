import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'GroupAlarm.dart';

class GroupAlarmStorage {
  static const String prefix = '__group_alarm__';
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveGroupAlarm(GroupAlarm groupAlarm) async {
    await prefs.setString('$prefix${groupAlarm.groupId}', json.encode(groupAlarm.toJson()));
  }

  static Future<void> removeGroupAlarm(int groupId) async {
    await prefs.remove('$prefix$groupId');
  }

  static GroupAlarm? getGroupAlarm(int groupId) {
    final jsonString = prefs.getString('$prefix$groupId');
    if (jsonString != null) {
      return GroupAlarm.fromJson(json.decode(jsonString) as Map<String, dynamic>);
    }
    return null;
  }

  static List<GroupAlarm> getAllGroupAlarms() {
    final keys = prefs.getKeys().where((key) => key.startsWith(prefix)).toList();
    List<GroupAlarm> groupAlarms = [];
    for (var key in keys) {
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        groupAlarms.add(GroupAlarm.fromJson(json.decode(jsonString) as Map<String, dynamic>));
      }
    }
    return groupAlarms;
  }
}
