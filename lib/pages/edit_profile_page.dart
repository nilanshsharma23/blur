import 'package:blur/classes/globals.dart';
import 'package:blur/functions/get_profile.dart';
import 'package:blur/functions/show_error_dialog.dart';
import 'package:blur/widgets/form_field_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(
    text: Globals.currentProfile!.name,
  );
  TextEditingController handleController = TextEditingController(
    text: Globals.currentProfile!.handle,
  );

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit profile", style: TextStyle(fontSize: 24)),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(32),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 16,
            children: [
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

                    if (nameController.text == Globals.currentProfile!.name &&
                        handleController.text ==
                            Globals.currentProfile!.handle) {
                      showErrorDialog(context, "The values are same.");

                      return;
                    }

                    setState(() {
                      loading = true;
                    });

                    FirebaseFirestore db = FirebaseFirestore.instance;

                    await db
                        .collection('profiles')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                          'name': nameController.text,
                          'handle': handleController.text,
                        });

                    Globals.currentProfile = await getProfile(
                      FirebaseAuth.instance.currentUser!.uid,
                    );

                    if (context.mounted) {
                      context.pop();
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
