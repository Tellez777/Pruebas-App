import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Logos extends StatefulWidget {
  @override
  _LogosState createState() => _LogosState();
}

class _LogosState extends State<Logos> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://theoriginallab-iaimv2.m0oqwu.easypanel.host/')); // url del webview
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
