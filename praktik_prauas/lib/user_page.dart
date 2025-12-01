import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List _users = [];
  bool _isLoading = false;

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );
      setState(() {
        _users = jsonDecode(res.body);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pengguna"),
        actions: [
          IconButton(onPressed: _fetchUsers, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final city = user['address']['city'];

                return ListTile(
                  leading: CircleAvatar(child: Text(user['name'][0])),
                  title: Text(user['name']),
                  subtitle: Text("${user['email']}\n$city"),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}
