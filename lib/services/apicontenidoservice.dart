import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api-app.theoriginallab.com"; // url de la API, URL api de la app

  

///contenido SLIDERS del home
    Future<List<Map<String, String>>> fetchSlider() async { // funcion fetch asincrona que devuelve un future es decir que no se va a reflejar al instate si no cuando se haga la peticion a la API
    final response = await _request('GET', '/slider/all'); //endpoints, se llama al metodo _request con el metodo GET y el endpoint slider/all
  
    final records = response['records']; //Se extrae el campo records del JSON, que se espera sea la lista de objetos con las propiedades image y url.

    return List<Map<String, String>>.from(  //Tabla slider de la base de datos donde los dos string son los campos imagen y url. El list map son listas de mapas los cuale son los slider (sliders)
      records.map((record) {                     
        return {
          'image': record['image'] as String, //devuelve la imagen y la url para despues mostrarlos en la pantalla de incio
          'url': record['url'] as String, 
        };
      }),
    );
  }
///contenido LISTCARDS del home
    Future<List<Map<String, String>>> fetchItems() async {
    final response = await _request('GET', '/item/all');  //endpoints

    final records = response['records'];

    return List<Map<String, String>>.from(  // Tabla items de la base de datos (listcards)
      records.map((record) {
        return {
          'title': record['title'] as String,  // en este caso devuelve tambien un titulo asi como imagen y url
          'image': record['image'] as String,
          'url': record['url'] as String,
          
        };
      }),
    );
  }

  ///contenido SLIDERS de la parte de cursos
    Future<List<Map<String, String>>> fetchCursos() async {
    final response = await _request('GET', '/curso/all');  //endpoints

    final records = response['records'];

    return List<Map<String, String>>.from(  // Tabla curso de la base de datos (slider)
      records.map((record) {
        return {
          'image': record['image'] as String,
          'url': record['url'] as String,
          
        };
      }),
    );
  }
///contenido LISTCARDS de la parte de tienda
    Future<List<Map<String, String>>> fetchTarjeta() async {
    final response = await _request('GET', '/tarjeta/all'); //endpoints

    final records = response['records'];

    return List<Map<String, String>>.from(   // Tabla tarjeta de la base de datos (listcards)
      records.map((record) {
        return {
          'title': record['title'] as String,
          'image': record['image'] as String,
          'url': record['url'] as String,
        };
      }),
    );
  }

  ///contenido SLIDERS de la parte de tienda
    Future<List<Map<String, String>>> fetchSliderTienda() async {
    final response = await _request('GET', '/slidertienda/all'); //endpoints

    final records = response['records'];

    return List<Map<String, String>>.from(   // Tabla slidertienda de la base de datos (slider)
      records.map((record) {
        return {
          'image': record['image'] as String,
          'url': record['url'] as String,
        };
      }),
    );
  }
///NOTIFICACIONES
Future<List<Map<String, String>>> fetchMensaje({required String email}) async {
  try {
    final response = await _request('GET', '/mensaje/all', params: {'email': email});
    print('Respuesta completa: $response');
    
    if (response is Map && response.containsKey('records')) {
      final records = response['records'] as List;
      return records.map<Map<String, String>>((record) {
        return {
          'id_mensaje': record['id_mensaje']?.toString() ?? '0',
          'email': record['email']?.toString() ?? 'Sin email',
          'message': record['message']?.toString() ?? 'Sin mensaje',
          'date': record['date']?.toString() ?? 'Sin fecha',
        };
      }).toList();
    } else {
      throw Exception('Estructura de respuesta inesperada');
    }
  } catch (e) {
    throw Exception('Error al cargar mensajes: $e');
  }
}

  Future<dynamic> _request(String method, String endpoint, {Map<String, dynamic>? body, Map<String, dynamic>? params}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params); // se arma la url final concatenando la url base y el endpoint
      final headers = {'Content-Type': 'application/json', 'apikey': 'lety'}; // se envia un json con la apikey en este caso con su identificador

      http.Response response; //variable para almacenar la respuesta

      switch (method) {  // se evalua el metodo http 
        case 'POST':
          response = await http.post(uri, headers: headers, body: json.encode(body));
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: json.encode(body));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        case 'GET':
        default:
          response = await http.get(uri, headers: headers);
      }

      if (response.statusCode == 200) { // si la respuesta es 200 esta todo ok, esto permite que las funciones "fetch" devuelvan los datos y estan listos para ser usados
        print('response:');
        //print(response.body);
        print(json.decode(response.body));
        return json.decode(response.body);
      } else {
        throw Exception("Error ${response.statusCode}: ${response.body}");
      }
    }

    on SocketException {
      throw Exception("No hay conexión a Internet");
    } 

    on FormatException {
      throw Exception("Respuesta no válida del servidor");
    } 
    
    catch (e) {
      throw Exception("Error en la solicitud: $e");
    }
  }
}
