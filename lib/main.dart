import 'package:flutter/material.dart';
import 'package:e_commerce_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/providers/cart_provider.dart';
import 'package:e_commerce_app/providers/order_provider.dart';
import 'package:e_commerce_app/providers/favorites_provider.dart';
import 'package:e_commerce_app/providers/address_provider.dart';
import 'package:e_commerce_app/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}