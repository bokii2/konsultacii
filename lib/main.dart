// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/role_selection/role_selection_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Skopje'));
  runApp(const ConsultationApp());
}

class SnackBarService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
  GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String message, {bool isError = false}) {
    if (messengerKey.currentState != null) {
      messengerKey.currentState!.clearSnackBars();
      messengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
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

      home: RoleSelectionScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('mk', 'MK'),
        Locale('en', 'US'),
      ],
      scaffoldMessengerKey: SnackBarService.messengerKey,
    );
  }
}