import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:score_app/widgets/preDataRow.dart';

import '../backend/database.dart';
import '../constants/constants.dart';

class DoublePreDataList extends StatefulWidget {
  const DoublePreDataList({super.key});

  @override
  State<DoublePreDataList> createState() => _DoublePreDataListListState();
}

class _DoublePreDataListListState extends State<DoublePreDataList> {
  List<Map<String, dynamic>> arrayData = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> getSingleData() async {
    CollectionReference collectionRef = firestore.collection('scores');

    try {
      DocumentSnapshot documentSnapshot =
          await collectionRef.doc('double').get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? documentData =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (documentData != null) {
          setState(() {
            arrayData =
                List<Map<String, dynamic>>.from(documentData['preData']);
          });

          // Use the arrayData as needed
        }
      }
    } catch (e) {
      print('error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSingleData();
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
