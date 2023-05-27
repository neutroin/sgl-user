import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:score_app/constants/constants.dart';

class DatabaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Future<void> getSingleData() async {
  //   CollectionReference collectionRef = firestore.collection('scores');

  //   try {
  //     DocumentSnapshot documentSnapshot =
  //         await collectionRef.doc('single').get();
  //     if (documentSnapshot.exists) {
  //       Map<String, dynamic>? documentData =
  //           documentSnapshot.data() as Map<String, dynamic>?;
  //       if (documentData != null) {
  //         List<Map<String, dynamic>> arrayData =
  //             List<Map<String, dynamic>>.from(documentData['preData']);

  //         arrayData = List<Map<String, dynamic>>.from(documentData['preData']);

  //         print(arrayData);

  //         // Use the arrayData as needed
  //       }
  //     }
  //   } catch (e) {
  //     print('error');
  //   }
  // }
}
