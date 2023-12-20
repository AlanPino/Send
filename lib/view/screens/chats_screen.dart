import 'dart:io';

import 'package:flutter/material.dart';
import 'package:send/model/user_model.dart';
import 'package:send/services/auth_service.dart';
import 'package:send/services/database_service.dart';
import 'package:send/view/widgets/text_field_widget.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  Stream<List<UserModel>> friends = DatabaseService().getFriends();
  TextEditingController friendEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "send",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            popupMenu()
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: StreamBuilder(
                stream: friends,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () async {
                              UserModel currentUser =
                                  await AuthService().getCurrentUserInfo();
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(context, "/chat", arguments: {
                                "friend": snapshot.data![index],
                                "user": currentUser
                              });
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data![index].imageUrl),
                                radius: 40,
                              ),
                              title: Text(
                                snapshot.data![index].name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                            ));
                      },
                    );
                  }
                })),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addFriendDialog();
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.person_add,
            color: Theme.of(context).canvasColor,
          ),
        ));
  }

  popupMenu() {
    return PopupMenuButton(itemBuilder: (BuildContext bc) {
      return [
        PopupMenuItem(
          child: const Text("perfil"),
          onTap: () async {
            UserModel currentUser = await AuthService().getCurrentUserInfo();

            Navigator.pushNamed(context, "/profile", arguments: currentUser)
                .then((value) => {
                      if (value.toString().isNotEmpty)
                        {
                          DatabaseService()
                              .changeProfilePhoto(File(value.toString())),
                        }
                    });
          },
        ),
        PopupMenuItem(
          child: const Text("cerrar sesión"),
          onTap: () async {
            Map<String, dynamic> response = await AuthService().logoutUser();

            if (response["success"]) {
              Navigator.pushReplacementNamed(context, "/registerEmail");
            }
          },
        )
      ];
    });
  }

  addFriendDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Agrega un nuevo amigo"),
            content: TextFieldWidget(
                hint: "correo electronico de amigo", controller: friendEmail),
            actions: [
              FilledButton(
                  onPressed: () async {
                    UserModel friend =
                        await DatabaseService().getUser(friendEmail.text);

                    if (friend.email.isNotEmpty) {
                      setState(() {
                        DatabaseService().addFriend(friend);
                      });
                    }

                    Navigator.of(context).pop();
                  },
                  child: const Text("agregar"))
            ],
          );
        });
  }
}
