import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theoriginalapp/main.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final TextEditingController _usernameController = TextEditingController(); // Puedes poner texto fijo si quieres
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? Colors.black : Colors.white,
            elevation: 0,
            title: Text(
              'Perfil',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: isDark
                  ? null
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color(0xFFF5F5F5),
                        Color(0xFFEEEEEE),
                        Color(0xFFC2C1C1),
                        Color(0xFFC2C1C1),
                      ],
                    ),
              color: isDark ? Colors.black : null,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/iconousuario.png'),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: 180,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        elevation: 0,
                      ),
                      onPressed: () {}, // Función futura para cambiar foto
                      child: const Text('Cambiar foto', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  _buildReadOnlyTextField('Nombre de usuario', _usernameController, isDark),
                  SizedBox(height: 15.h),
                  _buildReadOnlyTextField('Email', _emailController, isDark),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReadOnlyTextField(String label, TextEditingController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 14.sp),
        ),
        SizedBox(height: 5.h),
        TextField(
          controller: controller,
          readOnly: true,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.grey[900] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
      ],
    );
  }
}
