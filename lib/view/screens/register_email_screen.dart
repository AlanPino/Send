import 'package:flutter/material.dart';
import 'package:send/controller/email_controller.dart';
import 'package:send/model/user_model.dart';
import 'package:send/services/database_service.dart';
import 'package:send/view/widgets/text_field_widget.dart';

class RegisterEmailScreen extends StatefulWidget {
  const RegisterEmailScreen({Key? key}) : super(key: key);

  @override
  _RegisterEmailScreenState createState() => _RegisterEmailScreenState();
}

class _RegisterEmailScreenState extends State<RegisterEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  String error = "";

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      setState(() {
        error = "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Image(image: AssetImage("assets/logo.png")),
            TextFieldWidget(hint: "ingrese email", controller: emailController),
            Text(
              error,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(
              height: 10,
            ),
            FilledButton(
                onPressed: () async {
                  if ( await DatabaseService().userExists(emailController.text)) {
                    UserModel user = await DatabaseService().getUser(emailController.text);
                    Navigator.pushNamed(context, "/login", arguments: user);
                  } else {
                    final Map<String, dynamic> response =
                        validateEmail(emailController.text);
                    if (response["success"]) {
                      Navigator.pushNamed(context, "/registerPassword",
                          arguments: emailController.text);
                    } else {
                      setState(() {
                        error = response["error"];
                      });
                    }
                  }
                },
                child: const Text("continuar")),
            const SizedBox(
              height: 50,
            ),
            Text(
              "¡Bienvenido!",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
