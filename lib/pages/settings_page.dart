import 'package:blur/classes/globals.dart';
import 'package:blur/functions/delete_account.dart';
import 'package:blur/widgets/settings_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("settings", style: TextStyle(fontSize: 24))),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SettingsButton(
                text: "Sign Out",
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });

                  await FirebaseAuth.instance.signOut();
                  Globals.currentProfile = null;

                  if (context.mounted) {
                    context.go('/sign-in');
                  }

                  setState(() {
                    loading = false;
                  });
                },
              ),
              SettingsButton(
                text: "Delete Account",
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });

                  await deleteAccount();

                  if (context.mounted) {
                    context.go('/sign-in');
                  }

                  setState(() {
                    loading = false;
                  });
                },
                color: Theme.of(context).colorScheme.error,
              ),
              if (loading)
                Center(child: SpinKitWave(color: Colors.black, size: 32)),
            ],
          ),
        ),
      ),
    );
  }
}
