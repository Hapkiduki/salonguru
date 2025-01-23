import 'dart:async';

import 'package:flutter/material.dart';

enum AlertType {
  error(Colors.red, Icons.error_outline),
  success(Color.fromARGB(255, 7, 66, 72), Icons.check);

  const AlertType(this.color, this.iconData);

  final Color color;
  final IconData iconData;
}

class AlertModel {
  const AlertModel({
    required this.text,
    required this.title,
    this.type = AlertType.success,
  });

  final String text;
  final String title;
  final AlertType type;
}

abstract class Alert {
  static Future<void> show(
    BuildContext context, {
    required AlertModel model,
    VoidCallback? onClose,
  }) async {
    return showGeneralDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      pageBuilder: (context, _, __) => _Alert(
        model: model,
        onClose: onClose,
      ),
    );
  }
}

class _Alert extends StatefulWidget {
  const _Alert({required this.model, this.onClose});

  final AlertModel model;
  final VoidCallback? onClose;

  @override
  State<_Alert> createState() => __AlertState();
}

class __AlertState extends State<_Alert> {
  final seconds = const Duration(seconds: 4);
  bool _closed = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(seconds, () {
      if (!_closed) {
        close();
      }
    });
  }

  @override
  void dispose() {
    resetTimer();
    super.dispose();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void close() {
    _closed = true;
    resetTimer();
    Navigator.pop(context);
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        Dismissible(
          key: const Key('__Body__'),
          onDismissed: (direction) {
            close();
          },
          child: _Content(
            color: widget.model.type.color,
            description: widget.model.text,
            icon: widget.model.type.iconData,
            onClose: close,
            title: widget.model.title,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(
      {required this.color, required this.icon, required this.title, required this.description, required this.onClose});

  final Color color;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final textstyle = Theme.of(context).textTheme;

    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Card(
        key: const Key('__Body_body__'),
        elevation: 8,
        margin: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        shape: const RoundedRectangleBorder(),
        child: IntrinsicHeight(
          child: Container(
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 48,
                  color: color,
                  child: Icon(
                    icon,
                    key: const Key('m-alert-icon'),
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.start,
                          style: textstyle.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          description,
                          textAlign: TextAlign.start,
                          style: textstyle.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  key: const Key('m-alert-icon-close'),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
