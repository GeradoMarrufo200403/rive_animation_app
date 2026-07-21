import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async'; //Para manejar el foco de los inputs

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Control para mostrar u ocultar la contraseña
  bool _obscureText = true;

  // Cerebro de animacion
  StateMachineController? _controller;
  //StateMachine controller
  SMIBool? _isChecking;
  SMIBool? _isHandsUp;
  SMITrigger? _trigsuccess;
  SMITrigger? _trigfail;

  //3.1 variable para recorrer la  mirada
  SMINumber? _numLook;

  //4.2 Timer para detener la mirada
  Timer? _typingDebounce;

  //2.1 Crear variables para focus node
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    //2.2 Crear listeners para detectar focus
    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        //Verifica que no sea nulo
        if (_isHandsUp != null) {
          //Manos abajo del email
          _isHandsUp?.change(false);
          // 3.2 Mirada neutral
          _numLook?.value = 50;
        }
      } else {
        // Detener la mirada al perder el foco y cancelar el timer
        _isChecking?.change(false);
        _typingDebounce?.cancel();
      }
    });
    _passwordFocus.addListener(() {
      //Manos arriba de la contraseña
      _isHandsUp?.change(_passwordFocus.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    //Paraobtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'animated_login_bear.riv',
                  stateMachines: const ['Login Machine'],
                  //Al iniciar la animacion
                  onInit: (artboard) {
                    _controller = StateMachineController.fromArtboard(
                      artboard,
                      'Login Machine',
                    );
                    //Verifica que inicio bien
                    if (_controller == null) return;
                    //Agregar el controlador al tablero
                    artboard.addController(_controller!);
                    //Vincular variables
                    _isChecking = _controller!.findSMI("isChecking");
                    _isHandsUp = _controller!.findSMI("isHandsUp");
                    _trigsuccess = _controller!.findSMI("TrigSuccess");
                    _trigfail = _controller!.findSMI("TrigFail");
                    //3.3 Vincular numlock
                    _numLook = _controller!.findSMI("numLook");

                    // Sincronizar el estado actual del foco tras cargar la animación
                    if (_isHandsUp != null) {
                      _isHandsUp!.change(_passwordFocus.hasFocus);
                    }
                  },
                ),
              ),
              // Para separar los elementos de la pantalla
              SizedBox(height: 10),
              TextField(
                //
                focusNode: _emailFocus,
                //1.3 Vincular SMIs a inputs
                onChanged: (value) {
                  if (_isHandsUp != null) {
                    //No tapes los ojos al ver el email
                    _isHandsUp!.change(false);
                  }
                  if (_isChecking != null) {
                    //Activa el modo chismoso
                    _isChecking!.change(true);
                    //3.4 Implementar numlock
                    //Ajustar limites de 0 a 100
                    //80 es la medidade calibracion
                    final look = (value.length / 80.0 * 100.0)
                        .clamp(0.0, 100.0)
                        .toDouble(); // Clamp es un rango
                    _numLook?.value = look;

                    //4.3 debounce
                    // cancelar cualquier timner existente
                    _typingDebounce?.cancel();

                    // 4.4 Iniciar nuevo timer para detner la animacion
                    _typingDebounce = Timer(const Duration(seconds: 3), () {
                      if (!mounted) return;
                      _isChecking?.change(false);
                    });
                  }
                },
                //Para mostrar un tipo de teclado especifico
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'your@email.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                //
                focusNode: _passwordFocus,
                //1.4 Vincular SMIs a inputs
                onChanged: (value) {
                  if (_isChecking != null) {
                    _isChecking!.change(false);
                  }
                  //Si isChecking es nulo
                  if (_isHandsUp == null) return;
                  _isHandsUp!.change(true);
                },
                //Para la contraseña
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      //Refrescar el ícono
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //2.4 Liberar recuersos de la pantalla
  @override
  void dispose() {
    super.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _typingDebounce?.cancel();
  }
}
