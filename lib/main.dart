// lib/main.dart
import 'package:flutter/material.dart';
import 'services/hive_service.dart';
import 'screens/search_screen.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,

      builder: (context, child) {
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: child ?? const SizedBox.shrink(),
        );
      },

      /// 👇 هنا التعديل الوحيد
      theme: AppTheme.theme,

      home: const SearchScreen(),
    );
  }
}
