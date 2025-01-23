import 'package:flutter/material.dart';
import 'package:salonguru/config/assets.dart';
import 'package:salonguru/l10n/l10n.dart';

class SgAppbar extends StatelessWidget {
  const SgAppbar({required this.innerBoxIsScrolled, super.key});

  final bool innerBoxIsScrolled;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);
    final maxHeight = size.height * .22;
    const minHeight = kToolbarHeight;
    final l10n = context.l10n;

    final maxAvatarRadius = size.height * .048;
    final minAvatarRadius = size.height * .018;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final currentHeight = constraints.biggest.height;

        final t = ((currentHeight - minHeight) / (maxHeight - minHeight)).clamp(0.0, 1.0);

        final currentAvatarRadius = minAvatarRadius + (maxAvatarRadius - minAvatarRadius) * t;

        final minFontSize = textTheme.titleMedium?.fontSize ?? 16;
        final maxFontSize = (textTheme.headlineSmall?.fontSize ?? 24) + 2;
        final currentFontSize = minFontSize + (maxFontSize - minFontSize) * t;

        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffef907a),
                    Color(0xfff19c77),
                    Color(0xffed867d),
                    Color(0xffed857c),
                    Color(0xffec837d),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Visibility(
                visible: t > 0.3,
                child: Opacity(
                  opacity: t,
                  child: Text.rich(
                    TextSpan(
                      text: l10n.explore,
                      style: textTheme.headlineMedium?.copyWith(
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: l10n.ourProducts,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: innerBoxIsScrolled ? 1.5 : 10,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    spacing: 3,
                    children: [
                      DecoratedBox(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: currentAvatarRadius,
                          backgroundImage: const AssetImage(Assets.salonkee),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.hi('Salonkee'),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: currentFontSize,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
