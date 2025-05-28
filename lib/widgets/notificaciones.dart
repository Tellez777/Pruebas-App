import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theoriginalapp/services/apicontenidoservice.dart';

class NotificacionesScreen extends StatefulWidget {
  final String userEmail; 
  const NotificacionesScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _NotificacionesScreenState createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  late Future<List<Map<String, String>>> _futuremensaje;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); // Carga el email al iniciar
  }

    void _loadUserEmail() {
    // Ejemplo con SharedPreferences:
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _userEmail = prefs.getString('user_email') ?? '';
        _futuremensaje = ApiService().fetchMensaje(email: _userEmail);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones', 
        style: TextStyle(color: Colors.white), // Texto en color blanco
        ),
        centerTitle: true, // se centra el título
        backgroundColor: Colors.black, // color de fondo donde va el
        iconTheme: const IconThemeData(color: Colors.white), // Iconos también en blanco
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _futuremensaje,
        builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(height: 10.h),
          Text(
            'Error al cargar notificaciones',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            snapshot.error.toString(),
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () => setState(() {
              _futuremensaje = ApiService().fetchMensaje(email: widget.userEmail);
            }),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  // Si no hay error ni está esperando, mostrar la lista de mensaje
  if (snapshot.hasData) {
    final mensaje = snapshot.data!;
    if (mensaje.isEmpty) {
      return const Center(child: Text('No hay notificaciones.')); 
    }
    return ListView.builder(
      itemCount: mensaje.length,
      itemBuilder: (context, index) {
        final mensajeItem = mensaje[index];
        return ListTile(
  leading: const Icon(Icons.message),
  title: Text(mensajeItem['message'] ?? 'Sin mensaje'),
  subtitle: Text(
    '${mensajeItem['email'] ?? 'Sin email'}\n${mensajeItem['date'] ?? 'Sin fecha'}',
    style: TextStyle(fontSize: 12.sp),
  ),
  isThreeLine: true,
);


      },
    );
  }
  return const SizedBox.shrink(); // En caso de que no haya datos y no haya error
}
      ),
    );
  }
}
