import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gersa_regionales/Config/api_config.dart';
import 'package:gersa_regionales/Models/userModel.dart';
import 'package:gersa_regionales/Providers/theme_provider.dart';
import 'package:gersa_regionales/Screens/revision_screen.dart';
import 'package:gersa_regionales/Theme/theme.dart';
import 'package:gersa_regionales/services/api_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NuevaRevisionScreen extends StatefulWidget {
  @override
  _NuevaRevisionScreenState createState() => _NuevaRevisionScreenState();
}

class _NuevaRevisionScreenState extends State<NuevaRevisionScreen> {
  Position? _currentPosition;
  List<dynamic> _sucursales = [];
  List<dynamic> _roles = [];
  String? _selectedSucursal;
  String? _selectedRol;
  bool cargando = true;
  SharedPreferences? prefs;
  String? employeeNumber;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    employeeNumber = prefs?.getString('employee_id');
    verificarGPSyUbicacion();
  }

  Future<void> verificarGPSyUbicacion() async {
    bool gpsHabilitado = await isGPSEnabled();
    if (gpsHabilitado) {
      await getLocation();
    }
  }

  Future<bool> isGPSEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('GPS Desactivado'),
              content: Text('Por favor, active el GPS para continuar.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      return false;
    }
    return true;
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Permiso de ubicación denegado');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Permiso de ubicación denegado permanentemente');
      // mostrar dialogo para ir a configuraciones
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permiso de ubicación denegado permanentemente'),
              content: Text(
                  'Por favor, vaya a configuraciones y habilite los permisos de ubicación.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Geolocator.openAppSettings();
                  },
                ),
              ],
            );
          },
        );
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      getSucursales();
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  Future<void> getSucursales() async {
    setState(() {
      cargando = true;
    });

    final response = await ApiService().postRequest(ApiConfig.sucursales, {
      "latitud": _currentPosition!.latitude,
      "longitud": _currentPosition!.longitude,
      "employee_number": employeeNumber
    });

    if (response["success"] == true) {
      final data = response['data'];

      setState(() {
        _sucursales = data['sucursales'];
        _roles = User.roles;
        _selectedSucursal = _sucursales.isNotEmpty
            ? _sucursales[0]['sucursal'].toString()
            : null;
        _selectedRol = _roles.isNotEmpty ? _roles[0] : null;
        cargando = false;
      });
    } else {
      setState(() {
        cargando = false;
      });
      print(response["error"] ?? "Error desconocido");
    }
  }

  Future<void> iniciarRevision() async {
    setState(() {
      cargando = true;
    });

    final response = await ApiService().postRequest(ApiConfig.iniciarRevision, {
      "latitud": _currentPosition!.latitude,
      "longitud": _currentPosition!.longitude,
      "sucursal": _selectedSucursal,
      "rol": _selectedRol,
      "employee_number": employeeNumber
    });

    if (response["success"] == true) {
      final data = response['data'];
      print(data);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => RevisionScreen(
            nombreSucursal: _sucursales
                .firstWhere((element) =>
                    element['sucursal'].toString() == _selectedSucursal)
                ['nombre'],
            rol: _selectedRol,
            uuid: data['uuid'],
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        cargando = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, ponte en contacto con soporte.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Revisión')),
      body: cargando
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : RefreshIndicator(
              onRefresh: verificarGPSyUbicacion, // Hace que el refresh funcione
              color: AppColors.primary(
                  Theme.of(context).brightness == Brightness.dark),
              backgroundColor: AppColors.background(
                  Theme.of(context).brightness == Brightness.dark),
              child: ListView(
                // Reemplazamos Column por ListView para hacer scroll
                physics:
                    AlwaysScrollableScrollPhysics(), // Permite hacer pull-to-refresh
                padding: EdgeInsets.all(16.0),
                children: [
                  Text(
                    'Seleccione una sucursal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownMenu<String>(
                        initialSelection: _sucursales.isNotEmpty
                            ? _sucursales[0]['sucursal'].toString()
                            : null,
                        expandedInsets: EdgeInsets.zero,
                        textStyle: TextStyle(fontSize: 16),
                        dropdownMenuEntries: [
                          for (var sucursal in _sucursales)
                            DropdownMenuEntry(
                              value: sucursal['sucursal'].toString(),
                              label: sucursal['nombre'],
                            )
                        ],
                        onSelected: (String? value) {
                          setState(() {
                            _selectedSucursal = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownMenu<String>(
                        initialSelection: _roles.isNotEmpty ? _roles[0] : null,
                        expandedInsets: EdgeInsets.zero,
                        textStyle: TextStyle(fontSize: 16),
                        dropdownMenuEntries: [
                          for (var rol in _roles)
                            DropdownMenuEntry(
                              value: rol,
                              label: rol,
                            )
                        ],
                        onSelected: (String? value) {
                          setState(() {
                            _selectedRol = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(
                          double.parse(_currentPosition!.latitude.toString()),
                          double.parse(_currentPosition!.longitude.toString()),
                        ),
                        zoom: 15.0,
                        interactiveFlags: InteractiveFlag.none,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                double.parse(
                                    _currentPosition!.latitude.toString()),
                                double.parse(
                                    _currentPosition!.longitude.toString()),
                              ),
                              width: 80,
                              height: 80,
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Ubicación actual: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print("Sucursal seleccionada: $_selectedSucursal");
                      print("Rol seleccionado: $_selectedRol");
                      iniciarRevision();
                    },
                    child: Text('Continuar'),
                  ),
                  SizedBox(height: 300), // Agregar espacio para permitir scroll
                ],
              ),
            ),
    );
  }
}
