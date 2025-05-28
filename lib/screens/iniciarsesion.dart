import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theoriginalapp/main.dart';
import 'package:theoriginalapp/services/userservices.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
void initState() {
  super.initState();
  _loadSavedCredentials(); // se llama al iniciar 
}

Future<void> _loadSavedCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedEmail = prefs.getString('email');
  String? savedPassword = prefs.getString('password');

  if (savedEmail != null) {
    _emailController.text = savedEmail;
  }

  if (savedPassword != null) {
    _passwordController.text = savedPassword;
  }
}


  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog('Campos vacíos', 'Por favor ingresa email y contraseña.');
      return;
    }

    setState(() => _isLoading = true);

    // se codifica la contraseña en Base64
    final encodedPassword = base64.encode(utf8.encode(password));
    print('Encoded password: $encodedPassword');

    try {
      final response = await http.post(
        Uri.parse('https://theoriginallab-apptol-api-login.m0oqwu.easypanel.host/api/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "email": email,
          "password": encodedPassword,
        }),
      );
      print('Response status:');
      print(response.body);

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['token'] != '') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('email', email);
        prefs.setString('password', password); // Guarda la original

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        _showDialog('Error de autenticación', data['message'] ?? 'Credenciales incorrectas.');
      }
    } catch (e) {
      print('Error: $e');
      _showDialog('Error de conexión', 'No se pudo conectar con el servidor.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF000000),
      body: Column(
        children: [
          _buildTopSection(),
          Expanded(
            child: _buildLoginForm(screenSize, isPortrait),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Image.asset(
          'assets/tolnewclaro.png',
          width: 180.w,
        ),
      ),
    );
  }

  Widget _buildLoginForm(Size screenSize, bool isPortrait) {
    final fieldWidth = screenSize.width * 0.8.w;
    final fieldHeight = screenSize.height * 0.065.w;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(30.r)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildLabel('Email'),
              SizedBox(height: 8.h),
            _buildRoundedTextField(controller: _emailController, height: fieldHeight),
              SizedBox(height: 20.h),
            _buildLabel('Contraseña'),
              SizedBox(height: 8.h),
            _buildRoundedTextField(
              controller: _passwordController,
              isPassword: true,
              height: fieldHeight,
            ),
            SizedBox(height: 80.h),
            _isLoading
                ? const CircularProgressIndicator()
                : _buildLoginButton(screenSize.width * 0.6.w),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildRoundedTextField({
    required TextEditingController controller,
    bool isPassword = false,
    required double height,
  }) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_passwordVisible,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFC4C4C4),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildLoginButton(double width) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC4C4C4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: const Text(
          'Iniciar sesión',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
