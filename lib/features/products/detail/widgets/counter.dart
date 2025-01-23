import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  const Counter({required this.quantity, required this.onTapped, super.key});

  final int quantity;
  final ValueChanged<bool> onTapped;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 45,
        width: 120,
        decoration: BoxDecoration(
          color: const Color(0xffec837d),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  onTapped.call(false);
                },
                child: const Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                quantity.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  onTapped.call(true);
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
