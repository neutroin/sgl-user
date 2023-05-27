import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class PreDataRow extends StatefulWidget {
  String time;
  String A;
  String B;
  String C;
  PreDataRow(
      {super.key,
      required this.time,
      required this.A,
      required this.B,
      required this.C});

  @override
  State<PreDataRow> createState() => _PreDataRowState();
}

class _PreDataRowState extends State<PreDataRow> {
  TextStyle firstTextStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 26);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              widget.time,
              style: firstTextStyle,
            ),
          ),
          Text(
            widget.A,
            style: firstTextStyle,
          ),
          Text(
            widget.B,
            style: firstTextStyle,
          ),
          Text(
            widget.C,
            style: firstTextStyle,
          )
        ],
      ),
    );
  }
}
