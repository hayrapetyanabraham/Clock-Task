import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:moxielabs/const/colors.dart';
import 'package:moxielabs/helper/storage_helper.dart';
import 'package:moxielabs/main.dart';

class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage({Key key}) : super(key: key);

  @override
  _AddAlarmPageState createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  var _time = const TimeOfDay(hour: 7, minute: 15);
  final dateFormat = DateFormat('yyyy-MM-dd');
  var _date = DateTime.now();

  Future<void> _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  void _selectDate() async {
    final DateTime newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: AppColors.white,
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 1,
      title: _buildTitle(),
      leading: _buildLeading(),
    );
  }

  Widget _buildLeading() {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 28,
        color: AppColors.black,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Add alarm',
      style: TextStyle(
          fontSize: 18,
          color: AppColors.black,
          fontFamily: 'Hind',
          fontWeight: FontWeight.w700),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _selectDate,
            style:
                ElevatedButton.styleFrom(primary: AppColors.azure // background
                    ),
            child: const Text('SELECT DATE'),
          ),
          const SizedBox(height: 8),
          _buildDate(DateFormat("yyyy, MMM, d").format(_date)),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: _selectTime,
            style:
                ElevatedButton.styleFrom(primary: AppColors.azure // background
                    ),
            child: const Text('SELECT TIME'),
          ),
          const SizedBox(height: 8),
          _buildDate(_time.format(context)),
          const SizedBox(
            height: 40,
          ),
          _buildAddAlarmButton(),
        ],
      ),
    );
  }

  Widget _buildDate(String date) {
    return Text(
      date,
      style: const TextStyle(
          fontSize: 18,
          color: AppColors.black,
          fontFamily: 'Hind',
          fontWeight: FontWeight.w700),
    );
  }

  Widget _buildAddAlarmButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: OutlinedButton(
            onPressed: () {
              _scheduleAlarm();
            },
            style: ElevatedButton.styleFrom(
              onPrimary: AppColors.azure,
              onSurface: AppColors.azure,
              primary: AppColors.azure,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text('Add alarm',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    fontSize: 14))),
      ),
    );
  }

  void _scheduleAlarm() async {
    try {
      var scheduledNotificationDateTime = DateTime(
          _date.year, _date.month, _date.day, _time.hour, _time.minute);
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'alarm_notif',
        'alarm_notif',
        color: Colors.blue,
        playSound: true,
        icon: 'app_icon',
        sound: RawResourceAndroidNotificationSound('alarm'),
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      );
      var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
          sound: "alarm.wav",
          presentAlert: true,
          presentBadge: true,
          presentSound: true);
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(0, 'Office', 'Good day',
          scheduledNotificationDateTime, platformChannelSpecifics);
      await StorageHelper.setAlarmList(
          scheduledNotificationDateTime.toString());
      _showSuccessMessage('Alarm Added', 'Success');
    } catch (e) {
      _showErrorMessage(e.message, 'Error');
    }
  }

  _showErrorMessage(String message, String title) {
    Future.delayed(const Duration(milliseconds: 0), () {
      FlushbarHelper.createError(
        message: message,
        title: title,
        duration: const Duration(seconds: 3),
      ).show(context);
    });
    return const SizedBox.shrink();
  }

  _showSuccessMessage(String message, String title) {
    Future.delayed(const Duration(milliseconds: 0), () {
      FlushbarHelper.createSuccess(
        message: message,
        title: title,
        duration: const Duration(seconds: 3),
      ).show(context);
    });
    Navigator.of(context).pop();
    return const SizedBox.shrink();
  }
}
