import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Widget de pantalla que muestra una vista web de un sitio en especifico
class Servicios extends StatefulWidget {
  @override
  _ServiciosState createState() => _ServiciosState();
}

class _ServiciosState extends State<Servicios> {
  /// Controlador de la WebView para gestionar el contenido cargado
  late final WebViewController _controller;

  /// Bandera para mostrar u ocultar el indicador de carga (spinner)
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Inicia el controlador de WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Permite ejecución de JS
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Al iniciar carga de página, se muestra el indicador de carga
            setState(() => isLoading = false);
          },
          onPageFinished: (String url) {
            // Al terminar la carga, se oculta el indicador
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(
        // Carga la URL de la sección de servicios
        Uri.parse('https://theoriginallab.com/#servicios'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Botón de regreso a la pantalla anterior
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        elevation: 0, // Sin sombra
      ),
      body: Stack(
        children: [
          // WebView que muestra la URL cargada
          WebViewWidget(controller: _controller),

          // Spinner de carga mientras la WebView está cargando
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
