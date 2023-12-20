import 'dart:io';

import 'package:flutter/material.dart';
import 'package:send/model/user_model.dart';
import 'package:send/services/auth_service.dart';
import 'package:send/services/storage_service.dart';
import 'package:send/view/widgets/image_picker_widget.dart';
import 'package:send/view/widgets/text_field_widget.dart';

class RegisterProfileScreen extends StatefulWidget {
  const RegisterProfileScreen({Key? key}) : super(key: key);

  @override
  _RegisterProfileScreenState createState() => _RegisterProfileScreenState();
}

class _RegisterProfileScreenState extends State<RegisterProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController imagePath = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final credentials =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ImagePickerWidget(imagePath: imagePath),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidget(hint: "nombre", controller: nameController),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
                onPressed: () async {
                  String imageUrl = "";

                  if (imagePath.text.isNotEmpty) {
                    imageUrl = await StorageService().saveProfilePhoto(
                        File(imagePath.text), credentials["email"]!);
                  }

                  Map<String, dynamic> response = await AuthService()
                      .registerUser(
                          UserModel(
                              name: nameController.text,
                              email: credentials["email"]!,
                              imageUrl: imageUrl),
                          credentials["password"]!);

                  if (response["success"]) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/chats',
                      (route) => false,
                    );
                  }
                },
                child: const Text("continuar"))
          ],
        ),
      ),
    );
  }
}
