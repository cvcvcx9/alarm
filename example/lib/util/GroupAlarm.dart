import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/utils/extensions.dart';

import 'GroupAlarmStoarge.dart';

class GroupAlarm {
  final int groupId;
  final List<AlarmSettings> alarms;
  bool isEnabled;
  String? assetAudioPath;
  String? notificationTitle;
  String? notificationBody;
  String? sessionId;
  String? image;


  GroupAlarm({
    required this.groupId,
    required this.alarms,
    this.isEnabled = true,
    this.assetAudioPath = 'assets/marimba.mp3',
    this.notificationTitle ="알람입니다.",
    this.notificationBody = "알람입니다.",
    this.sessionId = "",
    this.image = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'alarms': alarms.map((alarm) => alarm.toJson()).toList(),
      'isEnabled': isEnabled,
      'assetAudioPath': assetAudioPath,
      'notificationTitle': notificationTitle,
      'notificationBody': notificationBody,
      'sessionId': sessionId,
      'image': image,
    };
  }

  factory GroupAlarm.fromJson(Map<String, dynamic> json) {
    return GroupAlarm(
      groupId: json['groupId'] as int,
      alarms: (json['alarms'] as List)
          .map((alarm) => AlarmSettings.fromJson(alarm as Map<String, dynamic>))
          .toList(),
      isEnabled: json['isEnabled'] as bool,
      assetAudioPath: json['assetAudioPath'] as String?,
      notificationTitle: json['notificationTitle'] as String?,
      notificationBody: json['notificationBody'] as String?,
      sessionId: json['sessionId'] as String?,
      image: json['image'] as String?,
    );
  }

  Future<void> setGroupAlarm() async {
    for (var alarmSettings in alarms) {
      for (final alarm in Alarm.getAlarms()) {
        if (alarm.id == alarmSettings.id ||
            alarm.dateTime.isSameSecond(alarmSettings.dateTime)) {
          await Alarm.stop(alarm.id);
        }
      }
    }

    await GroupAlarmStorage.saveGroupAlarm(this);

    for (var alarmSettings in alarms) {
      await Alarm.set(alarmSettings: alarmSettings);
    }
  }

  Future<bool> removeGroupAlarm() async {
    for (var alarmSettings in alarms) {
      await Alarm.stop(alarmSettings.id);
    }
    await GroupAlarmStorage.removeGroupAlarm(groupId);
    return true;
  }
  // 알람일을 알아낼 수 있는 함수
  List<int> getGroupAlarmWeekDays() {
    List<int> alarmWeekDays = [];
    for (var alarm in this.alarms){
      alarmWeekDays.add(alarm.dateTime.weekday);
    }
    return alarmWeekDays;
  }
  // 토글 버튼으로 알람을 켜고 끄기
  Future<void> toggleGroupAlarm(bool enable) async {
    if (enable) {
      for (var alarmSettings in alarms) {
        await Alarm.set(alarmSettings: alarmSettings);
      }
    } else {
      for (var alarmSettings in alarms) {
        await Alarm.stop(alarmSettings.id);
      }
    }
    isEnabled = enable;
    await GroupAlarmStorage.saveGroupAlarm(this);
  }
}
