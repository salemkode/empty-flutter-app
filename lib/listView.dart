import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Course',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: ListView(
          children: [
            ListTile(
              trailing: Icon(Icons.abc_outlined),
              title: Text("Welcome"),
              onTap: () {
                print("Welcome");
              },
            ),
            ListTile(
              trailing: Icon(Icons.abc_outlined),
              title: Text("Welcome 2"),
              onTap: () {
                print("Welcome 2");
              },
            ),
            ListTile(
              trailing: Icon(Icons.abc_outlined),
              title: Text("Welcome 3"),
              onTap: () {
                print("Welcome 3");
              },
            ),
          ],
        ),
      ),
    );
  }
}
