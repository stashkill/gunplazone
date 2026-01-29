import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Validasi email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Handle Continue Button
  void _handleContinue() async {
    final email = _emailController.text.trim();

    // Validasi email kosong
    if (email.isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return;
    }

    // Validasi format email
    if (!_isValidEmail(email)) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Hardcode admin email untuk fallback login
      const adminEmail = 'admin@gunplazone.com';

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAdmin = email.toLowerCase() == adminEmail.toLowerCase();

      authProvider.setUser(
        email,
        isAdmin ? 'Admin' : 'User',
        role: isAdmin ? 'admin' : 'user',
        userId: email,
      );

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate ke home screen
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Login failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Handle Google Sign In
  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _showInfoSnackBar('Google Sign In - Coming Soon');
      // TODO: Implement Google Sign In dengan firebase_auth
      // Untuk sekarang, gunakan email dummy
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setEmail('user@gmail.com');
      authProvider.setUser('user@gmail.com', 'User');

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Google Sign In failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Handle Apple Sign In
  void _handleAppleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _showInfoSnackBar('Apple Sign In - Coming Soon');
      // TODO: Implement Apple Sign In dengan sign_in_with_apple
      // Untuk sekarang, gunakan email dummy
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setEmail('user@apple.com');
      authProvider.setUser('user@apple.com', 'User');

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Apple Sign In failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Show Error SnackBar
  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Show Info SnackBar
  void _showInfoSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Section
                SizedBox(height: screenSize.height * 0.05),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0099CC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'GZ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),

                // App Title
                Text(
                  'GunplaZone',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),

                // Subtitle
                Text(
                  'Create an account',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  'Enter your email to sign up for this app',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenSize.height * 0.04),

                // Email Input Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: 'email@domain.com',
                    labelText: 'Email',
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF0099CC),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.04),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0099CC),
                      disabledBackgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.03),

                // Google Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: Colors.grey[400]!,
                        width: 1.5,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🔵'),
                        SizedBox(width: 12),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Color(0xFF0099CC),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),

                // Apple Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _handleAppleSignIn,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: Colors.grey[400]!,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🍎'),
                        const SizedBox(width: 12),
                        Text(
                          'Continue with Apple',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),

                // Terms & Privacy
                Text(
                  'By clicking continue, you agree to our Terms of Service\nand Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
