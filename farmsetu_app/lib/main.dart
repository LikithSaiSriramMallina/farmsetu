import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/saved_products_provider.dart';
import 'providers/address_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/farmer_auth_provider.dart';
import 'providers/products_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/farmer/farmer_home_screen.dart';
import 'screens/farmer/farmer_pending_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:          Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final languageProvider = LanguageProvider();
  await languageProvider.init();

  final themeProvider = ThemeProvider();
  await themeProvider.init();

  final savedProvider = SavedProductsProvider();
  await savedProvider.init();

  final addressProvider = AddressProvider();
  await addressProvider.init();

  final farmerAuthProvider = FarmerAuthProvider();
  await farmerAuthProvider.init();

  final authProvider = AuthProvider();
  await authProvider.init();

  runApp(FarmsetuApp(
    languageProvider:   languageProvider,
    themeProvider:      themeProvider,
    savedProvider:      savedProvider,
    addressProvider:    addressProvider,
    farmerAuthProvider: farmerAuthProvider,
    authProvider:       authProvider,
  ));
}

class FarmsetuApp extends StatelessWidget {
  final LanguageProvider      languageProvider;
  final ThemeProvider         themeProvider;
  final SavedProductsProvider savedProvider;
  final AddressProvider       addressProvider;
  final FarmerAuthProvider    farmerAuthProvider;
  final AuthProvider          authProvider;

  const FarmsetuApp({
    super.key,
    required this.languageProvider,
    required this.themeProvider,
    required this.savedProvider,
    required this.addressProvider,
    required this.farmerAuthProvider,
    required this.authProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider.value(value: farmerAuthProvider),
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: savedProvider),
        ChangeNotifierProvider.value(value: addressProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, theme, __) => MaterialApp(
          title:                     'Farmsetu',
          debugShowCheckedModeBanner: false,
          theme:     AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: theme.themeMode,
          home: const _RootRouter(),
        ),
      ),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    final farmerAuth = context.watch<FarmerAuthProvider>();
    final auth       = context.watch<AuthProvider>();

    // ── Step 1: still initialising ──────────────────────────────
    if (farmerAuth.isLoading || auth.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0D0D),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🌿', style: TextStyle(fontSize: 48)),
              SizedBox(height: 16),
              CircularProgressIndicator(color: Color(0xFF4CAF50)),
            ],
          ),
        ),
      );
    }

    // ── Step 2: farmer logged in ─────────────────────────────────
    if (farmerAuth.isLoggedIn) {
      if (farmerAuth.isApproved) return const FarmerHomeScreen();
      return const FarmerPendingScreen();
    }

    // ── Step 3: customer logged in ───────────────────────────────
    if (auth.isLoggedIn) return const HomeScreen();

    // ── Step 4: nobody logged in ─────────────────────────────────
    return const LoginScreen();
  }
}