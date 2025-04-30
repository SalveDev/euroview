import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatearFecha(String fecha) {
  try {
    // Definir el formato esperado de la fecha
    DateFormat formatoEntrada = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", "en_US");
    DateFormat formatoSalida = DateFormat("dd/MM/yyyy");

    // Convertir el string a DateTime
    DateTime fechaParseada = formatoEntrada.parse(fecha);

    // Formatear al formato deseado
    return formatoSalida.format(fechaParseada);
  } catch (e) {
    return 'Fecha inválida';
  }
}



Future<void> mostrarDialogo(BuildContext context, String mensaje) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // El usuario debe presionar el botón para cerrar el diálogo
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Mensaje'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(mensaje),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}