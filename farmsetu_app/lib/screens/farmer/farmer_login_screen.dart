import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/farmer_auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import 'farmer_home_screen.dart';
import 'farmer_pending_screen.dart';
import 'farmer_register_screen.dart';

class FarmerLoginScreen extends StatefulWidget {
  const FarmerLoginScreen({super.key});
  @override
  State<FarmerLoginScreen> createState() => _FarmerLoginScreenState();
}

class _FarmerLoginScreenState extends State<FarmerLoginScreen> {
  final _email    = TextEditingController();
  final _password = TextEditingController();
  bool  _obscure  = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final p   = context.read<FarmerAuthProvider>();
    final err = await p.login(_email.text.trim(), _password.text.trim());
    if (!mounted) return;
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    if (p.isApproved) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const FarmerHomeScreen()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const FarmerPendingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c       = context.col;
    final loading = context.watch<FarmerAuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Back
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: c.surfaceHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.arrow_back_ios_new_rounded,
                      size: 16, color: c.textPrimary),
                ),
              ),
              const SizedBox(height: 32),
              // Icon
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.agriculture_rounded,
                    color: AppTheme.primaryGreen, size: 34),
              ),
              const SizedBox(height: 20),
              Text('Farmer Portal',
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 6),
              Text('Sign in to manage your farm & orders',
                  style: TextStyle(
                      color: c.textSecondary, fontSize: 14)),
              const SizedBox(height: 36),

              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppTheme.error.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.error_outline_rounded,
                        color: AppTheme.error, size: 16),
                    const SizedBox(width: 8),
                    Text(_error!,
                        style: const TextStyle(
                            color: AppTheme.error, fontSize: 13)),
                  ]),
                ),
                const SizedBox(height: 16),
              ],

              // Email
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Email address',
                  prefixIcon: Icon(Icons.email_outlined,
                      color: c.textSecondary, size: 18),
                ),
              ),
              const SizedBox(height: 12),

              // Password
              TextFormField(
                controller: _password,
                obscureText: _obscure,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline_rounded,
                      color: c.textSecondary, size: 18),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: c.textSecondary, size: 18,
                    ),
                    onPressed: () =>
                        setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : _login,
                  child: loading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2))
                      : const Text('Sign In',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 28),

              // Register link
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const FarmerRegisterScreen())),
                  child: RichText(
                    text: TextSpan(
                      text: "New farmer? ",
                      style: TextStyle(
                          color: c.textSecondary, fontSize: 14),
                      children: const [
                        TextSpan(
                          text: 'Register your farm',
                          style: TextStyle(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}