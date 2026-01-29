import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/orders_screen.dart';
import '../screens/admin/admin_panel_screen.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
  GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/splash',
      debugLogDiagnostics: true,
      refreshListenable: authProvider, // ✅ CRITICAL: Listen to auth changes
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final location = state.matchedLocation;

        print('🔍 Redirect check: isAuthenticated=$isAuthenticated, location=$location');

        // If on splash, stay on splash
        if (location == '/splash') {
          return null;
        }

        // If on root, redirect based on auth status
        if (location == '/' || location.isEmpty) {
          if (isAuthenticated) {
            return '/home';
          } else {
            return '/splash';
          }
        }

        // If not authenticated and not on sign-in, go to sign-in
        if (!isAuthenticated && location != '/sign-in') {
          print('❌ Not authenticated, redirecting to /sign-in');
          return '/sign-in';
        }

        // If authenticated and on sign-in, go to home
        if (isAuthenticated && location == '/sign-in') {
          print('✅ Authenticated, redirecting to /home');
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'product/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                return ProductDetailScreen(productId: id);
              },
            ),
            GoRoute(
              path: 'cart',
              builder: (context, state) => const CartScreen(),
            ),
            GoRoute(
              path: 'checkout',
              builder: (context, state) => const CheckoutScreen(),
            ),
            GoRoute(
              path: 'chat',
              builder: (context, state) => const ChatScreen(),
            ),
            GoRoute(
              path: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: 'orders',
              builder: (context, state) => const OrdersScreen(),
            ),
            GoRoute(
              path: 'admin',
              builder: (context, state) => const AdminPanelScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
