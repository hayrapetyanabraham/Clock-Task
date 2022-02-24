import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:moxielabs/const/colors.dart';
import 'package:moxielabs/helper/storage_helper.dart';
import 'package:moxielabs/pages/alarm/add/add_alarm_page.dart';
import 'package:moxielabs/pages/alarm/list/alarm_list_page.dart';
import 'package:moxielabs/pages/time/time_page.dart';
import 'package:moxielabs/widget/route/route_transition.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  List<String> _alarmList = [];
  var _bottomNavIndex = 0;
  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.access_time,
    Icons.alarm,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });

    _controller.jumpToPage(index);
  }

  final _controller = PageController(
    initialPage: 0,
  );

  getAlarmList() async {
    _alarmList = await StorageHelper.getAlarmList();
    setState(() {});
  }

  void removeAlarm(String date) async {
    await StorageHelper.removeAlarmList(date);
    await getAlarmList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAlarmList();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      const Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.white,
      body: _buildBody(),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return PageView(
      physics: const AlwaysScrollableScrollPhysics(),
      allowImplicitScrolling: true,
      controller: _controller,
      children: <Widget>[
        const TimePage(),
        AlarmListPage(
          listAlarm: _alarmList ?? [],
          onRemoveItem: (value) {
            removeAlarm(value);
          },
        ),
      ],
      onPageChanged: (int page) {},
    );
  }

  Widget _floatingActionButton() {
    return ScaleTransition(
      scale: animation,
      child: FloatingActionButton(
        elevation: 2,
        backgroundColor: AppColors.azure,
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
        onPressed: () {
          _animationController.reset();
          _animationController.forward();
          showAddAlarmPage();
        },
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        final color = isActive ? AppColors.azure : AppColors.monsoon;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconList[index],
              size: 24,
              color: color,
            ),
          ],
        );
      },
      backgroundColor: AppColors.white,
      activeIndex: _bottomNavIndex,
      splashColor: AppColors.white,
      notchAndCornersAnimation: animation,
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.defaultEdge,
      gapLocation: GapLocation.center,
      leftCornerRadius: 4,
      rightCornerRadius: 4,
      onTap: _onItemTapped,
    );
  }

  void showAddAlarmPage() async {
    await Navigator.of(context)
        .push(_createRoute(widgetPage: const AddAlarmPage()));
    await getAlarmList();
    setState(() {});
  }

  Route _createRoute({Widget widgetPage}) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widgetPage,
        transitionsBuilder: bottomToTopTransitionsBuilder);
  }
}
