// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/role_selection/role_selection_screen.dart';

void main() {
  runApp(const ConsultationApp());
}

class ConsultationApp extends StatelessWidget {
  const ConsultationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ФИНКИ - Консултации',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.lightBlue,
          secondary: Colors.lightBlue[300]!,
        ),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black87),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
          ),
        ),

        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
      ),

      home: const RoleSelectionScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('mk', 'MK'),
        Locale('en', 'US'),
      ],
    );
  }
}