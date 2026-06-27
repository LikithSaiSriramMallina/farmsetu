import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/farmer_auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import 'farmer_pending_screen.dart';

class FarmerRegisterScreen extends StatefulWidget {
  const FarmerRegisterScreen({super.key});
  @override
  State<FarmerRegisterScreen> createState() => _FarmerRegisterScreenState();
}

class _FarmerRegisterScreenState extends State<FarmerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _step = 0;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _ob1 = true, _ob2 = true;

  final _farmName = TextEditingController();
  final _location = TextEditingController();
  final _bio = TextEditingController();
  String _category = 'Vegetables';

  final _aadhaar = TextEditingController();
  final _passbook = TextEditingController();
  bool _declared = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _password, _confirm,
        _farmName, _location, _bio, _aadhaar, _passbook]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_declared) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please accept the declaration'),
        backgroundColor: AppTheme.error,
      ));
      return;
    }
    final err = await context.read<FarmerAuthProvider>().register(
      email: _email.text.trim(), password: _password.text.trim(),
      name: _name.text.trim(), phone: _phone.text.trim(),
      farmName: _farmName.text.trim(), location: _location.text.trim(),
      bio: _bio.text.trim(),
      aadhaarNumber: _aadhaar.text.replaceAll(' ', ''),
      passbookNumber: _passbook.text.trim(), category: _category,
    );
    if (!mounted) return;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err), backgroundColor: AppTheme.error));
      return;
    }
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const FarmerPendingScreen()),
        (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    final l10n = context.watch<LanguageProvider>().l10n;
    final loading = context.watch<FarmerAuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Farmer'),
        leading: GestureDetector(
          onTap: () => _step > 0
              ? setState(() => _step--) : Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: c.surfaceHigh,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: c.textPrimary),
          ),
        ),
      ),
      body: Column(children: [
        // Step bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(children: List.generate(3, (i) {
            final done = i < _step, active = i == _step;
            final labels = ['Personal', 'Farm Details', 'Documents'];
            return Expanded(child: Padding(
              padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
              child: Column(children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 4,
                  decoration: BoxDecoration(
                    color: done || active ? AppTheme.primaryGreen : c.divider,
                    borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 6),
                Text(labels[i], style: TextStyle(
                  color: active ? AppTheme.primaryGreen
                      : done ? c.textSecondary : c.textMuted,
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400)),
              ]),
            ));
          })),
        ),
        const SizedBox(height: 8),
        Expanded(child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: [
              _personal(c, l10n), _farm(c, l10n), _docs(c, l10n)
            ][_step],
          ),
        )),
        Container(
          padding: EdgeInsets.fromLTRB(20, 12, 20,
              MediaQuery.of(context).padding.bottom + 16),
          decoration: BoxDecoration(color: c.surface,
              border: Border(top: BorderSide(color: c.divider))),
          child: SizedBox(width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: loading ? null : () {
                if (_formKey.currentState!.validate()) {
                  _step < 2 ? setState(() => _step++) : _submit();
                }
              },
              child: loading
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text(_step < 2 ? l10n.next : l10n.submitApplication,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _personal(AppColors c, dynamic l10n) => Column(children: [
    _hdr(Icons.person_outline_rounded, 'Personal Info',
        'Your basic contact details'),
    const SizedBox(height: 20),
    _f(l10n.fullName, _name, Icons.person_outline_rounded,
        val: (v) => v!.trim().isEmpty ? 'Required' : null),
    const SizedBox(height: 12),
    _f(l10n.email, _email, Icons.email_outlined,
        type: TextInputType.emailAddress,
        val: (v) => !v!.contains('@') ? 'Enter valid email' : null),
    const SizedBox(height: 12),
    _f(l10n.phone, _phone, Icons.phone_outlined,
        type: TextInputType.phone,
        val: (v) => v!.length < 10 ? 'Enter valid phone' : null),
    const SizedBox(height: 12),
    _pw(_password, l10n.password, _ob1,
        () => setState(() => _ob1 = !_ob1),
        val: (v) => v!.length < 6 ? 'Min 6 characters' : null),
    const SizedBox(height: 12),
    _pw(_confirm, 'Confirm Password', _ob2,
        () => setState(() => _ob2 = !_ob2),
        val: (v) => v != _password.text ? 'Passwords do not match' : null),
  ]);

  Widget _farm(AppColors c, dynamic l10n) => Column(children: [
    _hdr(Icons.agriculture_rounded, 'Farm Details',
        'Tell us about your farm'),
    const SizedBox(height: 20),
    _f(l10n.farmName, _farmName, Icons.storefront_outlined,
        val: (v) => v!.trim().isEmpty ? 'Required' : null),
    const SizedBox(height: 12),
    _f(l10n.location, _location, Icons.location_on_outlined,
        val: (v) => v!.trim().isEmpty ? 'Required' : null),
    const SizedBox(height: 12),
    DropdownButtonFormField<String>(
      initialValue: _category,
      dropdownColor: c.cardBg,
      style: TextStyle(color: c.textPrimary, fontSize: 14),
      decoration: InputDecoration(hintText: l10n.category,
          prefixIcon: Icon(Icons.category_outlined,
              size: 18, color: c.textSecondary)),
      items: ['Vegetables','Fruits','Dairy','Grains','Honey']
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: (v) => setState(() => _category = v!),
    ),
    const SizedBox(height: 12),
    TextFormField(
      controller: _bio, maxLines: 3,
      style: TextStyle(color: c.textPrimary),
      validator: (v) => v!.trim().isEmpty ? 'Required' : null,
      decoration: InputDecoration(hintText: l10n.bio,
          prefixIcon: Padding(padding: const EdgeInsets.only(bottom: 40),
              child: Icon(Icons.notes_rounded,
                  size: 18, color: c.textSecondary))),
    ),
  ]);

  Widget _docs(AppColors c, dynamic l10n) => Column(children: [
    _hdr(Icons.verified_user_outlined, 'Documents',
        'Required for government verification'),
    const SizedBox(height: 8),
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF5CB8E4).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF5CB8E4).withOpacity(0.3)),
      ),
      child: const Row(children: [
        Icon(Icons.info_outline_rounded, color: Color(0xFF5CB8E4), size: 16),
        SizedBox(width: 8),
        Expanded(child: Text(
          'Documents are encrypted and shared only with Government authorities.',
          style: TextStyle(color: Color(0xFF5CB8E4), fontSize: 12))),
      ]),
    ),
    const SizedBox(height: 20),
    TextFormField(
      controller: _aadhaar,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(12), _AadhaarFmt()],
      style: TextStyle(color: c.textPrimary),
      validator: (v) {
        final d = v!.replaceAll(' ', '');
        return d.length != 12 ? 'Aadhaar must be 12 digits' : null;
      },
      decoration: InputDecoration(
        hintText: l10n.aadhaarNumber,
        prefixIcon: Icon(Icons.credit_card_rounded,
            size: 18, color: c.textSecondary),
        helperText: 'Format: XXXX XXXX XXXX',
        helperStyle: TextStyle(color: c.textMuted, fontSize: 11)),
    ),
    const SizedBox(height: 12),
    _f(l10n.passbookNumber, _passbook, Icons.book_outlined,
        val: (v) => v!.trim().length < 4 ? 'Enter valid number' : null),
    const SizedBox(height: 20),
    GestureDetector(
      onTap: () => setState(() => _declared = !_declared),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 22, height: 22,
          decoration: BoxDecoration(
            color: _declared ? AppTheme.primaryGreen : Colors.transparent,
            border: Border.all(
                color: _declared ? AppTheme.primaryGreen : c.divider,
                width: 2),
            borderRadius: BorderRadius.circular(5)),
          child: _declared ? const Icon(Icons.check_rounded,
              size: 14, color: Colors.white) : null,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(l10n.declaration,
            style: TextStyle(color: c.textSecondary,
                fontSize: 13, height: 1.4))),
      ]),
    ),
  ]);

  Widget _hdr(IconData icon, String title, String sub) {
    final c = context.col;
    return Row(children: [
      Container(width: 44, height: 44,
          decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppTheme.primaryGreen, size: 22)),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: c.textPrimary,
            fontSize: 16, fontWeight: FontWeight.w700)),
        Text(sub, style: TextStyle(color: c.textSecondary, fontSize: 12)),
      ]),
    ]);
  }

  Widget _f(String hint, TextEditingController ctrl, IconData icon,
      {TextInputType type = TextInputType.text,
      required String? Function(String?) val}) {
    final c = context.col;
    return TextFormField(controller: ctrl, keyboardType: type,
        validator: val, style: TextStyle(color: c.textPrimary),
        decoration: InputDecoration(hintText: hint,
            prefixIcon: Icon(icon, size: 18, color: c.textSecondary)));
  }

  Widget _pw(TextEditingController ctrl, String hint, bool obscure,
      VoidCallback toggle, {required String? Function(String?) val}) {
    final c = context.col;
    return TextFormField(
      controller: ctrl, obscureText: obscure, validator: val,
      style: TextStyle(color: c.textPrimary),
      decoration: InputDecoration(hintText: hint,
          prefixIcon: Icon(Icons.lock_outline_rounded,
              size: 18, color: c.textSecondary),
          suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
                  size: 18, color: c.textSecondary),
              onPressed: toggle)),
    );
  }
}

class _AadhaarFmt extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue o, TextEditingValue n) {
    final d = n.text.replaceAll(' ', '');
    final buf = StringBuffer();
    for (int i = 0; i < d.length; i++) {
      if (i == 4 || i == 8) buf.write(' ');
      buf.write(d[i]);
    }
    final s = buf.toString();
    return n.copyWith(text: s,
        selection: TextSelection.collapsed(offset: s.length));
  }
}