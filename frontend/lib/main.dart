import 'package:flutter/material.dart';
import 'package:flutter_application/create_account_page.dart';
import 'package:flutter_application/image_capture_page.dart';
import 'package:flutter_application/login_page.dart';
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/list-tasks': (context) => TaskListWidget(),
        '/create-task': (context) => TaskEditWidget(),
        '/create-account': (context) => const CreateAccountPage(),
        '/capture-image': (context) => const ImageCapturePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// https://youtu.be/e7kYtUnUVnM