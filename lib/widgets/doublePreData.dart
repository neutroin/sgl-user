import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:score_app/widgets/preDataRow.dart';

import '../backend/database.dart';
import '../constants/constants.dart';

class DoublePreDataList extends StatefulWidget {
  DateTime selectedDate;
  DoublePreDataList({super.key, required this.selectedDate});

  @override
  State<DoublePreDataList> createState() => _DoublePreDataListState();
}

class _DoublePreDataListState extends State<DoublePreDataList> {
  List<Map<String, dynamic>> arrayData = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void fetchScores(DateTime? selectedDate) {
    final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
    String defaultDate = _dateFormat.format(widget.selectedDate).toString();
    FirebaseFirestore.instance
        .collection('scores')
        .doc('double')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        List<Map<String, dynamic>> allData =
            List<Map<String, dynamic>>.from(documentSnapshot.get('preData'));

        if (widget.selectedDate != null) {
          setState(() {
            arrayData =
                allData.where((data) => data['Date'] == defaultDate).toList();
          });
        } else {
          Fluttertoast.showToast(msg: 'Please select date');
        }
      }
    }).catchError((error) {
      print('Error fetching scores: $error');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchScores(widget.selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: arrayData.length,
      itemBuilder: (context, index) {
        if (arrayData.isEmpty) {
          return const CircularProgressIndicator();
        }
        Map<String, dynamic> item = arrayData[index];

        // Customize the item layout based on your requirements
        return PreDataRow(
            time: item['Time'], A: item['A'], B: item['B'], C: item['C']);
      },
    );
  }
}
