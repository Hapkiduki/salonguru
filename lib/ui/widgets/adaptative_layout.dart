import 'package:flutter/material.dart';

/// Adaptive widget for responsive design and orientation handling,
/// using the shortest side of the screen for breakpoints
/// and `OrientationBuilder` to react to orientation changes.
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    required this.mobilePortrait,
    super.key,
    this.mobileLandscape,
    this.tabletPortrait,
    this.tabletLandscape,
    this.desktop,
    this.extraLarge,
    this.breakpointTablet = 600,
    this.breakpointDesktop = 1024,
    this.breakpointExtraLarge = 1440,
  });

  /// Widget to render on mobile devices in portrait orientation.
  final Widget mobilePortrait;

  /// Widget to render on mobile devices in landscape orientation.
  final Widget? mobileLandscape;

  /// Widget to render on tablets in portrait orientation.
  final Widget? tabletPortrait;

  /// Widget to render on tablets in landscape orientation.
  final Widget? tabletLandscape;

  /// Widget to render on desktop devices.
  final Widget? desktop;

  /// Widget to render on extra-large screens (>= breakpointExtraLarge).
  final Widget? extraLarge;

  /// Minimum size of the shortest side to consider a screen as a tablet.
  final double breakpointTablet;

  /// Minimum size of the shortest side to consider a screen as a desktop.
  final double breakpointDesktop;

  /// Minimum size of the shortest side to consider a screen as extra-large.
  final double breakpointExtraLarge;

  @override
  Widget build(BuildContext context) {
    // Get the shortest side of the screen to classify the device type.
    final size = MediaQuery.sizeOf(context);
    final shortestSide = size.shortestSide;

    return OrientationBuilder(
      builder: (context, orientation) {
        // 1. Classify the device type (mobile, tablet, desktop, extra-large)
        // using shortestSide.
        // 2. Refine the choice based on orientation (portrait or landscape).
        if (shortestSide >= breakpointExtraLarge && extraLarge != null) {
          // Extra-large screen.
          return extraLarge!;
        } else if (shortestSide >= breakpointDesktop && desktop != null) {
          // Desktop screen.
          return desktop!;
        } else if (shortestSide >= breakpointTablet) {
          // Tablet screen.
          if (orientation == Orientation.landscape && tabletLandscape != null) {
            return tabletLandscape!;
          } else if (tabletPortrait != null) {
            return tabletPortrait!;
          }
        } else {
          // Mobile screen.
          if (orientation == Orientation.landscape && mobileLandscape != null) {
            return mobileLandscape!;
          } else {
            return mobilePortrait;
          }
        }

        // Fallback: if nothing matches, return the mobile portrait widget.
        return mobilePortrait;
      },
    );
  }
}
