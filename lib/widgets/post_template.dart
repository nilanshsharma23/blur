import 'package:blur/classes/globals.dart';
import 'package:blur/classes/post_object.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PostTemplate extends StatefulWidget {
  const PostTemplate({
    super.key,
    required this.postObject,
    required this.currentCircle,
    this.moderator = false,
  });

  final PostObject postObject;
  final bool moderator;
  final String currentCircle;

  @override
  State<PostTemplate> createState() => _PostTemplateState();
}

class _PostTemplateState extends State<PostTemplate> {
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
        spacing: 16,
        children: [
          Text(
            widget.postObject.anonymous
                ? "anonymous"
                : "${widget.postObject.profileObject!.name} • @${widget.postObject.profileObject!.handle}",
            style: TextStyle(fontSize: 16, color: Color.fromARGB(100, 0, 0, 0)),
          ),
          Text(
            "${DateFormat.yMd('en_IN').format(widget.postObject.createdAt)} ${DateFormat.jm().format(widget.postObject.createdAt)}",
            style: TextStyle(fontSize: 16, color: Color.fromARGB(100, 0, 0, 0)),
          ),
          SelectableText(
            widget.postObject.content,
            style: TextStyle(fontSize: 16),
          ),
          if (!widget.postObject.anonymous &&
              widget.postObject.profileObject!.uid ==
                  Globals.currentProfile!.uid)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(),
                    ),
                    title: Text("Confirmation"),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    content: Text("Are you sure you want to delete this post?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () async {
                          FirebaseFirestore db = FirebaseFirestore.instance;

                          await db
                              .collection(widget.currentCircle)
                              .doc(widget.postObject.uid)
                              .delete();

                          context.go('/');
                          Navigator.pop(context);
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
              style: TextButton.styleFrom(
                shape: BeveledRectangleBorder(),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                "Delete Post",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
