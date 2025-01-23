import 'package:flutter/material.dart';
import 'package:salonguru/utils/currency_extension.dart';

class CurrencyText extends StatelessWidget {
  const CurrencyText({required this.cost, super.key, this.textStyle, this.smallextStyle});

  final double cost;
  final TextStyle? textStyle;
  final TextStyle? smallextStyle;

  @override
  Widget build(BuildContext context) {
    final parts = cost.formatCurrency().split('.');
    if (parts.length == 1) {
      return Text(
        parts[0],
        style: textStyle,
      );
    }
    return RichText(
      text: TextSpan(
        style: textStyle,
        children: <TextSpan>[
          TextSpan(text: parts[0]),
          TextSpan(
            text: '.${parts[1]}',
            style: smallextStyle,
          ),
        ],
      ),
    );
  }
}
