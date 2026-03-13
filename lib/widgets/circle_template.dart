import 'package:blur/classes/circle_object.dart';
import 'package:blur/classes/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CircleTemplate extends StatefulWidget {
  const CircleTemplate({
    super.key,
    required this.circleObject,
    required this.onStart,
    required this.onFinish,
  });

  final CircleObject circleObject;
  final void Function() onStart;
  final void Function() onFinish;

  @override
  State<CircleTemplate> createState() => _CircleTemplateState();
}

class _CircleTemplateState extends State<CircleTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: BoxBorder.all(color: Theme.of(context).colorScheme.onSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.circleObject.name, style: TextStyle(fontSize: 16)),
          if (widget.circleObject.code != "00000")
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  widget.onStart();
                  FirebaseFirestore db = FirebaseFirestore.instance;

                  await db
                      .collection('profiles')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                        'circles': FieldValue.arrayRemove([
                          widget.circleObject.code,
                        ]),
                      });

                  Globals.currentProfile!.circles.remove(
                    widget.circleObject.code,
                  );
                  widget.onFinish();
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "Leave Circle",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
