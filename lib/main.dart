import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecture 6 - Layouts & Multi-Child Widgets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CVProject(),
    );
  }
}

class CVProject extends StatelessWidget {
  const CVProject({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('CV Project'),
      ),
      body: const Center(
        child: Text(
          'CV Project - To be implemented manually',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
