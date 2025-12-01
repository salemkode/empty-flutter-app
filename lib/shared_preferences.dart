import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyAppState());
}

class MyAppState extends StatefulWidget {
  const MyAppState({super.key});

  @override
  State<MyAppState> createState() => _MyApp();
}

class _MyApp extends State<MyAppState> {
  var state = "";
  var con = TextFieldCon 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Course',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TextField(onChanged: (value) => state = value),
                ElevatedButton(
                  child: Text("save"),
                  onPressed: () async => {
                    await SharedPreferences.getInstance().then((value) => value.setString("state", state))
                  },
                ),
                TextField(),
                ElevatedButton(
                  child: Text("save"),
                  onPressed: () async => {
                    await SharedPreferences.getInstance().then(
                      (value) => value.setString("state", state),
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
