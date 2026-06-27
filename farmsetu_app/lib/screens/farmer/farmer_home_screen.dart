import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'farmer_dashboard_screen.dart';
import 'farmer_orders_screen.dart';
import 'farmer_products_screen.dart';
import 'farmer_profile_screen.dart';

class FarmerHomeScreen extends StatefulWidget {
  const FarmerHomeScreen({super.key});
  @override
  State<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final c = context.col;

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.divider, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (i) => setState(() => _navIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon:       Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label:      'Dashboard',
            ),
            BottomNavigationBarItem(
              icon:       Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2_rounded),
              label:      'Products',
            ),
            BottomNavigationBarItem(
              icon:       Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label:      'Orders',
            ),
            BottomNavigationBarItem(
              icon:       Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store_rounded),
              label:      'My Farm',
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _navIndex,
        children: const [
          FarmerDashboardScreen(),
          FarmerProductsScreen(),
          FarmerOrdersScreen(),
          FarmerProfileScreen(),
        ],
      ),
    );
  }
}