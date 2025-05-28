import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../main.dart';
import 'bienvenida.dart';

void main() {
  runApp(const MyApp(isLoggedIn: false));
}


class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
  runApp(MyApp(isLoggedIn: isLoggedIn));
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Elimina la etiqueta "aplicación en prueba"
      home: isLoggedIn ? HomeScreen() : const SplashScreen(),
 // se define la pantalla inicial como SplashScreen
    );
  }
}

// Clase de la pantalla de Splashscreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // aqui se hace la animacion de la imagen
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // se configuran las animaciones
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Comienza fuera de la pantalla
      end: Offset.zero, // Termina en la posición original
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Inicia la animación
    _controller.forward();

    // Temporizador para redirigir al HomeScreen después de 4 segundos
    Timer(const Duration(seconds: 4), _navigateToHomeScreen);
  }

  void _navigateToHomeScreen() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (isLoggedIn) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Bienvenida()), // Tu pantalla de bienvenida o login
    );
  }
}


  @override
  void dispose() {
    _controller.dispose(); // Libera los recursos del controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Tamaño de la pantalla

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation, // Animación de opacidad
              child: SlideTransition(
                position: _slideAnimation, // Animación de movimiento
                child: Image.asset(
                  'assets/tolnewclaro.png', // Ruta de la imagen
                  width: screenSize.width * 0.4, // Ajusta el ancho
                  height: screenSize.width * 0.4, // Ajusta la altura
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.0.h), // Espaciado
          ],
        ),
      ),
    );
  }
}
