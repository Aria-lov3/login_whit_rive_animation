import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //Evita nudeg o camaras frontales
      body: SafeArea(child: 
      Column( 
        children: [
          Expanded(child: RiveAnimation.asset('animated_login_character.riv'))
        ],
      )),
    );
  }
}