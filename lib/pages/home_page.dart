import 'package:blur/functions/get_circles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(children: []),
        ),
      ),
    );
  }
}
