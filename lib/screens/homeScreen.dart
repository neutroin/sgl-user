import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<String> timeList = [];

  String? _selectedDate;
  String? _locallySavedDate;
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
      });
      // _saveDateLocally(_selectedDate!);
    }
  }

  getTimeList() {
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        int displayHour = hour;
        String amPm = 'AM';

        if (displayHour >= 12) {
          displayHour = displayHour == 12 ? 12 : displayHour - 12;
          amPm = 'PM';
        }

        if (displayHour == 0) {
          displayHour = 12;
        }

        String hourString = displayHour.toString().padLeft(2, '0');
        String minuteString = minute.toString().padLeft(2, '0');

        String time = '$hourString:$minuteString $amPm';
        timeList.add(time);
      }
    }
  }

  //------------Shared-Preference----------//
  // _saveDateLocally(String date) async {
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   await _prefs.setString('date', date);
  //   var d = _prefs.getString('date');
  //   setState(() {
  //     _locallySavedDate == d;
  //   });
  // }

  //--------------Single-Double-Swith-Bool-------------//
  bool isSingle = true;
  //--------------------------------Refreshing-Indicator--------------------//
  String _selectedOption = 'ON';
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
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16.0),
                const Text('Refreshing...'),
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
        _currentIndex = 0;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
      );
    });
  }

  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimeList();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          // IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.share,
          //       color: Colors.white,
          //     )),
          // IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.notifications_active,
          //       color: Colors.white,
          //     )),
          PopupMenuButton<String>(
              tooltip: 'Notification',
              itemBuilder: (context) {
                return [
                  PopupMenuItem<String>(
                    value: 'ON',
                    child: RadioListTile(
                      title: const Text('ON'),
                      value: 'ON',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value.toString();
                        });
                        Fluttertoast.showToast(
                            msg:
                                'Now you will be notified on every 15 minutes.');
                        Navigator.pop(context, value);
                      },
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'OFF',
                    child: RadioListTile(
                      title: const Text('OFF'),
                      value: 'OFF',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value.toString();
                        });
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
                            : 'Select date',
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
                      SinglePreDataList(),
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
                      DoublePreDataList(),
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
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              _currentIndex,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
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
