import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:guardiapp/models/user.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _counter = 0;
  List<User>? users; // Nullable para evitar problemas de hot-reload

  @override
  void initState() {
    super.initState();
    users = [];
    _fetchData();
  }

  /*void _incrementCounter() {
    setState(() {
      _counter++;
      _fetchData();
    });
  }*/

  Future<void> _fetchData() async {
    const url = 'https://randomuser.me/api/?results=20';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    
    final newUsers = (json['results'] as List).map((e) {
      return User.fromMap(e as Map<String, dynamic>);
    }).toList();

    setState(() {
      users = (users ?? [])..addAll(newUsers);
    });

    print(users);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GuardiApp', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple,
        ),
        /*body: Center(
          child: Text('$_counter'),
        ),*/
        body: ListView(
          children: [
                for (final user in (users ?? []))
                  ListTile(
                    tileColor: user.genero == 'male'
                        ? Colors.blue.shade50
                        : (user.genero == 'female'
                            ? Colors.pink.shade50
                            : Colors.white),
                    leading: user.imagenPerfil != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(user.imagenPerfil!))
                        : const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(user.nombre),
                    subtitle: Text('${user.email}\n${user.numeroTelefono ?? ''}'),
                    isThreeLine: true,
                  ),
                ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _fetchData,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
