import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theoriginalapp/screens/iniciarsesion.dart';
import 'package:theoriginalapp/screens/registrarse.dart';
import 'package:theoriginalapp/services/userservices.dart';
import 'package:theoriginalapp/main.dart';


class Bienvenida extends StatelessWidget {
  const Bienvenida({super.key});

  @override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(
                'assets/tolnewclaro.png',
                width: screenSize.width * 0.5.w, // Ajusta el ancho
                height: screenSize.width * 0.25.w, // Ajusta la altura
              ),
                SizedBox(height: 40.h),
                // Texto Bienvenida
                Text(
                  '¡BIENVENIDO!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),

                // Botón Iniciar Sesión
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                        Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()), //cuando se presiona el boton se navega a la pantalla de inicio
                        );                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'INICIAR SESIÓN',
                      style: TextStyle(
                        fontSize: 16.sp,
                        letterSpacing: 1.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Botón Registrarse
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => RegisterScreen()), //cuando se presiona el boton se navega a la pantalla de registro
                        );                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'REGISTRARSE',
                      style: TextStyle(
                        fontSize: 16.sp,
                        letterSpacing: 1.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
