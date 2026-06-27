import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String title;
  const ProductTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: const Icon(Icons.agriculture),
    );
  }
}