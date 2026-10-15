import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  static const List<String> members = <String>['Gabriel Oliveira Pinto'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipe')),
      body: ListView(
        children: [
          for (final name in members)
            ListTile(leading: const Icon(Icons.person), title: Text(name)),
        ],
      ),
    );
  }
}
