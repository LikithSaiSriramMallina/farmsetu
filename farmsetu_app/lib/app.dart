import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';

class FarmSetuApp extends StatelessWidget {
  const FarmSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FarmSetu",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routes: {
        '/': (_) => const HomeScreen(),
        '/add': (_) => const AddProductScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}