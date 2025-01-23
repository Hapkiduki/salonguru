import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
//import 'package:lottie/lottie.dart';
import 'package:salonguru/config/assets.dart';
import 'package:salonguru/l10n/l10n.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });
  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                Assets.owl,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                'Oops!',
                style: textStyle.headlineMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.generalError,
                style: textStyle.labelMedium?.copyWith(color: const Color(0xffec837d)),
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: textStyle.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 32,
        ),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xffec837d),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onRetry,
          child: Text(
            l10n.retryButton,
            style: textStyle.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
