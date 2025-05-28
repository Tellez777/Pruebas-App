import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:theoriginalapp/main.dart';
import 'inicio.dart';

// Clase que representa la pantalla de Tienda en la aplicación
class Tienda extends StatelessWidget {
  const Tienda({super.key});

  void _openInAppWebView(String url, BuildContext context) { // Método _openInAppWebView para abrir una URL en un WebView dentro de la aplicación
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomWebView(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) { //define el metodo build especificamente la pantalla de tienda que devuelve un scaffold co diseño responsivo
    // Tamaño de pantalla para diseño responsivo
        final tarjeta = AppData.tarjeta; //devuelve los datos de la API en este caso las listcards
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
    // el valueListenable escucha al themeNotifier para saber si es tema claro o oscuro
    return ValueListenableBuilder<bool>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, isDark, child) {
        // Lista mapa de elementos para mostrar en la tienda en este caso son las listcards
        final List<Map<String, String>> tarjeta = AppData.tarjeta; //se configura para traer los datos de la API
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: isDark
                  ? null
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color(0xFFF5F5F5),
                        Color(0xFFEEEEEE), // colores del fondo con degradado
                        Color(0xFFC2C1C1),
                      ],
                    ),
              color: isDark ? Colors.black : null,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Carrusel de imágenes el cual es un widget personalizado
                    ImageCarousel(
                      images: AppData.sliderTienda, //se configura para traer los datos de la API
                      onImageTap: (url) => _openInAppWebView(url, context), //onImageTap srive para abrir una URL en un WebView cuando se le da click a una listcard
                      carouselHeight: screenHeight * 0.25, //altura del carrusel
                    ),

                    SizedBox(height: 20.h), // Espacio entre el slider y las tarjetas
                    // Tarjetas de tienda en formato grid
                    GridView.builder(
                      shrinkWrap: true, // Hace que el GridView ocupe solo el espacio necesario
                      physics: const NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), // Espacio horizontal (padding)
                      itemCount: tarjeta.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth < 600 ? 1 : 2,
                        crossAxisSpacing: 12, //espacio horizontal entre elementos
                        mainAxisSpacing: 12, //espacio vertical entre elementos
                        childAspectRatio: 1.6, // Relación ancho/alto de cada elemento
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector( //detector de gestos o cuando se le da click a una listcard mas especificamente a el titulo y a la imagen porque envuelve a todo el widget
                          onTap: () => _openInAppWebView(tarjeta[index]['url']!, context),
                          child: _buildCard(
                            tarjeta[index]['title']!,
                            tarjeta[index]['image']!,
                            isDark,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Constructor de tarjeta visual
  Widget _buildCard(String title, String imagePath, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Imagen de fondo
            Image.network( // imagen de fondo de la listcard el cual en ete caso es network porque es una imagen que no esta de forma local
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            // Título superpuesto
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget personalizado para mostrar páginas web dentro de la app
class CustomWebView extends StatelessWidget {
  final String url;

  const CustomWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(
        controller: WebViewController()..loadRequest(Uri.parse(url)), //el webviewcontroller carga la pagina de forma directa
      ),
    );
  }
}
