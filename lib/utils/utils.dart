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