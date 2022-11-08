import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoạt động'),
        backgroundColor: Color(0x55fa5555),
      ),
      body: Center(
        child: Text(
          'Hoạt động',
          style: TextStyle(
              fontSize: 40
          ),
        ),
      ),
    );
  }
}