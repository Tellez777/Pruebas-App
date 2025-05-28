import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl =
      "https://theoriginallab-apptol-api-login.m0oqwu.easypanel.host"; // url de la API en este caso la de registro

//REGISTRO//
  Future<dynamic> registro({
    // funcion llamada "registro" y se ejecuta el registro de un usuario
    required String email,
    required String username, //parametros requeridos para el registro
    required String password,
    required String phone,
    required String profile_img,

  }) async {
    var response = {};
    try {
      final body = {
        'email': email,
        'name': username,
        'password': password,
        'phone': phone,
        'profile_img': '',
      };

      response = await _request('POST', '/api/register',
          body); //endpoint de registro, se llama al metodo _request con el metodo POST y el endpoint api/registrar
      
    } catch (e) {
      print('Error en registro: $e');
    }
    return response;
  }

//LOGIN//
Future<bool> login({
  // funcion llamada "login" y se inicia sesion de un usuario
  required String email,
  required String password,
}) async {
  try {
    final encodedPassword = base64.encode(utf8.encode(password));

    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': encodedPassword}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['message'] ?? "Inicio de sesión exitoso");
      return true;
    } else {
      final data = json.decode(response.body);
      print(data['message'] ?? data['error'] ?? "Error al Iniciar sesión: Datos invalidos");
      return false;
    }
  } catch (error) {
    print('Error al iniciar sesión: $error');
    return false;
  }
}

  Future<dynamic> _request(String method, String endpoint, body) async {
    try {
      final uri = Uri.parse(
          '$baseUrl$endpoint'); // se arma la url final concatenando la url base y el endpoint
      final headers = {
        'Content-Type': 'application/json',
        'apikey': 'lety'
      }; // se envia un json con la apikey en este caso con su identificador

      http.Response response; //variable para almacenar la respuesta

      switch (method) {
        // se evalua el metodo http
        case 'POST':
          response =
              await http.post(uri, headers: headers, body: json.encode(body));
          break;
        case 'PUT':
          response =
              await http.put(uri, headers: headers, body: json.encode(body));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        case 'GET':
        default:
          response = await http.get(uri, headers: headers);
      }

      if (response.statusCode == 200) {
        // si la respuesta es 200 esta todo ok, esto permite que las funciones "fetch" devuelvan los datos y estan listos para ser usados
        print('response:');
        //print(response.body);
        print(json.decode(response.body));
        return json.decode(response.body);
      } else {
        //throw Exception("Error ${response.statusCode}: ${response.body}");
        return json.decode(response.body);
      }
    } on SocketException {
      throw Exception("No hay conexión a Internet");
    } on FormatException {
      throw Exception("Respuesta no válida del servidor");
    } catch (e) {
      throw Exception("Error en la solicitud: $e");
    }
  }
}