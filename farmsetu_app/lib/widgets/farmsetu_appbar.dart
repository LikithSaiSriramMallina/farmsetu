import 'package:flutter/material.dart';

class FarmSetuAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  const FarmSetuAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title));
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}