import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences._();

  static const alarmList = 'alarmList';
}

class StorageHelper {
  static Future<SharedPreferences> get _instance =>
      SharedPreferences.getInstance();

  static Future<List<String>> getAlarmList() async {
    return (await _instance).getStringList(Preferences.alarmList);
  }

  static Future<void> setAlarmList(String alarm) async {
    var listAlarm = await StorageHelper.getAlarmList();
    listAlarm ??= [];
    listAlarm.add(alarm);
    await (await _instance).setStringList(Preferences.alarmList, listAlarm);
  }

  static Future<void> removeAlarmList(String date) async {
    var listAlarm = await StorageHelper.getAlarmList();
    listAlarm.remove(date);
    await (await _instance).setStringList(Preferences.alarmList, listAlarm);
  }

  static Future<void> removeAll() async {
    await (await _instance).clear();
  }
}
