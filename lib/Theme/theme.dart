import 'package:flutter/material.dart';

class AppColors {
  static Color primary(bool isDarkMode) =>
      isDarkMode ? const Color(0xFF001F70) : const Color(0xFF001F70);
  static Color background(bool isDarkMode) =>
      isDarkMode ? const Color(0xFF303030) : const Color(0xFFF2F5F8);
  static Color fuente(bool isDarkMode) =>
      isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFF232222);
  static Color sidebar(bool isDarkMode) =>
      isDarkMode ? const Color(0xFF212121) : const Color(0xFFC9D5E3);
  static Color element(bool isDarkMode) =>
      isDarkMode ? const Color(0xFF424242) : const Color(0xFFE4EAF1);
  static Color floating(bool isDarkMode) =>
      isDarkMode ? const Color(0xFF424242) : const Color(0xFF233243);
  static Color placeholder(bool isDarkMode) =>
      isDarkMode ? const Color(0xFFC7C6C6) : const Color(0xFF575757);
  static Color shadows(bool isDarkMode) =>
      isDarkMode ? const Color(0xFF000000) : const Color(0xFF212121);
  static Color buttonText(bool isDarkMode) =>
      isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF);
}

class AppIcons {
  static Widget customIcon(BuildContext context, {double size = 200}) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Image.asset(
      isDarkMode ? 'assets/icons/logo_bco.png' : 'assets/icons/logo_azul.png',
      width: size,
    );
  }
}

ThemeData getAppTheme(bool isDarkMode) {
  return ThemeData(
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    primaryColor: AppColors.primary(isDarkMode),
    scaffoldBackgroundColor: AppColors.background(isDarkMode),

    // Tema para la AppBar (barra superior de la aplicación)
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.sidebar(isDarkMode),
    ),

    // Definición de la temática de los textos
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.fuente(isDarkMode)), // Texto grande
      bodyMedium:
          TextStyle(color: AppColors.fuente(isDarkMode)), // Texto mediano
    ),

    // Estilos para los campos de entrada de texto
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
          color: AppColors.fuente(isDarkMode)), // Estilo de la etiqueta
      hintStyle: TextStyle(
          color: AppColors.placeholder(
              isDarkMode)), // Estilo del placeholder (texto guía)

      // Borde cuando el campo de entrada está enfocado
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary(isDarkMode)),
      ),

      // Borde cuando el campo de entrada está habilitado pero no enfocado
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.placeholder(isDarkMode)),
      ),
    ),

    // Configuración del cursor y selección de texto
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary(isDarkMode), // Color del cursor
      selectionColor: AppColors.primary(isDarkMode)
          .withOpacity(0.5), // Color de selección de texto
      selectionHandleColor:
          AppColors.primary(isDarkMode), // Color del controlador de selección
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            AppColors.primary(isDarkMode)), // Color de fondo del botón
        foregroundColor: MaterialStateProperty.all(
            AppColors.buttonText(isDarkMode)), // Color del texto
        textStyle: MaterialStateProperty.all(
          const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold), // Tamaño y estilo del texto
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(double.infinity, 48),
        ),
      ),
    ),

    // Tema para los checkboxes
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary(isDarkMode);
          }
          return null;
        },
      ),
      checkColor:
          MaterialStateProperty.all<Color>(AppColors.buttonText(isDarkMode)),
      side: BorderSide(color: AppColors.primary(isDarkMode), width: 2),
      splashRadius: 20,
    ),

    // Configuración para indicadores de progreso
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary(isDarkMode), // Color del indicador de carga
    ),

    // Configuración para las tarjetas (Card)
    cardTheme: CardTheme(
      color: AppColors.element(isDarkMode), // Color de fondo de las tarjetas
    ),

    // // Tema para los diálogos emergentes (AlertDialog)
    dialogTheme: DialogTheme(
      backgroundColor:
          AppColors.background(isDarkMode), // Color de fondo del diálogo

      // Estilo del título del diálogo
      titleTextStyle: TextStyle(
        color: AppColors.fuente(isDarkMode),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),

        // Estilo del contenido del diálogo
        contentTextStyle: TextStyle(
          color: AppColors.fuente(isDarkMode),
          fontSize: 16,
        ),

        // Forma del diálogo (borde redondeado)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
    ),

    // Configuración para los ExpansionTiles (listas desplegables)
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor:
          AppColors.element(isDarkMode), // Color de fondo del tile expandido
      collapsedBackgroundColor:
          AppColors.background(isDarkMode), // Color cuando está cerrado
      textColor: AppColors.fuente(isDarkMode), // Color del texto expandido
      collapsedTextColor: AppColors.fuente(isDarkMode)
          .withOpacity(0.7), // Color del texto cuando está cerrado
      iconColor: AppColors.primary(isDarkMode), // Color del icono expandido
      collapsedIconColor: AppColors.primary(isDarkMode)
          .withOpacity(0.7), // Color del icono cerrado

      // Bordes redondeados
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    // Configuración para los elementos de la lista (ListTile)
    listTileTheme: ListTileThemeData(
      selectedTileColor: AppColors.buttonText(isDarkMode),
      iconColor: AppColors.primary(isDarkMode),
      textColor: AppColors.fuente(isDarkMode),
      selectedColor: AppColors.buttonText(isDarkMode),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    // Configuración para los Drawer (menú lateral)
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.sidebar(isDarkMode), // Color de fondo del menú
    ),

    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary(isDarkMode);
          }
          return null;
        },
      ),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary(isDarkMode),
      inactiveTrackColor: AppColors.placeholder(isDarkMode),
      thumbColor: AppColors.primary(isDarkMode),
      overlayColor: AppColors.primary(isDarkMode).withOpacity(0.5),
      valueIndicatorColor: AppColors.primary(isDarkMode),
      valueIndicatorTextStyle: TextStyle(
        color: AppColors.buttonText(isDarkMode),
      ),
    ),

  );
}
