import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:send/model/message_model.dart';
import 'package:send/model/user_model.dart';
import 'package:send/services/auth_service.dart';
import 'package:send/services/storage_service.dart';

class DatabaseService {
  final db = FirebaseFirestore.instance;

  registerUser(UserModel user) async {
    await db.collection("Users").doc(user.email).set(
        {"name": user.name, "email": user.email, "imageUrl": user.imageUrl});
  }

  Future<UserModel> getUser(String email) async {
    Map<String, dynamic> data = {};
    await db.collection("Users").doc(email).get().then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
    });
    return UserModel(
        name: data["name"], email: data["email"], imageUrl: data["imageUrl"]);
  }

  addFriend(UserModel friend) async {
    UserModel user = await AuthService().getCurrentUserInfo();
    await db
        .collection("Users")
        .doc(user.email)
        .collection("Friends")
        .doc(friend.email)
        .set({
      "name": friend.name,
      "email": friend.email,
      "imageUrl": friend.imageUrl
    });
  }

  Stream<List<UserModel>> getFriends() async* {
    StreamController<List<UserModel>> friendsController =
        StreamController<List<UserModel>>();
    UserModel user = await AuthService().getCurrentUserInfo();

    db
        .collection("Users")
        .doc(user.email)
        .collection("Friends")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<UserModel> friends = [];
      snapshot.docs.forEach((doc) {
        friends.add(UserModel(
          name: doc["name"],
          email: doc["email"],
          imageUrl: doc["imageUrl"],
        ));
      });
      friendsController.add(friends); // Agregar la lista actualizada al stream
    });

    yield* friendsController.stream;
  }

  Future<bool> userExists(String email) async {
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();

    return doc.exists;
  }

  Stream<List<MessageModel>> getMessages(String friendEmail) async* {
    StreamController<List<MessageModel>> messagesController =
        StreamController<List<MessageModel>>();
    UserModel currentUser = await AuthService().getCurrentUserInfo();

    db
        .collection("Users")
        .doc(currentUser.email)
        .collection("Friends")
        .doc(friendEmail)
        .collection("Messages")
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<MessageModel> messages = [];
      snapshot.docs.forEach((doc) {
        messages.add(MessageModel(
            content: doc["message"],
            time: doc["time"].toDate(),
            user: doc["user"]));
      });
      messagesController.add(messages);
    });

    yield* messagesController.stream;
  }

  sendMessage(String message, String friendEmail) async {
    UserModel currentUser = await AuthService().getCurrentUserInfo();
    db
        .collection("Users")
        .doc(currentUser.email)
        .collection("Friends")
        .doc(friendEmail)
        .collection("Messages")
        .doc(DateTime.now().toUtc().toString())
        .set({
      "message": message,
      "time": DateTime.now(),
      "user": currentUser.email
    });
    db
        .collection("Users")
        .doc(friendEmail)
        .collection("Friends")
        .doc(currentUser.email)
        .collection("Messages")
        .doc(DateTime.now().toUtc().toString())
        .set({
      "message": message,
      "time": DateTime.now(),
      "user": currentUser.email
    });
  }

  Future<void> changeProfilePhoto(File file) async {
    UserModel user = await AuthService().getCurrentUserInfo();
    String imageUrl = await StorageService().saveProfilePhoto(file, user.email);

    db.collection("Users").doc(user.email).update({"imageUrl": imageUrl});
  }

  Future<MessageModel> getLastMessage(QueryDocumentSnapshot doc) async {
    UserModel currentUser = await AuthService().getCurrentUserInfo();
    late MessageModel lastMessage;

    db
        .collection("Users")
        .doc(currentUser.email)
        .collection("Friends")
        .doc(doc["email"])
        .collection("Messages")
        .orderBy("time", descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      lastMessage = MessageModel(
          content: querySnapshot.docs.first["message"],
          time: querySnapshot.docs.first["time"],
          user: querySnapshot.docs.first["user"]);
    });

    return lastMessage;
  }
}
