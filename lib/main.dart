import 'package:juststock/Onboarding%20screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:juststock/Dark%20mode.dart';
import 'package:juststock/services/api_locator.dart';
import 'package:juststock/services/in_app_notification_center.dart';
import 'package:juststock/services/local_push_notifications.dart';
import 'package:juststock/services/push_messaging_bridge.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiLocator.init();
  await LocalPushNotifications.initialize();
  // Initialize remote push (FCM) if configured
  await initPushMessaging();
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
        ChangeNotifierProvider(
          create: (_) => NotificationCenter(rootNavigatorKey),
        ),
      ],
      builder: (_, context) {
        return MaterialApp(
          navigatorKey: rootNavigatorKey,
          theme: ThemeData(
            useMaterial3: false,
            primaryColor: const Color(0xFF8B0000),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B0000),
              secondary: Color(0xFF8B0000),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B0000)),
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
