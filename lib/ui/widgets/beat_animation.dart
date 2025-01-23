import 'package:flutter/material.dart';

class BeatAnimation extends StatefulWidget {
  const BeatAnimation({
    required this.child,
    required this.controller,
    super.key,
  });

  final Widget child;
  final AnimationController controller;
  @override
  State<BeatAnimation> createState() => _BeatAnimationState();
}

class _BeatAnimationState extends State<BeatAnimation> {
  late Animation<double> beat;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();
    opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: widget.controller, curve: const Interval(0, 0.45)));

    beat = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) => Transform.scale(
        scale: beat.value,
        child: Opacity(
          opacity: opacity.value,
          child: widget.child,
        ),
      ),
    );
  }
}
