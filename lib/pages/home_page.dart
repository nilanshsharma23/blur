import 'package:blur/classes/globals.dart';
import 'package:blur/classes/post_object.dart';
import 'package:blur/functions/get_circles.dart';
import 'package:blur/functions/get_posts.dart';
import 'package:blur/widgets/post_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool moderator = false;

  late Future<List<PostObject>> getPostsFuture;

  @override
  void initState() {
    super.initState();
    getPostsFuture = getPosts("00000");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "blur",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actionsPadding: EdgeInsets.only(right: 8),
        actions: [
          FutureBuilder(
            future: getCircles(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DropdownMenu(
                  inputDecorationTheme: InputDecorationTheme(
                    border: InputBorder.none,
                  ),
                  label: Text("Current Circle"),
                  onSelected: (value) {
                    setState(() {
                      getPostsFuture = getPosts(value!);
                      moderator = snapshot.data!
                          .firstWhere((element) => element.code == value)
                          .moderators
                          .contains(Globals.currentProfile!.uid);

                      debugPrint(moderator.toString());
                    });
                  },
                  initialSelection: snapshot.data![0].code,
                  dropdownMenuEntries: List.generate(snapshot.data!.length, (
                    index,
                  ) {
                    return DropdownMenuEntry(
                      value: snapshot.data![index].code,
                      label: snapshot.data![index].name,
                    );
                  }),
                );
              }

              return SpinKitWave(color: Colors.black, size: 16);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getPostsFuture,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Column(
                  spacing: 16,
                  children: List.generate(asyncSnapshot.data!.length, (index) {
                    return PostTemplate(postObject: asyncSnapshot.data![index]);
                  }),
                ),
              ),
            );
          }

          return Center(child: SpinKitWave(color: Colors.black, size: 32));
        },
      ),
    );
  }
}
