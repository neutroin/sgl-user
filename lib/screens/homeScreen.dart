import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:score_app/backend/database.dart';
import 'package:score_app/widgets/doublePreData.dart';
import 'package:score_app/widgets/latestDataRow.dart';
import 'package:score_app/widgets/singlePreData.dart';
import 'package:score_app/widgets/titleRow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final List<TimeOfDay> notificationTimes = const [
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 8, minute: 30),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 9, minute: 30),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 10, minute: 30),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 11, minute: 30),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 13, minute: 30),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 14, minute: 30),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 15, minute: 30),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 16, minute: 30),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 17, minute: 30),
    TimeOfDay(hour: 18, minute: 0),
    TimeOfDay(hour: 18, minute: 30),
    TimeOfDay(hour: 19, minute: 0),
    TimeOfDay(hour: 19, minute: 30),
    TimeOfDay(hour: 20, minute: 0),

    // Add more time intervals as needed...
  ];
  void scheduleNotifications(bool switchIsOn) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '0',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Replace with your switch value

    for (var time in notificationTimes) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (switchIsOn && scheduledTime.isAfter(now)) {
        await flutterLocalNotificationsPlugin.periodicallyShow(
          0,
          'Notification Title',
          'Notification Body',
          RepeatInterval.everyMinute,
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
        );
      }
      // Schedule notification after 30 minutes
      final notificationInterval = const Duration(minutes: 30);
      final nextNotificationTime = scheduledTime.add(notificationInterval);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Notification Title',
        'Notification Body',
        tz.TZDateTime.from(nextNotificationTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'customData',
      );
    }
  }

  int _currentIndex = 0;
  List<String> timeList = [];

  String? _selectedDate;

  DateTime? _fetchDate;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      var formatedDate = _dateFormat.format(picked);
      setState(() {
        _selectedDate = formatedDate;
        _fetchDate = picked;
      });
      updateSelectedDate(picked);
      Fluttertoast.showToast(msg: 'Please refresh the page');
      // _saveDateLocally(_selectedDate!);
    }
  }

  void _loadSelectedDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString('selectedDate');
    if (savedDate != null) {
      setState(() {
        _fetchDate = DateTime.parse(savedDate);
      });
    }
  }

  void _saveSelectedDate(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedDate', date.toString());
  }

  void updateSelectedDate(DateTime date) {
    setState(() {
      _saveSelectedDate(date); // Save the selected date when it changes
    });
  }

  //--------------Single-Double-Swith-Bool-------------//
  bool isSingle = true;
  //--------------------------------Refreshing-Indicator--------------------//
  String _selectedOption = 'ON';
  bool switchIsOn = true;
  bool _isRefreshing = false;
  void _showRefreshDialog(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Refreshing...'),
              ],
            ),
          ),
        );
      },
    );

    // Simulate an asynchronous operation
    setState(() {
      _isRefreshing = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog

      setState(() {
        _isRefreshing = false;
      });
    });
  }

  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSelectedDate();

    _pageController = PageController(initialPage: _currentIndex);

    //-------------Notification-------------//
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );
    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          // LocalNotificationService.display(message);

        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: darkYellow,
        elevation: 0.0,
        title: const Text(
          "Shree Ganesh",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Gagalin',
          ),
        ),
        actions: [
          PopupMenuButton<String>(
              icon: Icon(Icons.edit_notifications_outlined),
              tooltip: 'Notification',
              itemBuilder: (context) {
                return [
                  PopupMenuItem<String>(
                    value: 'ON',
                    child: RadioListTile(
                      title: const Text('Notification ON'),
                      value: 'ON',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value.toString();
                          switchIsOn = true;
                        });
                        scheduleNotifications(switchIsOn);
                        Fluttertoast.showToast(
                            msg:
                                'Now you will be notified on every 30 minutes.');
                        Navigator.pop(context, value);
                      },
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'OFF',
                    child: RadioListTile(
                      title: const Text('Notification OFF'),
                      value: 'OFF',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value.toString();
                          switchIsOn = false;
                        });
                        scheduleNotifications(switchIsOn);
                        Fluttertoast.showToast(msg: 'Notification turned off!');
                        Navigator.pop(context, value);
                      },
                    ),
                  )
                ];
              }),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: Colors.red.shade600,
              ),
              GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.substring(0, 10)}'
                            : _dateFormat.format(DateTime.now()),
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  )),
              Icon(
                Icons.arrow_drop_down_rounded,
                color: Colors.red.shade600,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    children: [
                      const TitleRow(),
                      const SizedBox(height: 10),
                      UpdatedRow(
                        value: 'single',
                      ),
                      const SizedBox(height: 10),

                      //----------Data----Title---------//
                      SinglePreDataList(
                          selectedDate: _fetchDate ?? DateTime.now()),
                    ],
                  ),
                  //-----------Doubles---Page-----------------//
                  Column(
                    children: [
                      const TitleRow(),
                      const SizedBox(height: 10),
                      UpdatedRow(
                        value: 'double',
                      ),
                      const SizedBox(height: 10),

                      //----------Data----Title---------//
                      DoublePreDataList(
                        selectedDate: _fetchDate ?? DateTime.now(),
                      ),
                    ],
                  ),
                ]),
          )
        ],
      ),
      //--------Bottom-Navigation-Bar-----------//
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkYellow,
        selectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _showRefreshDialog(index);
          } else {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                _currentIndex,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Single',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Double',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.refresh,
                color: darkGreen,
              ),
            ),
            label: 'Refresh',
          ),
        ],
      ),
    );
  }

  //---------Refreshing-PopUp-----------//

}
