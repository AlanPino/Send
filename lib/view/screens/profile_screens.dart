import 'package:flutter/material.dart';
import 'package:send/model/user_model.dart';
import 'package:send/services/auth_service.dart';
import 'package:send/view/widgets/card_widget.dart';
import 'package:send/view/widgets/image_picker_widget.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({Key? key}) : super(key: key);

  @override
  _ProfileScreensState createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
    TextEditingController imagePath = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final currentUser = ModalRoute.of(context)!.settings.arguments as UserModel;
    Image image = Image.network(currentUser.imageUrl);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(didPop){
          return;
        }
        Navigator.of(context).pop(imagePath.text);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                ImagePickerWidget(imagePath: imagePath, image: image,),
                const SizedBox(
                  height: 20,
                ),
                CardWidget(title: "Nombre", subtitle: currentUser.name),
                CardWidget(
                    title: "Correo electrónico", subtitle: currentUser.email),
                const CardWidget(title: "Contraseña", subtitle: "*********"),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                    onPressed: () async {
                      Map<String, dynamic> response =
                          await AuthService().logoutUser();
      
                      if (response["success"]) {
                        Navigator.pushReplacementNamed(context, "/registerEmail");
                      }
                    },
                    
                    child: const Text("Cerrar sesión"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
