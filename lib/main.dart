import 'package:binote/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:binote/models/note_database.dart';
import 'package:provider/provider.dart';
import 'package:binote/theme/theme_provider.dart';

void main() async {
  //initialize the isar database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    MultiProvider(
      providers: [
        //Note database provider
        ChangeNotifierProvider(create: (context) => NoteDatabase()),

        //Theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "bi'Note",
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const HomePage(),
    );
  }
}
