import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String errorMessage, {
  String title = "Error",
}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(),
      ),
      title: Text(title),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"),
        ),
      ],
    ),
  );
}
