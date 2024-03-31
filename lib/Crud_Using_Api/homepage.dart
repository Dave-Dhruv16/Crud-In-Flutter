import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const url = 'https://65ded69cff5e305f32a0984c.mockapi.io/flutterapi';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final decodedResponse = jsonDecode(response.body) as List<dynamic>;
    setState(() {
      users = decodedResponse;
    });
  }

  Future<void> addUser(String name) async {
    final url = Uri.parse('https://65ded69cff5e305f32a0984c.mockapi.io/flutterapi');
    final response = await http.post(
      url,
      body: {'name': name},
    );
    fetchData();
  }

  Future<void> updateUser(String id, String newName) async {
    final url = Uri.parse('https://65ded69cff5e305f32a0984c.mockapi.io/flutterapi/$id');
    final response = await http.put(
      url,
      body: {'name': newName},
    );

    fetchData();
  }

  Future<void> deleteUser(String id) async {
    final url = Uri.parse('https://65ded69cff5e305f32a0984c.mockapi.io/flutterapi/$id');
    await http.delete(url);

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddUserPage(),
                    ),
                  ).then((value) {
                    addUser(value!);
                  });
                },
                child: const Text('Add User'),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user['name']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteUser(user['id'].toString());
                      },
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final TextEditingController controller =
                          TextEditingController(text: user['name']);
                          return AlertDialog(
                            title: Text('Edit User'),
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                labelText: 'New Name',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  updateUser(user['id'].toString(), controller.text);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Update'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(_nameController.text);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
