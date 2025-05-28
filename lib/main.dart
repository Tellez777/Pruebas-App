import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theoriginalapp/screens/bienvenida.dart';
import 'package:theoriginalapp/screens/inicio.dart';
import 'package:theoriginalapp/screens/splashscreen.dart';
import 'package:theoriginalapp/screens/tickets.dart';
import 'package:theoriginalapp/screens/reservas.dart';
import 'package:theoriginalapp/screens/tienda.dart';
import 'package:theoriginalapp/screens/perfil.dart';
import 'package:theoriginalapp/screens/configuracion.dart';
import 'package:theoriginalapp/screens/iniciarsesion.dart';
import 'package:theoriginalapp/screens/registrarse.dart';
import 'package:theoriginalapp/services/apicontenidoservice.dart'; // se importa el api service
import 'package:theoriginalapp/widgets/productostol.dart';
import 'package:theoriginalapp/widgets/servicios.dart';
import 'package:theoriginalapp/widgets/mapa.dart';
import 'package:theoriginalapp/widgets/logos.dart';
import 'package:theoriginalapp/widgets/academia.dart';
import 'package:theoriginalapp/screens/aulas virtuales.dart';
import 'package:theoriginalapp/screens/sitios web.dart';
import 'package:theoriginalapp/theme/oscuro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:theoriginalapp/widgets/notificaciones.dart';
import 'package:theoriginalapp/screens/sesioncheck.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  try {
    final sliderData = await ApiService().fetchSlider(); //funcion fetch asincrona
    AppData.sliderItems = sliderData;  // se precarga la API para que traiga los datos antes de que se inicie la app, en este caso los datos de la variable sliderItems de la clase Appdata

    final itemsData = await ApiService().fetchItems(); //funcion fetch asincrona
    AppData.items = itemsData;  // se precarga la API para que traiga los datos antes de que se inicie la app

    final cursoData = await ApiService().fetchCursos(); //funcion fetch asincrona
    AppData.cursos = cursoData;  // se precarga la API para que traiga los datos antes de que se inicie la app

    final tarjetaData = await ApiService().fetchTarjeta(); //funcion fetch asincrona
    AppData.tarjeta = tarjetaData;  // se precarga la API para que traiga los datos antes de que se inicie la app

    final sliderTiendaData = await ApiService().fetchSliderTienda(); //funcion fetch asincrona
    AppData.sliderTienda = sliderTiendaData;  // se precarga la API para que traiga los datos antes de que se inicie la app

    final mensajeData = await ApiService().fetchMensaje(email: 'example@email.com'); //funcion fetch asincrona
    AppData.mensaje= mensajeData;  // se precarga la API para que traiga los datos antes de que se inicie la app

  } catch (e) {
    print('Error cargando los sliders: $e');
    // Manejo en caso de errores
  }

  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MyApp(),
    ),
  ); // se ejecuta la app
}

class AppData {
  static List<Map<String, String>> sliderItems = [];
  static List<Map<String, String>> items = [];   // variables globales de la app y se precargan con los datos de la API
  static List<Map<String, String>> cursos = [];
  static List<Map<String, String>> tarjeta= [];
  static List<Map<String, String>> sliderTienda= [];
  static List<Map<String, String>> mensaje= [];

}

/// Widget principal que maneja el tema de la app y el splash screen
class MyApp extends StatefulWidget {  //se definen dos value notifier, el theme notifier que controla si es modo oscuro o claro y el selected que guarda el tema seleccionado
  static final ValueNotifier<bool> themeNotifier = ValueNotifier(false);
  static final ValueNotifier<String> selectedMenuOption = ValueNotifier('');

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MyApp.themeNotifier, //aplica el tema correspondiente a toda la app al inicar el splashscreen
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFEDEDED),
            primaryColor: const Color(0xFF000000),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF000000),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            splashColor: const Color(0xFF838383),
            highlightColor: const Color(0xFF838383),
            textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme),
          ),
          darkTheme: Oscuro.themeDark,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
        );
      },
    );
  }
}

/// Pantalla principal que incluye el Drawermenu y el BottomNavigationBar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedMenuOption = '';
  final List<Widget> _pages = [
    const Inicio(),
    const Tickets(),
    const ReservasScreen(), //aqui se hace la accion de los widgets, las pantallas disponibles en el bottombar
    const Tienda(),
    const Perfil(),
  ];

  /// Navegación desde el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      final options = ['Inicio', 'Tickets', 'Reservas', 'Tienda', 'Perfil'];
      _selectedMenuOption = options[index];
      MyApp.selectedMenuOption.value = _selectedMenuOption;
    });
  }

  /// Cierra el Drawer y navega a otra pantalla
  void _navigateToScreen(Widget screen) {
    Navigator.of(context).pop();
    Future.delayed(Duration.zero, () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    });
  }

  /// Actualiza el estado de la opción de un icono del bttombar seleccionada
  void _handleMenuSelection(String option) {
    setState(() {
      _selectedMenuOption = option;
      MyApp.selectedMenuOption.value = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final bool isDarkMode = MyApp.themeNotifier.value;

    final List<Map<String, dynamic>> menuItems = _buildDrawerMenu(isDarkMode);

    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBar(scaffoldKey),
      drawer: _buildDrawer(isDarkMode, menuItems, scaffoldKey),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavigationBar(isDarkMode),
    );
  }

  /// se construye la lista de las opcioes del drawermenu
  List<Map<String, dynamic>> _buildDrawerMenu(bool isDarkMode) {
    return [
      {
        'icon': FontAwesomeIcons.laptopCode,
        'label': 'Productos',
        'onTap': () {
          _handleMenuSelection('Productos');
          _navigateToScreen(ProductosTol());
        },
        'isDivider': false,
        'id': 'Productos',
      },

      {
        'icon': FontAwesomeIcons.globe,
        'label': 'Servicios',
        'onTap': () {
          _handleMenuSelection('Servicios');
          _navigateToScreen(Servicios());
        },
        'isDivider': false,
        'id': 'Servicios',
      },

      {
        'icon': FontAwesomeIcons.coins,
        'label': 'Cotizaciones',
        'onTap': () {
          _handleMenuSelection('Cotizaciones');
        },
        'isDivider': false,
        'id': 'Cotizaciones',
      },

      {'isDivider': true},
      {
        'icon': FontAwesomeIcons.locationDot,
        'label': 'Ubicación',
        'onTap': () {
          _handleMenuSelection('Ubicación');
          _navigateToScreen(MapaPage());
        },
        'isDivider': false,
        'id': 'Ubicación',
      },

      {
        'icon':
            isDarkMode ? FontAwesomeIcons.solidSun : FontAwesomeIcons.solidMoon,
        'label': isDarkMode ? 'Modo claro' : 'Modo oscuro',
        'onTap': () {
          setState(() => MyApp.themeNotifier.value = !isDarkMode);
        },
        'isDivider': false,
        'id': isDarkMode ? 'Modo claro' : 'Modo oscuro',
      },

      {
        'icon': FontAwesomeIcons.brain,
        'label': 'Generador de logos',
        'onTap': () {
          _handleMenuSelection('Generador de logos');
          _navigateToScreen(Logos());
        },
        'isDivider': false,
        'id': 'Generador de logos',
      },

      {
        'icon': FontAwesomeIcons.graduationCap,
        'label': 'Academia ToL',
        'onTap': () {
          _handleMenuSelection('Academia ToL');
          _navigateToScreen(Academia());
        },
        'isDivider': false,
        'id': 'Academia ToL',
      },

      {'isDivider': true},

      {
  'icon': FontAwesomeIcons.arrowRightFromBracket,
  'label': 'Cerrar sesión',
  'onTap': () async {
    // 1. Limpiar la sesión
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // O usar SessionHelper.clearSession()
    
    // 2. Redirigir a Bienvenida
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const Bienvenida(),
      ),
    );
  },
  'isDivider': false,
  'id': 'Cerrar sesión',
},

      {'isDivider': true},
    ];
  }

  /// AppBar con accesos a las opciones de configuración, notificaciones y perfil
  AppBar _buildAppBar(GlobalKey<ScaffoldState> scaffoldKey) {
    return AppBar(
      toolbarHeight: 80,
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.barsStaggered, color: Colors.white, size: 24), // icono del menu
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      
      actions: [
        IconButton(
          icon: Icon(FontAwesomeIcons.bell, color: Colors.white, size: 24), // icono de notificaciones
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificacionesScreen(userEmail: 'example@email.com')), // pantalla de notificaciones
            );
          },
        ),

        SizedBox(width: 10.w),

        IconButton(
          icon: const Icon(FontAwesomeIcons.gear, color: Colors.white), // icono de configuracion
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ConfigScreen()),
              ),
        ),

        SizedBox(width: 10.h),
        IconButton(
          icon: const Icon(FontAwesomeIcons.userLarge, color: Colors.white),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Perfil()),
              ),
        ),
      ],
      elevation: 0,
    );
  }

  /// Drawermenu con las opciones de los submenús de cotizaciones
  Widget _buildDrawer(
    bool isDarkMode,
    List<Map<String, dynamic>> menuItems,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) {
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Drawer(
      width: 300.w,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : const Color(0xFF000000),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown, // permite que el texto se ajuste al tamaño del drawer
              child: Text(
                'Centro de servicios',  // titulo del drawer
                style: GoogleFonts.rubik(
                  color: Colors.white, 
                  fontSize: ScreenUtil().deviceType == DeviceType.tablet ? 28.sp : 24.sp,                  
                ), // fuente del titulo
              ),
            ),
          ),
          
          ...menuItems.map((item) {
            if (item['isDivider'] == true) {
              return Divider(
                height: 1,
                thickness: 1,
                color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                indent: 16,
                endIndent: 16,
              );
            } else if (item['id'] == 'Cotizaciones') {
              return ExpansionTile(
                leading: Icon(item['icon'], color: textColor),
                title: Text(
                  item['label'],
                  style: GoogleFonts.rubik(color: textColor),
                ),
                children: [
                  ListTile(
                    title: Text(
                      'Cotización Aula Virtual',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      _handleMenuSelection('Cotización Aula Virtual');
                      _navigateToScreen(AulasVirtualesScreen());
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Cotización Sitios Web',
                      style: TextStyle(color: textColor),
                    ),
                    onTap: () {
                      _handleMenuSelection('Cotización Sitios Web');
                      _navigateToScreen(SitiosWebScreen());
                    },
                  ),
                ],
              );
            } else {
              bool isSelected = _selectedMenuOption == item['id'];
              return Container(
                color:
                    isSelected
                        ? Colors.grey.withOpacity(0.3)
                        : Colors.transparent,
                child: ListTile(
                  leading: Icon(item['icon'], color: textColor),
                  title: Text(
                    item['label'],
                    style: GoogleFonts.rubik(color: textColor),
                  ),
                  onTap: item['onTap'],
                  trailing:
                      isSelected
                          ? Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: textColor,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          )
                          : null,
                ),
              );
            }
          }).toList(),
        ],
      ),
    );
  }

  /// BottomNavigationBar con iconos personalizados
  Widget _buildBottomNavigationBar(bool isDarkMode) { // funcion que permite navegar a las diferentes pantallas
    final Color navBarBgColor = isDarkMode ? Colors.black : Colors.white;
    final Color selectedIconColor = isDarkMode ? Colors.white : Colors.black; //El color de fondo y de los íconos cambia según si el tema es oscuro o claro.
    final Color unselectedIconColor = Colors.grey;

    return Container(
      padding: const EdgeInsets.only(left: 1, right: 1, bottom: 0.2),
      child: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w), // altura del BottomNavigationBar el contenedor
        decoration: BoxDecoration(
          color: navBarBgColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              FontAwesomeIcons.house,
              _selectedIndex == 0,
              0,
              selectedIconColor,
              unselectedIconColor,
              size: 24.sp,
            ),
            _buildNavItem(
              FontAwesomeIcons.fileLines, //icono del tickets
              _selectedIndex == 1,
              1,
              selectedIconColor,
              unselectedIconColor,
              size: 24.sp,
            ),
            _buildNavItem(
              FontAwesomeIcons.calendarWeek, // icono de reservas
              _selectedIndex == 2,
              2,
              selectedIconColor,
              unselectedIconColor,
              size: 24.sp,
            ),
            _buildNavItem(
              FontAwesomeIcons.store, // icono de la tienda
              _selectedIndex == 3,
              3,
              selectedIconColor,
              unselectedIconColor,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  /// Item individual del BottomNavigationBar con punto rojo si está seleccionado
Widget _buildNavItem(
  IconData icon,
  bool isSelected,
  int index,
  Color selectedColor,
  Color unselectedColor,
  {required double size}
) {
  return Expanded(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(15.r),
        splashColor: Colors.grey.withOpacity(0.2),
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              if (isSelected)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ), 
              ],
          ),
        ),
      ),
    ),
  );
}
}

