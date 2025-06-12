import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theoriginalapp/main.dart';
import 'package:theoriginalapp/screens/iniciarsesion.dart';
import 'package:theoriginalapp/services/userservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

Future<void> _saveUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService userService = UserService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;


  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa un correo electrónico';
    } else if (!value.contains('@')) {
      return 'Por favor, ingresa un correo electrónico válido';
    }
    return null;
  }

  String? _validateRequired(String? value, String field) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa $field';
    }
    return null;
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _onRegister() async {
  if (!_formKey.currentState!.validate()) return;

  try {
    print('Datos a enviar:');
    print('Email: ${emailController.text}');
    print('Usuario: ${usernameController.text}');
    print('Password ${passwordController.text}');

    final response = await userService.registro(
      email: emailController.text,
      username: usernameController.text,
      password: passwordController.text,
      phone: '0',
      profile_img: '',
    );

    print('Respuesta completa de la API: $response');

    if (response != null && response['token_verificacion'] != null) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Éxito"),
          content: const Text(
          "Registro completado con éxito, por favor revisa el enlace enviado a tu correo para validarlo."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

      emailController.clear();
      usernameController.clear();
      passwordController.clear();
    } else {
      if (response != null && response['message'] != null) {
        _showDialog("Error", "Error en el registro: " + response['message']);
      } else {
        _showDialog("Error", "Error en el registro, por favor intenta nuevamente.");
      }
    }
  } catch (e) {
    print('Error completo: $e');
    _showDialog("Error", "Ocurrió un error durante el registro: ${e.toString()}");
  }
}

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopSection(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r), // Esquinas redondeadas
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: screenSize.width * 0.1,
                    ),
                    child: _buildForm(screenSize),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      height: 100,
      color: Colors.black,
      child: Center(
        child: SvgPicture.asset(
          'assets/logo.svg',
          height: 80,
        ),
      ),
    );
  }

  Widget _buildForm(Size screenSize) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          SizedBox(height: 30.h),

          _buildInputField(
            label: 'Email',
            controller: emailController,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),

          _buildInputField(
            label: 'Usuario',
            controller: usernameController,
            validator: (value) => _validateRequired(value, "un nombre de usuario"),
          ),

          _buildInputField(
            label: 'Contraseña',
            controller: passwordController,
            isPassword: true,
            validator: (value) => _validateRequired(value, "una contraseña"),
          ),
          
          SizedBox(height: 30.h),
          _buildRegisterButton(screenSize),
          SizedBox(height: 20.h),
          _buildLoginLink(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Registrarse',
      style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w900),
    );
  }

  Widget _buildInputField({
  required String label,
  bool isPassword = false,
  required TextEditingController controller,
  String? Function(String?)? validator,
  TextInputType? keyboardType,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18.sp)),
        SizedBox(height: 8.h),
        SizedBox(
          height: 50.h,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? !_isPasswordVisible : false,
            validator: validator,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFC4C4C4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(  // Icono de visibilidad de contraseña
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildRegisterButton(Size screenSize) {
    return SizedBox(
      width: screenSize.width * 0.6.h,
      child: ElevatedButton(
        onPressed: _onRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC4C4C4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Text(
          'Registrarse',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("¿Ya tienes una cuenta?"),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(  // Navega a la pantalla de inicio de sesión despue de darle click al texto
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text(
            "Inicia sesión",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            
          ),
        ),
      ],
    );
  }
}