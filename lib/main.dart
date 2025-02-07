import 'package:flutter/material.dart';
import 'package:gersa_regionales/Screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Theme/theme.dart';
import 'Providers/theme_provider.dart';
import 'Screens/login_screen.dart';
import 'Screens/home_screen.dart';

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
  Future<String?> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await Future.delayed(Duration(seconds: 2));
    return prefs.getString('employee_id'); // Devuelve el ID si hay sesión
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<String?>(
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

        // Si hay un usuario guardado, ir a HomeScreen, de lo contrario, ir a LoginScreen
        final bool isLoggedIn = snapshot.data != null;

        return MaterialApp(
          title: 'Comprador Misterioso',
          themeMode: themeProvider.themeMode,
          theme: getAppTheme(false),
          darkTheme: getAppTheme(true),
          home: isLoggedIn ? HomeScreen() : LoginScreen(),
        );
      },
    );
  }
}