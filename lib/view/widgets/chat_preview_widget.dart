import 'package:flutter/material.dart';
import 'package:send/model/user_model.dart';

class ChatPreviewWidget extends StatelessWidget {
  final ChatPreviewModel chatPreview;

  const ChatPreviewWidget({Key? key, required this.chatPreview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(chatPreview.imageUrl),
          radius: 40,
        ),
        title: Text(
          chatPreview.name,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        subtitle: Text(
          chatPreview.lastMessage.content,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          "${chatPreview.lastMessage.time.hour}:${chatPreview.lastMessage.time.minute}",
          style: const TextStyle(fontSize: 12),
        ));
  }
}
