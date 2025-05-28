import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AulasVirtualesScreen extends StatefulWidget {
  const AulasVirtualesScreen({Key? key}) : super(key: key);

  @override
  State<AulasVirtualesScreen> createState() => _AulasVirtualesState();
}

class _AulasVirtualesState extends State<AulasVirtualesScreen> {
  late final WebViewController _controller;
  bool isLoading = true; // Para mostrar indicador de carga

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Error cargando página: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse("https://theoriginallab.com/aula-virtual-apps#precios"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // icono de la flecha para volver atras
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}