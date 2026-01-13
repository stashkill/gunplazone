import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // User Info Section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            authProvider.user?.name?.isNotEmpty == true
                                ? authProvider.user!.name![0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        authProvider.user?.name ?? 'User',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.user?.email ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: authProvider.isAdmin
                              ? Colors.orange.withOpacity(0.2)
                              : Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          authProvider.isAdmin ? 'Admin' : 'User',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: authProvider.isAdmin ? Colors.orange : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Stats Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(context, 'Orders', '5'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(context, 'Favorites', '12'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(context, 'Reviews', '3'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Menu Items
                _buildMenuItem(
                  context,
                  Icons.shopping_bag_outlined,
                  'My Orders',
                  () => context.push('/orders'),
                ),
                _buildMenuItem(
                  context,
                  Icons.favorite_outline,
                  'Favorites',
                  () {},
                ),
                _buildMenuItem(
                  context,
                  Icons.location_on_outlined,
                  'Addresses',
                  () {},
                ),
                _buildMenuItem(
                  context,
                  Icons.payment_outlined,
                  'Payment Methods',
                  () {},
                ),
                _buildMenuItem(
                  context,
                  Icons.notifications_outlined,
                  'Notifications',
                  () {},
                ),
                const Divider(height: 32),
                // Theme Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Dark Mode',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (_) => themeProvider.toggleTheme(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32),
                // Admin Panel (if admin)
                if (authProvider.isAdmin)
                  _buildMenuItem(
                    context,
                    Icons.admin_panel_settings_outlined,
                    'Admin Panel',
                    () => context.push('/admin'),
                  ),
                // Logout
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => _handleLogout(context, authProvider),
                      child: const Text('Logout'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/cart');
              break;
            case 2:
              context.go('/chat');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<void> _handleLogout(BuildContext context, AuthProvider authProvider) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (context.mounted) {
                context.go('/sign-in');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
