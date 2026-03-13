import 'package:blur/classes/globals.dart';
import 'package:blur/functions/get_circles.dart';
import 'package:blur/functions/show_error_dialog.dart';
import 'package:blur/widgets/circle_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CirclesPage extends StatefulWidget {
  const CirclesPage({super.key});

  @override
  State<CirclesPage> createState() => _CirclesPageState();
}

class _CirclesPageState extends State<CirclesPage> {
  TextEditingController codeController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("my circles", style: TextStyle(fontSize: 24))),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            spacing: 16,
            children: [
              FutureBuilder(
                future: getCircles(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    return Column(
                      spacing: 16,
                      children: List.generate(asyncSnapshot.data!.length, (
                        index,
                      ) {
                        return CircleTemplate(
                          circleObject: asyncSnapshot.data![index],
                          onStart: () {
                            setState(() {
                              loading = true;
                            });
                          },
                          onFinish: () {
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      }),
                    );
                  }

                  return Center(
                    child: SpinKitWave(color: Colors.black, size: 24),
                  );
                },
              ),
              TextField(
                style: TextStyle(fontSize: 16),
                controller: codeController,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  filled: true,
                  label: Text(
                    "Enter code to join circle",
                    style: TextStyle(fontSize: 16),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (codeController.text.length != 5) {
                        showErrorDialog(
                          context,
                          "All circle codes are 5 letters.",
                        );

                        return;
                      }

                      if (Globals.currentProfile!.circles.contains(
                        codeController.text,
                      )) {
                        showErrorDialog(
                          context,
                          "You are already in this circle.",
                        );

                        return;
                      }

                      setState(() {
                        loading = true;
                      });

                      FirebaseFirestore db = FirebaseFirestore.instance;

                      var circle = await db
                          .collection('circles')
                          .doc(codeController.text)
                          .get();

                      if (!circle.exists && context.mounted) {
                        showErrorDialog(
                          context,
                          "Error: Circle does not exist.",
                        );

                        setState(() {
                          loading = false;
                        });

                        return;
                      }

                      await db
                          .collection('profiles')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                            'circles': FieldValue.arrayUnion([
                              codeController.text,
                            ]),
                          });

                      setState(() {
                        Globals.currentProfile!.circles.add(
                          codeController.text,
                        );
                        loading = false;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              if (loading)
                Center(child: SpinKitWave(color: Colors.black, size: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
