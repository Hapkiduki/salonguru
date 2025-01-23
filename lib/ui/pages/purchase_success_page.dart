import 'package:flutter/material.dart';
import 'package:salonguru/config/routes.dart';

class PurchaseSuccessPage extends StatelessWidget {
  const PurchaseSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _AnimatedCheckmark(
          onAnimationDone: () {
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                CheckoutRoute().go(context);
              }
            });
          },
        ),
      ),
    );
  }
}

class _AnimatedCheckmark extends StatefulWidget {
  const _AnimatedCheckmark({required this.onAnimationDone});
  final VoidCallback onAnimationDone;

  @override
  State<_AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<_AnimatedCheckmark> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> sizeAnim;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    sizeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    ));
    controller
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationDone();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: sizeAnim,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 64,
        ),
      ),
    );
  }
}
