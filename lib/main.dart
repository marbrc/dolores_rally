import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentacion/pantalla_inicio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(
    title: 'Rally de la Independencia AR',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFFE91E8C),
      scaffoldBackgroundColor: const Color(0xFFFFF0F6),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFC1DC),
        foregroundColor: Color(0xFF8A1459),
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Color(0xFF8A1459),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFE91E8C),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFC2185B),
          side: const BorderSide(color: Color(0xFFF48FB1), width: 2),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
      ),
    ),
    home: const PantallaInicio(),
  ));
}
