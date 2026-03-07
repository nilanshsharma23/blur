import 'package:blur/classes/globals.dart';
import 'package:blur/functions/get_circles.dart';
import 'package:blur/functions/show_error_dialog.dart';
import 'package:blur/widgets/form_field_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;

  bool anonymous = false;
  TextEditingController contentController = TextEditingController();
  String currentCircle = Globals.currentProfile!.circles[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("blurt something out", style: TextStyle(fontSize: 24)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FormFieldTemplate(
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: null,
                  label: Text("any gossip?"),
                  controller: contentController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter something.';
                    }

                    if (value.length >= 200) {
                      return 'Too much';
                    }

                    return null;
                  },
                ),
                FutureBuilder(
                  future: getCircles(),
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      return DropdownMenu(
                        initialSelection: '00000',
                        label: Text("Circle"),
                        inputDecorationTheme: InputDecorationTheme(
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainer,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onSelected: (value) {
                          setState(() {
                            currentCircle = value!;
                          });
                        },
                        width: double.infinity,
                        dropdownMenuEntries: List.generate(
                          asyncSnapshot.data!.length,
                          (index) {
                            return DropdownMenuEntry(
                              value: asyncSnapshot.data![index].code,
                              label: asyncSnapshot.data![index].name,
                            );
                          },
                        ),
                      );
                    }

                    return Center(
                      child: SpinKitWave(color: Colors.black, size: 24),
                    );
                  },
                ),
                if (currentCircle == "00000")
                  Text(
                    "Note: You can only post every 1 hour on the public circle.",
                    style: TextStyle(fontSize: 16),
                  ),
                CheckboxListTile(
                  value: anonymous,
                  onChanged: (value) {
                    setState(() {
                      anonymous = value!;
                    });
                  },
                  title: Text("anonymous", style: TextStyle(fontSize: 16)),
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

                      if (currentCircle == "00000") {
                        var data =
                            (await db
                                    .collection(currentCircle)
                                    .orderBy('created_at', descending: true)
                                    .limit(1)
                                    .get())
                                .docs[0]
                                .data();

                        DateTime latestPostDate =
                            DateTime.fromMillisecondsSinceEpoch(
                              data['created_at'].seconds * 1000,
                            );

                        if (DateTime.now().difference(latestPostDate).inHours <
                                1 &&
                            context.mounted) {
                          showErrorDialog(
                            context,
                            "You have already posted in the last hour.",
                          );
                          return;
                        }
                      }

                      await db.collection(currentCircle).add({
                        'content': contentController.text,
                        'user_id': Globals.currentProfile!.uid,
                        'created_at': DateTime.now(),
                        'anonymous': anonymous,
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
                            "blurt",
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
      ),
    );
  }
}
