import 'package:flutter/material.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp (
    options: const FirebaseOptions(
      apiKey: "AIzaSyAEmln4yIJ_gyczrjp7czpajRxOL_T46i8",
      authDomain: "chat-app-6a1c0.firebaseapp.com",
      projectId: "chat-app-6a1c0",
      storageBucket: "chat-app-6a1c0.appspot.com",
      messagingSenderId: "332577298861",
      appId: "1:332577298861:android:2e07d8d65d20f9b6e82924"
    )
  );
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
