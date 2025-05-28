import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Pantalla que muestra una WebView apuntando a la página de productos de The Original Lab.
class ProductosTol extends StatefulWidget {
  @override
  _ProductosTolState createState() => _ProductosTolState();
}

class _ProductosTolState extends State<ProductosTol> {
  /// Controlador de la WebView
  late final WebViewController _controller;

  /// Bandera para mostrar u ocultar el spinner de carga
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Inicialización del controlador WebView con configuración de JS y navegación
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Habilita JavaScript
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Se podría poner en true aquí para mostrar carga
            setState(() => isLoading = false);
          },
          onPageFinished: (String url) {
            // Finaliza la carga
            setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // En caso de error, también desactiva carga
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(
        // Carga la URL de productos
        Uri.parse('https://theoriginallab.com/productos'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Botón de navegación hacia atrás
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        elevation: 0, // Sin sombra para un look limpio
      ),
      body: Stack(
        children: [
          // Contenido de la WebView
          WebViewWidget(controller: _controller),

          // Spinner mientras se carga la página (actualmente no se activa por error en lógica)
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
