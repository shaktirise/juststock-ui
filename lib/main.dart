import 'package:crowwn/Onboarding%20screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crowwn/Dark%20mode.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ColorNotifire(),
        ),
      ],
      builder: (_, context) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: false,
            primaryColor: const Color(0xFFD32F2F),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFD32F2F),
              secondary: Color(0xFFD32F2F),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF0F172A),
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xFF0F172A)),
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            dividerColor: Colors.transparent,
          ),
          debugShowCheckedModeBanner: false,
          home: const Splash(),
        );
      },
    );
  }
}
