import 'package:flutter/material.dart';

enum SnackType { error, success }

void showSnack(BuildContext context, String message, {SnackType type = SnackType.error}) {
  final color = type == SnackType.error ? Colors.red : Colors.green;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
