// lib/main.dart
import 'package:flutter/material.dart';
import 'services/hive_service.dart';
import 'services/default_data_loader.dart';
import 'screens/search_screen.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ تهيئة Hive
  await HiveService.init();

  // 2️⃣ تحميل البيانات الافتراضية JSON + الصور عند أول تشغيل
  await DefaultDataLoader.loadIfEmpty();

  // 3️⃣ تشغيل التطبيق
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
      theme: AppTheme.theme,
      home: const SearchScreen(),
    );
  }
}
