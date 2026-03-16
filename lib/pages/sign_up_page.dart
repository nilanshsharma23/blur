import 'package:blur/classes/globals.dart';
import 'package:blur/classes/profile_object.dart';
import 'package:blur/functions/show_error_dialog.dart';
import 'package:blur/widgets/form_field_template.dart';
import 'package:blur/widgets/google_sign_in_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool loading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                "blur",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              FormFieldTemplate(
                label: Text("E-mail"),
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter something.";
                  }

                  if (!EmailValidator.validate(value)) {
                    return "Please enter a valid email.";
                  }

                  return null;
                },
              ),
              FormFieldTemplate(
                label: Text("Password"),
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter something.";
                  }

                  if (value.length < 8) {
                    return "Password must be 8 or more letters";
                  }

                  return null;
                },
                obsecureText: !showPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
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

                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                      if (context.mounted) {
                        context.go('/profile-setup');
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == "email-already-in-use" && context.mounted) {
                        showErrorDialog(
                          context,
                          "The given e-mail is already in use",
                        );
                      }
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
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Divider(height: 2)),
                  Text("  OR  "),
                  Expanded(child: Divider(height: 2)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoogleSignInButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      final GoogleSignInAccount googleUser = await GoogleSignIn
                          .instance
                          .authenticate();

                      final GoogleSignInAuthentication googleAuth =
                          googleUser.authentication;

                      final credential = GoogleAuthProvider.credential(
                        idToken: googleAuth.idToken,
                      );

                      await FirebaseAuth.instance.signInWithCredential(
                        credential,
                      );

                      var doc = await FirebaseFirestore.instance
                          .collection('profiles')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get();

                      if (doc.exists) {
                        var data = doc.data() as Map<String, dynamic>;

                        List<String> circles = [];

                        for (var i = 0; i < data['circles'].length; i++) {
                          circles.add(data['circles'][i]);
                        }

                        Globals.currentProfile = ProfileObject(
                          name: data['name'],
                          handle: data['handle'],
                          uid: FirebaseAuth.instance.currentUser!.uid,
                          circles: circles,
                        );
                      }

                      if (context.mounted) {
                        context.go(doc.exists ? '/' : '/profile-setup');
                      }

                      setState(() {
                        loading = false;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/sign-in');
                    },
                    child: Text("Sign In", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
