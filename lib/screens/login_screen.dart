import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // control para ocultar/mostrar contraseña
  bool _obscureText = true;

  // cerebro de la lógica de la animación
  StateMachineController? _controller;

  // state machine input
  SMIBool? _isChecking;
  SMIBool? _isHandsUp;
  SMINumber? _numLook;
  SMITrigger? _trigSuccess;
  SMITrigger? _trigFail;

  @override
  Widget build(BuildContext context) {
    // tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Evita notch o cámaras frontales
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: size.height * 0.4,
                child: RiveAnimation.asset(
                  'animated_login_character.riv',
                  stateMachines: const ['Login Machine'],
                  onInit: (artboard) {
                    _controller = StateMachineController.fromArtboard(
                      artboard,
                      'Login Machine',
                    );

                     if (_controller != null) return;

                    //vinculando los inputs
                    _isChecking = _controller!.findSMI('isChecking') as SMIBool;
                    _isHandsUp = _controller!.findSMI('isHandsUp') as SMIBool;
                    _numLook = _controller!.findSMI('numLook') as SMINumber;
                    _trigSuccess =
                        _controller!.findSMI('trigSuccess') as SMITrigger;
                    _trigFail = _controller!.findSMI('trigFail') as SMITrigger;
                  },
                ),
              ),
              const SizedBox(height: 10),
              //email
              TextField(
                onChanged: (value) {
                  if (_isHandsUp != null){
                    _isHandsUp!.change(false);
                  }
                  if (_isChecking == null)return;
                  _isChecking!.change(true);
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              //contraseña
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  if (_isChecking != null){
                    _isChecking!.change(false);
                  }
                  if (_isHandsUp == null)return;
                  _isHandsUp!.change(true);
                },
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}