import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, _) {
          if (!authProvider.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Not logged in'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/sign-in'),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          (authProvider.userName ?? 'U').substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        authProvider.userName ?? 'User',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        authProvider.email ?? 'No email',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: authProvider.isAdmin ? Colors.red[100] : Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          authProvider.isAdmin ? 'Admin' : 'User',
                          style: TextStyle(
                            color: authProvider.isAdmin ? Colors.red : Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Menu Items
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  onTap: () => context.go('/home/orders'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.favorite_outline,
                  title: 'Favorites',
                  onTap: () => context.go('/home/favorites'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Addresses',
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.payment_outlined,
                  title: 'Payment Methods',
                  onTap: () {},
                ),
                if (authProvider.isAdmin)
                  _buildMenuItem(
                    context,
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Admin Panel',
                    onTap: () => context.go('/home/admin'),
                  ),
                const Divider(),
                // Settings
                _buildMenuItem(
                  context,
                  icon: Icons.brightness_6_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                  ),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {},
                ),
                const Divider(),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _handleLogout(context, authProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        VoidCallback? onTap,
        Widget? trailing,
      }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _handleLogout(BuildContext context, AuthProvider authProvider) {
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
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pop(context);
                context.go('/sign-in');
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
