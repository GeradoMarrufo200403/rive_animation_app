import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //Control para mostrar u ocultar la contraseña
  bool _obscureText = true;
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
                child: RiveAnimation.asset('animated_login_bear.riv'),
              ),
              // Para separar los elementos de la pantalla
              SizedBox(height: 10),
              TextField(
                //Para mostrar un tipo de teclado especifico
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'your@email.com',
                  prefixIcon: Icon(Icons.email),                 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                //Para la contraseña
                obscureText: _obscureText,                
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(onPressed: (){
                    //Refrescar el ícono
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  }, icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off)                    
                  ),                 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}