import 'package:flutter/material.dart';
import 'package:send/controller/password_controller.dart';
import 'package:send/view/widgets/text_field_widget.dart';

class RegisterPassword extends StatefulWidget {
  const RegisterPassword({Key? key}) : super(key: key);

  @override
  _RegisterPasswordState createState() => _RegisterPasswordState();
}

class _RegisterPasswordState extends State<RegisterPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String error = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    passwordController.addListener(() {
      setState(() {
        error = "";
      });
    });

    confirmPasswordController.addListener(() {
      setState(() {
        error = "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
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
            const Text(
              "crea una contraseña",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 20,
            ),
            PasswordTextFieldWidget(hint: "contraseña", controller: passwordController),
            const SizedBox(
              height: 10,
            ),
            PasswordTextFieldWidget(
                hint: "confirme contraseña",
                controller: confirmPasswordController),
            Text(
              error,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
                onPressed: () {
                  final Map<String, dynamic> response = validatePassword(
                      passwordController.text, confirmPasswordController.text);

                  if (response["success"]) {
                    Navigator.pushNamed(context, "/registerProfile",
                        arguments: <String, String>{
                          "email": email,
                          "password": passwordController.text
                        });
                  } else {
                    setState(() {
                      error = response["error"];
                    });
                  }
                },
                child: const Text("continuar")),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
