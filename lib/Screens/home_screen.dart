import 'package:flutter/material.dart';
import 'package:gersa_regionales/Providers/theme_provider.dart';
import '../Models/userModel.dart';
import '../Config/api_config.dart';
import '../services/api_service.dart';
import '../Theme/theme.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String employeeNumber = User.id;
  List<dynamic> revisiones = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    dataInicio();
  }

  Future<void> dataInicio() async {
    setState(() {
      cargando = true;
    });

    final response = await ApiService()
        .postRequest(ApiConfig.inicio, {"employee_number": employeeNumber});

    if (response["success"] == true) {
      final data = response['data'];

      setState(() {
        revisiones = data['revisiones'];
        User.roles = data['roles'];
        cargando = false;
      });
    } else {
      setState(() {
        cargando = false;
      });
      print(response["error"] ?? "Error desconocido");
    }
  }

  Future<void> refresh() async {
    // await Future.delayed(Duration(milliseconds: 500));
    final response = await ApiService()
        .postRequest(ApiConfig.inicio, {"employee_number": employeeNumber});

    if (response["success"] == true) {
      final data = response['data'];

      setState(() {
        revisiones = data['revisiones'];
        User.roles = data['roles'];
      });
    }
  }

  void nuevaRevision(BuildContext context) async {
    final List roles = User.roles;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona un rol'),
          content: Text('¿Cómo quieres hacer tu revisión?'),
          actions: [
            Column(
              children: roles.map((rol) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, rol);
                    },
                    child: Text(rol),
                  ),
                );
              }).toList(),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hola, ${User.nombre}')),
      body: cargando
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : RefreshIndicator(
              onRefresh:refresh, // Llamar a la función al hacer pull-to-refresh
              color: AppColors.primary(Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark),
              backgroundColor: AppColors.background(Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mis últimas revisiones',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: revisiones.length,
                        itemBuilder: (context, index) {
                          final revision = revisiones[index];
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Icon(Icons.history),
                              title: Text('Sucursal: ${revision["sucursal"]}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Fecha: ${revision["fecha"]}'),
                                  Text(
                                      'Calificación: ${revision["calificacion"]}'),
                                  Text('Duración: ${revision["duracion"]} min'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          nuevaRevision(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: Text('Nueva Revisión'),
                      ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
