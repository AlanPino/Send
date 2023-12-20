import 'package:flutter/material.dart';
import 'package:send/model/message_model.dart';
import 'package:send/model/user_model.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  final UserModel currentUser;

  const MessageWidget({super.key, required this.message, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: message.user == currentUser.email ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Card(
            color: message.user == currentUser.email ? Colors.white: Colors.deepPurple.shade200,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30),
                    topRight: const Radius.circular(30),
                    bottomLeft: message.user == currentUser.email ? const Radius.circular(30) : const Radius.circular(0),
                    bottomRight: message.user == currentUser.email ? const Radius.circular(0) : const Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(message.content),
            ),
          ),
          Text(
            "${message.time.hour}:${message.time.minute}",
            style: const TextStyle(fontSize: 10),
          )
        ],
      );
  }
}
