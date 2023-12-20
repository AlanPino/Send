import 'package:send/model/message_model.dart';

class UserModel {
  final String name;
  final String email;
  final String imageUrl;

  UserModel({required this.name, required this.email, required this.imageUrl});
}

class ChatPreviewModel extends UserModel{
  final MessageModel lastMessage;

  ChatPreviewModel({required super.name, required super.email, required super.imageUrl, required this.lastMessage, });
}