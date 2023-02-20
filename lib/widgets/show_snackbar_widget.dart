import 'package:flutter/material.dart';

void showSnackbar({
  required BuildContext context,
  required String message,
  bool success = true,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: success ? Colors.green : Colors.red,
    ),
  );
}
