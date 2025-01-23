import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String formatCurrency() {
    final currencyFormat = NumberFormat.currency(
      decimalDigits: 2,
      symbol: r'$ ',
    );
    final formattedNumber = currencyFormat.format(this);
    return formattedNumber;
  }
}
