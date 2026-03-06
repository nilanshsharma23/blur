import 'package:blur/widgets/form_field_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController handleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(32),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 16,
            children: [
              Text(
                "profile setup",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              FormFieldTemplate(
                label: Text("Name"),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter something.";
                  }

                  return null;
                },
              ),
              FormFieldTemplate(
                label: Text("Handle"),
                controller: handleController,
                prefixIcon: Icon(Icons.alternate_email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter something.";
                  }

                  return null;
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    setState(() {
                      loading = true;
                    });

                    FirebaseFirestore db = FirebaseFirestore.instance;

                    await db
                        .collection('profiles')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({
                          'name': nameController.text,
                          'handle': handleController.text,
                          'circles': [],
                        });

                    if (context.mounted) {
                      context.go('/');
                    }

                    setState(() {
                      loading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 0,
                    shape: BeveledRectangleBorder(side: BorderSide()),
                  ),
                  child: loading
                      ? SpinKitWave(color: Colors.black, size: 16)
                      : Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
