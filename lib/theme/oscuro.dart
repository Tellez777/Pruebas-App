import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clase que contiene la configuración del tema oscuro de la aplicación.

class Oscuro {

  /// Tema oscuro personalizado utilizando ThemeData
  static final ThemeData themeDark = ThemeData(
    // Define el brillo del tema como oscuro
    brightness: Brightness.dark,

    // Color de fondo principal de los scaffolds (pantallas)
    scaffoldBackgroundColor: const Color(0xFF121212),

    // Color principal del tema (primario)
    primaryColor: Colors.white,

    // Personalización del AppBar para modo oscuro
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F), // Color de fondo del AppBar
      iconTheme: IconThemeData(color: Colors.white), // Color de los íconos (ej: flecha back)
    ),

    // Fuente personalizada Rubik aplicada a todos los textos
    textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
  );
}
