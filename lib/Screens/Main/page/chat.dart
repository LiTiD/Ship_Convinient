import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tin nhắn'),
        backgroundColor: Color(0x55fa5555),
      ),
      body: Center(
        child: Text(
          'Tin nhắn',
          style: TextStyle(
              fontSize: 40
          ),
        ),
      ),
    );
  }
}
