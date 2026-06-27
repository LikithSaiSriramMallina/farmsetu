import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../../providers/auth_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/saved_products_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import 'register_screen.dart';
import '../farmer/farmer_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email    = TextEditingController();
  final _password = TextEditingController();
  bool  _obscure  = true;
  bool  _loading  = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });

    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() {
        _error   = 'Please enter your email and password';
        _loading = false;
      });
      return;
    }

    try {
      // Firebase Auth login
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email:    _email.text.trim(),
            password: _password.text.trim(),
          );

      if (!mounted) return;

      final uid = cred.user!.uid;

      // ── Start real-time listeners ─────────────────────
      context.read<OrdersProvider>().startListening(uid);
      await context.read<SavedProductsProvider>().loadForUser(uid);

      // ── Notify AuthProvider ───────────────────────────
      context.read<AuthProvider>().login(
        _email.text.trim(),
        _password.text.trim(),
        uid: uid,
      );

    } on Exception catch (e) {
      setState(() {
        _error   = e.toString().replaceAll('Exception: ', '');
        _loading = false;
      });
      return;
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.col;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.eco_rounded,
                      color: AppTheme.primaryGreen, size: 24),
                ),
                const SizedBox(width: 10),
                Text('Farmsetu',
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    )),
              ]),
              const SizedBox(height: 40),
              Text('Welcome back 👋',
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 6),
              Text('Sign in to continue',
                  style: TextStyle(
                      color: c.textSecondary, fontSize: 14)),
              const SizedBox(height: 32),

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
                    Expanded(
                      child: Text(_error!,
                          style: const TextStyle(
                              color: AppTheme.error, fontSize: 13)),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
              ],

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

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Sign In as Customer',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const FarmerLoginScreen())),
                  icon: const Icon(Icons.agriculture_rounded,
                      color: AppTheme.primaryGreen, size: 20),
                  label: const Text('Farmer Portal →',
                      style: TextStyle(
                        color: AppTheme.primaryGreen,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      )),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: AppTheme.primaryGreen),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen())),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                          color: c.textSecondary, fontSize: 14),
                      children: const [
                        TextSpan(
                          text: 'Sign up',
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