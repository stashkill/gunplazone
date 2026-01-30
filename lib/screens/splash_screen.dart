import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Tunggu selama 2 detik untuk efek splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Ambil status autentikasi dari AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // PERBAIKAN: Cek status login, jika sudah login ke home, jika belum ke sign-in
    if (authProvider.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BUG Fix: Menggunakan Image.asset untuk memanggil assets/logo.png
            Image.asset(
              'assets/logo.png',
              width: 350,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Cadangan jika file logo.png tidak ditemukan
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'GZ',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'GunplaZone',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toko Gunpla Kesayangmu!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
