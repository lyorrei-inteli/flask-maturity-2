import 'package:flutter/material.dart';
import 'package:flutter_application/task_edit_widget.dart';
import 'package:flutter_application/task_list_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/list-tasks',
      routes: {
        '/list-tasks': (context) => TaskListWidget(),
        '/create-task': (context) => TaskEditWidget(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// https://youtu.be/e7kYtUnUVnM