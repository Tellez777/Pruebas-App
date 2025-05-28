import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:theoriginalapp/main.dart';
import 'package:theoriginalapp/services/apicontenidoservice.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) { // se define el metodo build que devuelve un scaffold con la pantalla de inicio 
    final items = AppData.items;
    final screenWidth = MediaQuery.of(context).size.width; // agarra datos estaticos precargados y se obtiene el tamaño de la pantalla con diseño responsivo
    final screenHeight = MediaQuery.of(context).size.height;
    final carouselHeight = screenHeight * 0.25;


    return ValueListenableBuilder<bool>(
      valueListenable: MyApp.themeNotifier, // el valueListenable escucha al themeNotifier para saber si es tema claro o oscuro
      builder: (context, isDark, child) {
        return Scaffold( //se devuelve/crea un scaffold
          extendBodyBehindAppBar: true,
          body: Container( // se crea un contenedor que tendra la pantalla con degradado
            width: double.infinity,  // Ancho que ocupa todo el espacio disponible
            height: double.infinity, // Altura que ocupa todo el espacio disponible
            decoration: BoxDecoration(
              gradient: isDark //condicional que verifica si el tema es oscuro
                  ? null // si es oscuro no se aplica degradado
                  : LinearGradient( // si es claro se aplica degradado
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xFFF5F5F5),
                  Color(0xFFEEEEEE),  // colores del fondo con degradado
                  Color(0xFFC2C1C1),
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
                    /// Webview e imagenes de los slider
                    ImageCarousel( //primer slider de inicio
                      images: AppData.sliderItems, // se llama a la API para traer los sliders
                      onImageTap: (url) => _openWebView(context, url),
                      carouselHeight: screenHeight * 0.25,
                      aspectRatio: 16/9, // altura del slider
                    ),
                    SizedBox(height: screenHeight * 0.02.h),
                    Container(
                      height: screenWidth > 600 ? 250 : 200,
                      child: ListView.builder( //crea las listcards que contienen una imagen y el texto
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return _buildPillCard(
                              context,
                              items[index],
                              isDark,
                              width: screenWidth > 600 ? 220 : 180
                          );
                        },
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01.h),
                    ImageCarousel(  //segundo slider (cursos)
                      images: AppData.cursos, // se llama a la API para traer los sliders de los cursos ya definidos en el main
                      onImageTap: (url) => _openWebView(context, url),
                      carouselHeight: screenHeight * 0.25,
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

  Widget _buildPillCard(BuildContext context, Map<String, String> item, bool isDark, {double? width}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = width ?? 180;
        return GestureDetector(
          onTap: () => _openWebView(context, item['url']!),
          child: Container(
            width: cardWidth,
            margin: const EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: CachedNetworkImage(
                    imageUrl: item['image']!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: cardWidth * 1.1,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300], // Solo fondo gris sin indicador
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image),
                    ),
                    memCacheWidth: (cardWidth * MediaQuery.of(context).devicePixelRatio).round(),
                  ),
                ),
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
                      item['title']!,
                      style: TextStyle(
                        fontSize: constraints.maxWidth > 200 ? 14 : 12,
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
      },
    );
  }

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? Colors.black : Colors.white,
            iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
            ),
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (isLoading)
                  Container( // Cambiado a un simple fondo de carga
                    color: isDark ? Colors.black : Colors.white,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ImageCarousel extends StatefulWidget {
  final List<Map<String, String>> images;
  final Function(String) onImageTap;
  final double? carouselHeight;
  final double aspectRatio; 

  const ImageCarousel({
    super.key,
    required this.images,
    required this.onImageTap,
    this.carouselHeight,
    this.aspectRatio = 16 / 9, // Relación de aspecto por defecto
  });

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % widget.images.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final carouselHeight = widget.carouselHeight ?? screenWidth / widget.aspectRatio;

    return ValueListenableBuilder<bool>(
      valueListenable: MyApp.themeNotifier,
      builder: (context, isDark, child) {
        return SizedBox(
          height: carouselHeight,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => widget.onImageTap(widget.images[index]['url']!),
                    child: CachedNetworkImage(
                      imageUrl: widget.images[index]['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: carouselHeight,
                      placeholder: (context, url) => Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[300], // Solo color de fondo
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[300],
                        child: Icon(Icons.broken_image, size: 40.sp, color: isDark ? Colors.white : Colors.black),
                      ),
                      memCacheWidth: (screenWidth * MediaQuery.of(context).devicePixelRatio).round(),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: widget.images.length > 1
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.images.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              height: 6.h,
                              width: _currentPage == index ? 24.w : 8.w,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? (isDark ? Colors.white : Colors.black)
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(4.0.r),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}