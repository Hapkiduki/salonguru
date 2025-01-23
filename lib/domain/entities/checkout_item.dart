import 'package:flutter/foundation.dart';

@immutable
class CheckoutItem {
  const CheckoutItem({
    required this.id,
    required this.quantity,
  });

  final int id;
  final int quantity;
}
