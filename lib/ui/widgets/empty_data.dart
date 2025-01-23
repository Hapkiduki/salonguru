import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:salonguru/config/assets.dart';
import 'package:salonguru/l10n/l10n.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({required this.item, super.key});

  final String item;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);
    final l10n = context.l10n;

    return Center(
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Heey!',
            style: textStyle.headlineMedium?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Lottie.asset(
            Assets.empty,
            height: size.height * .27,
            fit: BoxFit.contain,
          ),
          Text(
            l10n.emptyMessage(item),
            style: textStyle.titleMedium,
          ),
        ],
      ),
    );
  }
}
