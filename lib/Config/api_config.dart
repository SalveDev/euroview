class ApiConfig {
  // URL base del servidor
  static const String domain = "gersadev.com";
  static const String baseUrl = "http://$domain/regionWatch";

  // Endpoints de la API
  static const String login = "$baseUrl/login";
  static const String inicio = "$baseUrl/inicio";
  static const String refresh = "$baseUrl/refresh";
  static const String sucursales = "$baseUrl/sucursales";
  static const String iniciarRevision = "$baseUrl/iniciarRevision";
  static const String obtenerRevision = "$baseUrl/obtenerRevision";
  static const String obtenerVieja = "$baseUrl/obtenerVieja";
  static const String cancelarRevision = "$baseUrl/cancelarRevision";
  static const String finalizarRevision = "$baseUrl/finalizarRevision";
}