import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecture 10 - Shared Preferences & File Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SharedPreferencesPage(),
    );
  }
}

class SharedPreferencesPage extends StatelessWidget {
  const SharedPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Shared Preferences & File Manager'),
      ),
      body: const Center(
        child: Text(
          'Lecture 10 - Shared Preferences & File Manager',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
