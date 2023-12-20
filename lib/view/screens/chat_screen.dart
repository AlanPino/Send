import 'package:flutter/material.dart';
import 'package:send/model/message_model.dart';
import 'package:send/model/user_model.dart';
import 'package:send/services/database_service.dart';
import 'package:send/view/widgets/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController message = TextEditingController();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final friend = args["friend"] as ChatPreviewModel;
    final currentUser = args["user"] as UserModel;
    Stream<List<MessageModel>> messages =
        DatabaseService().getMessages(friend.email);

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(friend.imageUrl),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(friend.name)
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 60),
                child: StreamBuilder(
                    stream: messages,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: MessageWidget(
                                message: snapshot.data![index],
                                currentUser: currentUser,
                              ),
                            );
                          },
                        );
                      }
                    }),
              ),
              Positioned(
                bottom: 0,
                height: 50,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 10,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.attach_file_sharp)),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                hintText: "nuevo mensaje"),
                            controller: message,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              DatabaseService()
                                    .sendMessage(message.text, friend.email);
                                message.text = "";

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOut,
                                );
                              });
                            },
                            icon: const Icon(Icons.send))
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
