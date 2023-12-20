import 'package:flutter/material.dart';
import 'package:send/model/user_model.dart';
import 'package:send/services/auth_service.dart';
import 'package:send/view/widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Image(image: AssetImage("assets/logo.png"), width: 100),
            const SizedBox(
              height: 20,
            ),
            Text(
              "hola ${user.name}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidget(hint: "contraseña", controller: passwordController),
            const SizedBox(
              height: 10,
            ),
            FilledButton(
                onPressed: () async {
                  Map<String, dynamic> response = await AuthService()
                      .loginUser(user.email, passwordController.text);

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
