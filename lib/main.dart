import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Theme/theme.dart';
import 'Providers/theme_provider.dart';
import 'Screens/loading_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/home_screen.dart';
import 'Screens/revision_screen.dart'; // Importa la pantalla de revisión

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Map<String, String?>> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? employeeId = prefs.getString('employee_id');
    String? respuestasGuardadas = prefs.getString('respuestas_revision');
    String? nombreSucursal = prefs.getString('nombre_sucursal');
    String? rol = prefs.getString('rol');
    String? uuid = prefs.getString('uuid');

    if (respuestasGuardadas != null && respuestasGuardadas.isNotEmpty) {
      return {
        'screen': 'revision',
        'nombreSucursal': nombreSucursal,
        'rol': rol,
        'uuid': uuid,
      };
    } else if (employeeId != null) {
      return {'screen': 'home'};
    } else {
      return {'screen': 'login'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<Map<String, String?>>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: getAppTheme(false),
            darkTheme: getAppTheme(true),
            home: LoadingScreen(),
          );
        }

        String? screen = snapshot.data?['screen'];
        String? nombreSucursal = snapshot.data?['nombreSucursal'];
        String? rol = snapshot.data?['rol'];
        String? uuid = snapshot.data?['uuid'];

        Widget homeScreen;
        if (screen == 'revision') {
          homeScreen = RevisionScreen(
            nombreSucursal: nombreSucursal,
            rol: rol,
            uuid: uuid,
          );
        } else if (screen == 'home') {
          homeScreen = HomeScreen();
        } else {
          homeScreen = LoginScreen();
        }

        return MaterialApp(
          title: 'Comprador Misterioso',
          themeMode: ThemeMode.system,
          theme: getAppTheme(false),
          darkTheme: getAppTheme(true),
          home: homeScreen,
        );
      },
    );
  }
}
