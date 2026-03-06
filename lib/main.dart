import 'package:blur/firebase_options.dart';
import 'package:blur/utils/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  initializeDateFormatting('en_IN');
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light().copyWith(
          surface: Color(0xFFdacbb6),
          surfaceContainer: Color(0xFFeaC686),
          primary: Color(0xFF5e7381),
        ),
        textTheme: GoogleFonts.cascadiaMonoTextTheme(),
      ),
      routerConfig: router,
    );
  }
}
