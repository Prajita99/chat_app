import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/extracted_widgets/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id =
      'welcome_screen'; //static is a modifier that modifies variable such that it is associated with the class

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  //to init. ticker we need to add this, with mixin we can reuse same code in multiple classes

  AnimationController? controller;
  Animation? animation;
  Shader linearGradientText(double width, double height) {
    return LinearGradient(
      colors: <Color>[
        Colors.lightBlueAccent,
        Colors.blueAccent
      ], 
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(Rect.fromLTRB(0, 0, width, height));
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this, //current welcome screen state provides ticker
    );

    animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);

    controller?.forward();
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: animation!.value * 100,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (rect) {
                      return linearGradientText(rect.width, rect.height);
                    },
                    // ignore: deprecated_member_use
                    child: TypewriterAnimatedTextKit(
                      text: ['Chat App'],
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      // int totalRepeatCount = 2;
                      // Duration speed = const Duration(seconds: 1);
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  RoundedButton(
                    title: 'Log In',
                    colour: Colors.lightBlueAccent,
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                  RoundedButton(
                    title: 'Register',
                    colour: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                  ),
                ],),),);
  }
}

