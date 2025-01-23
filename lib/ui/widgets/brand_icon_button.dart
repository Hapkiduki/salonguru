import 'package:flutter/material.dart';

class BrandIconButton extends StatelessWidget {
  const BrandIconButton({required this.icon, required this.onPressed, super.key});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xffec837d),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
