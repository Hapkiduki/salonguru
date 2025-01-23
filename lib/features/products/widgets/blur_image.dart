import 'package:flutter/material.dart';

class BlurImage extends StatelessWidget {
  const BlurImage({
    required this.path,
    super.key,
    this.sizePercent = .21,
  });

  final String path;
  final double sizePercent;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffef907a),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      height: size.height * sizePercent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
