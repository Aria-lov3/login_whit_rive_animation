import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

//3.1 importar timer, variables para manipular el tiempo de la animación
import 'dart:async';



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
//2.1 variable para el recorrido de la mirada
  SMINumber? _numLook;
  SMITrigger? _trigSuccess;
  SMITrigger? _trigFail;

  //1.1 para focusnode, lo roncipal es crear variables
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  //3.2 variable para la mirada al dejar de escribir
  Timer? _typingDebounce;

//1.2 Agregar oyentes/chismosos 
  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener((){
      if(_emailFocusNode.hasFocus){
        //verificar que no se nulo
        if(_isHandsUp != null){
          //manos abajo en el email
          _isHandsUp?.change(false);
          //2.2 mirada neutral
          _numLook?.value = 50.0;
        }
    }  });

    _passwordFocusNode.addListener((){
      if(_passwordFocusNode.hasFocus){
        //manos arriba en password
        _isHandsUp?.change(_passwordFocusNode.hasFocus);
      }  
    });

  }


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

                    if (_controller == null) return;

                    artboard.addController(_controller!);
                  //vincular los inputs de la animación con las variables de flutter
                    _isChecking =
                        _controller!.findSMI('isChecking') as SMIBool;
                    _isHandsUp =
                        _controller!.findSMI('isHandsUp') as SMIBool;
                      //2.3 vincular numlook a la animación
                    _numLook =
                        _controller!.findSMI('numLook') as SMINumber;

                    _trigSuccess =
                        _controller!.findSMI('trigSuccess') as SMITrigger;
                    _trigFail =
                        _controller!.findSMI('trigFail') as SMITrigger;
                  },
                ),
              ),
              const SizedBox(height: 10),

              //1.3 Avincular focus al campo de texto
              //email
              TextField(
                focusNode: _emailFocusNode,
                onChanged: (value) {              
                  if (_isHandsUp != null) {
                    _isHandsUp!.change(false);
                  }
                  if (_isChecking == null) return;
                  _isChecking!.change(true);
                  //2.4 implementar logica
                  //ajuste de 0 a 100, el valor 80 es una medida de calibracion
                  //clamp es de rango y se traduce abrsazadera
                  final double look = (value.length / 80 * 100).clamp(0, 100);
                  _numLook?.value = look;
                  //3.3 reiniciar el temporizador
                  //cancelar cualquier posible timer existente
                  _typingDebounce?.cancel();
                  //crear un nuevo timer
                  _typingDebounce = Timer(const Duration(seconds: 3), () {
                    //si se cierra la pantalla quita el contador
                    if (!mounted) return;
                    //mirada neutra
                    _isChecking?.change(false);
                  });
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
                focusNode: _passwordFocusNode,
                onChanged: (value) {
                  if (_isChecking != null) {
                    //_isChecking!.change(false);
                  }
                  if (_isHandsUp == null) return;
                  //_isHandsUp!.change(true);
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
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
  //1.4 liberar recursos al salir de la pantalla
  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
    //con el super dispose se asegura de que se liberen los recursos de la clase padre, evitando posibles fugas de memoria.
  }
}

