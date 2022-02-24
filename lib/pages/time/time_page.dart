import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:intl/intl.dart';
import 'package:moxielabs/const/colors.dart';
import 'package:timer_builder/timer_builder.dart';

class TimePage extends StatefulWidget {
  const TimePage({Key key}) : super(key: key);

  @override
  _TimePageState createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  final DateTime _currentDate = DateTime.now();
  int _timeTypeIndex = 0;

  @override
  void initState() {
    super.initState();
    Stream.periodic(const Duration(seconds: 1), (i) {
      return _currentDate.add(const Duration(seconds: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeSelector(),
        if (_timeTypeIndex == 0) ...[
          SizedBox(height: 200, child: _buildClock()),
        ] else ...[
          SizedBox(
            height: 200,
            child: TimerBuilder.periodic(const Duration(seconds: 1),
                builder: (context) {
              return Text(
                getSystemTime(),
                style: const TextStyle(
                    color: AppColors.azure,
                    fontSize: 50,
                    fontWeight: FontWeight.w700),
              );
            }),
          ),
        ]
      ],
    ));
  }

  String getSystemTime() {
    var now = DateTime.now();
    return DateFormat("H:m:s").format(now);
  }

  Widget _buildClock() {
    return const FlutterAnalogClock();
  }

  Widget _buildTimeSelector() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: CupertinoSlidingSegmentedControl<int>(
        backgroundColor: AppColors.white,
        thumbColor: AppColors.pineTree,
        padding: const EdgeInsets.all(8),
        groupValue: _timeTypeIndex,
        children: {
          0: _buildSegment("Analog"),
          1: _buildSegment("Digital"),
        },
        onValueChanged: (value) {
          setState(() {
            _timeTypeIndex = value;
          });
        },
      ),
    );
  }

  Widget _buildSegment(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 22, color: AppColors.monsoon),
    );
  }
}
