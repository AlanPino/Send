import 'package:flutter/material.dart';
import 'package:send/view/widgets/text_field_widget.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({ Key? key }) : super(key: key);

  @override
  _ConfirmEmailScreenState createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final TextEditingController codeController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("ingrese el código enviado a su correo electrónico", style: TextStyle(fontSize: 20, ), textAlign: TextAlign.center),
            const SizedBox(height: 20,),
            TextFieldWidget(hint: "código", controller: codeController),
            TextButton(onPressed: (){}, child: const Text("reenviar código")),
            FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/registerPassword");
                  },
                  child: const Text("verificar")),
          ],
        ),
      ),
    );
  }
}