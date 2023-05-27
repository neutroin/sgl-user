import 'package:flutter/material.dart';

class TitleRow extends StatefulWidget {
  const TitleRow({super.key});

  @override
  State<TitleRow> createState() => _TitleRowState();
}

class _TitleRowState extends State<TitleRow> {
  TextStyle titleStyle = const TextStyle(
    color: Colors.black,
    fontSize: 26,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 150, height: 40, child: Text('TIME', style: titleStyle)),
          SizedBox(
              height: 40,
              width: 40,
              child: Text('A',
                  style: TextStyle(
                      color: Colors.blueAccent.shade700,
                      fontSize: 24,
                      fontWeight: FontWeight.bold))),
          SizedBox(height: 40, width: 40, child: Text('B', style: titleStyle)),
          SizedBox(
              height: 40,
              width: 40,
              child: Text('C',
                  style: TextStyle(
                      color: Colors.red.shade800,
                      fontSize: 24,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
