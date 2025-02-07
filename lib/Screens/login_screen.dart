import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gersa_regionales/Config/api_config.dart';
import '../services/api_service.dart';
import '../Theme/theme.dart';
import 'home_screen.dart';
import '../Models/userModel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController employeeNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  String mensaje = "";

  @override
  void initState() {
    super.initState();
  }

  void login() async {
    final String employeeNumber = employeeNumberController.text.trim();
    final String password = passwordController.text.trim();

    if (employeeNumber.isEmpty || password.isEmpty) {
      setState(() {
        mensaje = "Por favor complete todos los campos";
      });
      return;
    }

    final response = await apiService.postRequest(ApiConfig.login, {
      "employee_number": employeeNumber,
      "password": password,
    });

    if (response["success"] == true) {
      final data = response['data'];
      User.nombre = data['nombre'];
      User.id = employeeNumber;

      // Guardar sesión en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('employee_id', employeeNumber);
      await prefs.setString('employee_name', data['nombre']);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        mensaje = response["error"] ?? "Error desconocido";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: AppIcons.customIcon(context, size: 300),
              ),
              SizedBox(height: 20),
              TextField(
                controller: employeeNumberController,
                decoration: InputDecoration(labelText: 'Número de empleado'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                child: Text('Iniciar sesión'),
              ),
              SizedBox(height: 10),
              Text(mensaje),
            ],
          ),
        ),
      ),
    );
  }
}