import 'package:flutter/material.dart';
import 'package:my_flutter_todo_list_app/views/add_todos_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  
  //Pre-initialize SharedPreferences
  await SharedPreferences.getInstance();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddTodosPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.dark,
          ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
