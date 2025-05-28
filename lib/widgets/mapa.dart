import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget {
  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  final Color _buttonTextColor = Colors.black;
  Color _iconColor = Colors.black;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(24.0395953, -104.6332607),
    zoom: 16,
  );

  static const CameraPosition _labPosition = CameraPosition(
    bearing: 45,
    target: LatLng(24.0395953, -104.6332607),
    tilt: 30,
    zoom: 18,
  );

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('OriginalLab'),
      position: LatLng(24.0395953, -104.6332607),
      infoWindow: InfoWindow(
        title: 'The Original Lab',
        snippet: 'Consultora de Software',
      ),
    ),
  };

  void _changeIconColor(Color newColor) {
    setState(() {
      _iconColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonFontSize = screenHeight * 0.02.sp; // Ajusta el tamaño de la fuente del botón según la altura de la pantalla

    return Scaffold(
      extendBodyBehindAppBar: true, // Permite que el mapa esté detrás de la AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Hace la AppBar transparente
        elevation: 0, // Elimina la sombra
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Icono de la flecha para volver atras
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildGoogleMap(),
      floatingActionButton: _buildFloatingActionButton(buttonFontSize),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialPosition,
      onMapCreated: (GoogleMapController controller) {
        _controllerCompleter.complete(controller);
      },
      markers: _markers,
    );
  }

  Widget _buildFloatingActionButton(double fontSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      child: FloatingActionButton.extended(
        onPressed: _gotoLabPosition,
        label: Text(
          'The Original Lab',
          style: TextStyle(fontSize: fontSize, color: _buttonTextColor),
        ),
        icon: Icon(Icons.directions_walk, color: _iconColor),
        backgroundColor: const Color(0xFFB0B0B6),
      ),
    );
  }

  Future<void> _gotoLabPosition() async {
    final GoogleMapController controller = await _controllerCompleter.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_labPosition));
  }
}