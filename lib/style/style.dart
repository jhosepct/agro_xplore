import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData uiTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff4caf50), // Un verde suave como color principal (primary)
    ),
    useMaterial3: true, // Material Design 3
    textTheme: Typography.material2021().black, // Estilo de texto para Material 3
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      elevation: 0, // Sin sombra en el AppBar
      backgroundColor: Colors.transparent, // AppBar transparente
      foregroundColor: Colors.white, // Color del texto e íconos en el AppBar
    ),
   /* elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.greenAccent), // Color verde suave para botones elevados
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white, // Fondo blanco para los campos de texto
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)), // Bordes redondeados
      ),
    ),*/
  );
}
