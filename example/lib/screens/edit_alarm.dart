import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm_example/util/GroupAlarm.dart';
import 'package:alarm_example/util/periodic_alarms.dart';
import 'package:alarm_example/widgets/weekdayButton.dart';
import 'package:flutter/material.dart';

class AlarmEditScreen extends StatefulWidget {
  const AlarmEditScreen({super.key, this.groupAlarm,this.alarmWeekDays});

  final GroupAlarm? groupAlarm;
  final List<int>? alarmWeekDays;
  @override
  State<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  bool loading = false;

  late bool creating;
  late DateTime selectedDateTime;
  late List<int> selectedWeekdays;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late String assetAudio;

  @override
  void initState() {
    super.initState();
    creating = widget.groupAlarm == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      selectedWeekdays = [];
      loopAudio = true;
      vibrate = true;
      volume = null;
      assetAudio = 'assets/marimba.mp3';
    } else {
      selectedWeekdays = widget.groupAlarm!.getGroupAlarmWeekDays();
      selectedDateTime = widget.groupAlarm!.alarms[0].dateTime;
      loopAudio = widget.groupAlarm!.alarms[0].loopAudio;
      vibrate = widget.groupAlarm!.alarms[0].vibrate;
      volume = widget.groupAlarm!.alarms[0].volume;
      assetAudio = widget.groupAlarm!.alarms[0].assetAudioPath;
    }
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      case 2:
        return 'After tomorrow';
      default:
        return 'In $difference days';
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now();
        selectedDateTime = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  // AlarmSettings buildAlarmSettings() {
  //   final id = creating
  //       ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
  //       : widget.groupAlarm!.groupId;
  //
  //   final alarmSettings = AlarmSettings(
  //     id: id,
  //     dateTime: selectedDateTime,
  //     loopAudio: loopAudio,
  //     vibrate: vibrate,
  //     volume: volume,
  //     assetAudioPath: assetAudio,
  //     notificationTitle: 'Alarm example',
  //     notificationBody: 'Your alarm ($id) is ringing',
  //     enableNotificationOnKill: Platform.isIOS,
  //   );
  //   return alarmSettings;
  // }

  void saveAlarm() async{
    if (loading) return;
    setState(() => loading = true);


    await periodicAlarms(widget.groupAlarm?.groupId,selectedWeekdays, selectedDateTime.hour, selectedDateTime.minute,"알람입니다.","알람입니다.",assetAudio)
    .then((res){
      if (res) Navigator.pop(context,true);
      setState(() {
        loading = false;
      });
    });
    // Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
    //   if (res) Navigator.pop(context, true);
    //   setState(() => loading = false);
    // });
  }

  void deleteAlarm() {

    widget.groupAlarm?.removeGroupAlarm().then((res) {
      if (res) {
        Navigator.pop(context, true);
      }
    });
  }

  void _toggleDay(int value) {
    setState(() {
      if (selectedWeekdays.contains(value)) {
        selectedWeekdays.remove(value);
      } else {
        selectedWeekdays.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: saveAlarm,
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(
                        'Save',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.blueAccent),
                      ),
              ),
            ],
          ),
          Text(
            getDay(),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.blueAccent.withOpacity(0.8)),
          ),
          RawMaterialButton(
            onPressed: pickTime,
            fillColor: Colors.grey[200],
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                TimeOfDay.fromDateTime(selectedDateTime).format(context),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.blueAccent),
              ),
            ),
          ),
          WeekdayButtons(selectedValues: selectedWeekdays,toggleDay: _toggleDay),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loop alarm audio',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: loopAudio,
                onChanged: (value) => setState(() => loopAudio = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vibrate',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: vibrate,
                onChanged: (value) => setState(() => vibrate = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sound',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: assetAudio,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'assets/marimba.mp3',
                    child: Text('Marimba'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/nokia.mp3',
                    child: Text('Nokia'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/mozart.mp3',
                    child: Text('Mozart'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/star_wars.mp3',
                    child: Text('Star Wars'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/one_piece.mp3',
                    child: Text('One Piece'),
                  ),
                ],
                onChanged: (value) => setState(() => assetAudio = value!),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Custom volume',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: volume != null,
                onChanged: (value) =>
                    setState(() => volume = value ? 0.5 : null),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            child: volume != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        volume! > 0.7
                            ? Icons.volume_up_rounded
                            : volume! > 0.1
                                ? Icons.volume_down_rounded
                                : Icons.volume_mute_rounded,
                      ),
                      Expanded(
                        child: Slider(
                          value: volume!,
                          onChanged: (value) {
                            setState(() => volume = value);
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          if (!creating)
            TextButton(
              onPressed: deleteAlarm,
              child: Text(
                'Delete Alarm',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}
