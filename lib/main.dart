import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/chat_provider.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const GunplaZoneApp(),
    ),
  );
}

class GunplaZoneApp extends StatefulWidget {
  const GunplaZoneApp({Key? key}) : super(key: key);

  @override
  State<GunplaZoneApp> createState() => _GunplaZoneAppState();
}

class _GunplaZoneAppState extends State<GunplaZoneApp> {
  late final _appRouter;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _appRouter = AppRoutes.createRouter(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AuthProvider>(
      builder: (context, themeProvider, authProvider, _) {
        // Sync token to ProductProvider whenever auth state changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<ProductProvider>(context, listen: false)
              .updateToken(authProvider.token);
        });

        return MaterialApp.router(
          title: 'GunplaZone',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: _appRouter,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('id', 'ID'),
            Locale('en', 'US'),
          ],
        );
      },
    );
  }
}
