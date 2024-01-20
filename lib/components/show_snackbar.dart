import 'package:flutter/material.dart';

class ShowSnackBar {
  final BuildContext context;
  final String label;
  final Color color;
  final VoidCallback? onTapAction;
  final String? actionLabel;

  const ShowSnackBar({
    required this.context,
    required this.label,
    required this.color,
    this.onTapAction,
    this.actionLabel,
  });

  void show() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.removeCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100.0, left: 20,right : 20),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel!,
                onPressed: onTapAction!,
                textColor: Colors.black,
                backgroundColor: Colors.white,
              )
            : null,
      ),
    );
  }
}
