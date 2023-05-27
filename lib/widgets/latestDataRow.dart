import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class UpdatedRow extends StatefulWidget {
  String value;
  UpdatedRow({super.key, required this.value});

  @override
  State<UpdatedRow> createState() => _UpdatedRowState();
}

class _UpdatedRowState extends State<UpdatedRow> {
  TextStyle firstTextStyle =
      TextStyle(fontWeight: FontWeight.bold, color: darkGreen, fontSize: 32);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('scores')
            .doc(widget.value)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('loading...'),
            );
          }
          var latestData = snapshot.data?['latest'];
          var updatedA = latestData['A'];
          var updatedB = latestData['B'];
          var updatedC = latestData['C'];
          var updatedTime = latestData['Time'];
          var updatedDate = latestData['Date'];
          List latestDataValues = [
            updatedTime,
            updatedA,
            updatedB,
            updatedC,
          ];

          return Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    latestDataValues[0],
                    style: firstTextStyle,
                  ),
                ),
                Text(
                  latestDataValues[1],
                  style: firstTextStyle,
                ),
                Text(
                  latestDataValues[2],
                  style: firstTextStyle,
                ),
                Text(
                  latestDataValues[3],
                  style: firstTextStyle,
                )
              ],
            ),
          );
        });
  }
}
