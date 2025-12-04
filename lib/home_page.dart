import 'package:flutter/material.dart';
import 'sign_in_page.dart';

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInPage(),
                ),
                (route) => false,
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome $username',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

