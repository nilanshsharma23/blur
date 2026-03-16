import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(4),
            side: BorderSide(),
          ),
        ),
        child: Image.asset('assets/google.png'),
      ),
    );
  }
}
