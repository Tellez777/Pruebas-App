import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:theoriginalapp/main.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  bool _notificationsEnabled = false;

  Widget _buildConfigItem(IconData icon, String text, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(
        text,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MyApp.themeNotifier.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuración',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              gradient: isDarkMode
                  ? null
                  : const LinearGradient(
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
              color: isDarkMode ? Colors.black : null,
            ),
            child: ListView(
              children: [
                _buildConfigItem(
                  FontAwesomeIcons.bell,
                  'Notificaciones',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: const Color(0xFF000000),
                    activeTrackColor: const Color(0xFFCECACA),
                  ),
                ),
                _buildConfigItem(FontAwesomeIcons.star, 'Califícanos'),
                _buildConfigItem(FontAwesomeIcons.shareNodes, 'Compartir App'), // diferentes opciones de config
                _buildConfigItem(FontAwesomeIcons.comment, 'Contáctanos'),
              ],
            ),
          );
        },
      ),
    );
  }
}
