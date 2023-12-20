import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:send/firebase_options.dart';
import 'package:send/services/auth_service.dart';
import 'package:send/view/screens/chat_screen.dart';
import 'package:send/view/screens/chats_screen.dart';
import 'package:send/view/screens/confirm_email_screen.dart';
import 'package:send/view/screens/login_screen.dart';
import 'package:send/view/screens/profile_screens.dart';
import 'package:send/view/screens/register_email_screen.dart';
import 'package:send/view/screens/register_password.dart';
import 'package:send/view/screens/register_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _routes = {
    "/chats": (context) => const ChatsScreen(),
    "/chat": (context) => const ChatScreen(),
    "/registerEmail": (context) => const RegisterEmailScreen(),
    "/registerPassword": (context) => const RegisterPassword(),
    "/confirmEmail": (context) => const ConfirmEmailScreen(),
    "/registerProfile": (context) => const RegisterProfileScreen(),
    "/login": (context) => const LoginScreen(),
    "/profile": (context) => const ProfileScreens()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple, ),
      routes: _routes,
      initialRoute: AuthService().checkUserLoggedIn() ? "/chats" : "/registerEmail",
    );
  }
}
