import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/farmer.dart';
import '../../providers/farmer_auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import 'farmer_home_screen.dart';

class FarmerPendingScreen extends StatelessWidget {
  const FarmerPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmerP = context.watch<FarmerAuthProvider>();
    final farmer  = farmerP.farmer;
    final c       = context.col;

    if (farmer == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (farmer.status == FarmerStatus.approved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const FarmerHomeScreen()),
            (r) => false);
      });
    }

    _SS ss(int minIdx, bool isDone) => minIdx > farmer.status.index
        ? _SS.pending
        : isDone ? _SS.done : _SS.active;

    final steps = [
      const _Step('Registration Submitted', 'Application received', _SS.done,
          Icons.assignment_turned_in_outlined),
      const _Step('Document Submission', 'Aadhaar & Farm Passbook uploaded',
          _SS.done, Icons.upload_file_outlined),
      _Step('Government Verification',
          'Ministry of Agriculture reviewing documents',
          ss(FarmerStatus.govtReview.index,
              farmer.status.index >= FarmerStatus.adminReview.index),
          Icons.account_balance_outlined),
      _Step('Admin Approval', 'Farmsetu team verifying your farm',
          ss(FarmerStatus.adminReview.index,
              farmer.status == FarmerStatus.approved),
          Icons.admin_panel_settings_outlined),
      _Step('Account Activated',
          'Ready to list products & receive orders',
          farmer.status == FarmerStatus.approved ? _SS.done : _SS.pending,
          Icons.check_circle_outline_rounded),
    ];

    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const SizedBox(height: 16),
          Container(width: 72, height: 72,
              decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.12),
                  shape: BoxShape.circle),
              child: const Icon(Icons.hourglass_top_rounded,
                  color: AppTheme.primaryGreen, size: 36)),
          const SizedBox(height: 16),
          Text('Verification in Progress', style: TextStyle(
              color: c.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            'Hello ${farmer.name.split(' ').first}! '
            '"${farmer.farmName}" is being reviewed.',
            textAlign: TextAlign.center,
            style: TextStyle(color: c.textSecondary, fontSize: 14, height: 1.4)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.sync_rounded, color: AppTheme.primaryGreen, size: 12),
              SizedBox(width: 5),
              Text('Live updates', style: TextStyle(
                  color: AppTheme.primaryGreen, fontSize: 11,
                  fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(height: 24),
          Expanded(child: ListView.builder(
            itemCount: steps.length,
            itemBuilder: (_, i) => _StepTile(
                step: steps[i], isLast: i == steps.length - 1),
          )),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFFE88F3F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFE88F3F).withOpacity(0.3))),
            child: const Row(children: [
              Icon(Icons.access_time_rounded,
                  color: Color(0xFFE88F3F), size: 18),
              SizedBox(width: 10),
              Expanded(child: Text(
                'This page auto-updates when admin approves. No refresh needed!',
                style: TextStyle(color: Color(0xFFE88F3F),
                    fontSize: 12, height: 1.4))),
            ]),
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
                farmerP.logout();
              },
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: c.divider),
                  minimumSize: const Size(0, 44)),
              child: Text('Sign Out',
                  style: TextStyle(color: c.textSecondary)),
            ),
          ),
        ]),
      )),
    );
  }
}

enum _SS { pending, active, done }

class _Step {
  final String title, subtitle;
  final _SS    status;
  final IconData icon;
  const _Step(this.title, this.subtitle, this.status, this.icon);
}

class _StepTile extends StatelessWidget {
  final _Step step;
  final bool  isLast;
  const _StepTile({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final c = context.col;
    Color dotColor;
    Widget dotChild;

    switch (step.status) {
      case _SS.done:
        dotColor = AppTheme.primaryGreen;
        dotChild = const Icon(Icons.check_rounded, size: 14, color: Colors.white);
        break;
      case _SS.active:
        dotColor = const Color(0xFFE88F3F);
        dotChild = const SizedBox(width: 12, height: 12,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2));
        break;
      case _SS.pending:
        dotColor = c.surfaceHigh;
        dotChild = Container(width: 8, height: 8,
            decoration: BoxDecoration(color: c.divider, shape: BoxShape.circle));
    }

    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 40, child: Column(children: [
          AnimatedContainer(duration: const Duration(milliseconds: 300),
              width: 32, height: 32,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              child: Center(child: dotChild)),
          if (!isLast) Expanded(child: Container(width: 2,
              color: step.status == _SS.done
                  ? AppTheme.primaryGreen.withOpacity(0.4) : c.divider)),
        ])),
        const SizedBox(width: 12),
        Expanded(child: Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 4),
            Text(step.title, style: TextStyle(
                color: step.status == _SS.pending ? c.textMuted : c.textPrimary,
                fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 3),
            Text(step.subtitle,
                style: TextStyle(color: c.textSecondary, fontSize: 12)),
          ]),
        )),
      ]),
    );
  }
}