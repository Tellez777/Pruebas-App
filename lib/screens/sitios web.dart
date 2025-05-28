import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SitiosWebScreen extends StatefulWidget {
  const SitiosWebScreen({Key? key}) : super(key: key);

  @override
  State<SitiosWebScreen> createState() => _SitiosWebState();
}

class _SitiosWebState extends State<SitiosWebScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

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
      ..loadRequest(Uri.parse("https://theoriginallab.com/comercio-electronico-apps#precios"));
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