import 'package:crud/Crud_Using_Database/database/DBHelper.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final DBHelper dbHelper = DBHelper();
  TextEditingController nameController = TextEditingController();
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    users = await dbHelper.getUsers(100);
    setState(() {});
  }

  Future<void> _addUser() async {
    Map<String, dynamic> user = {'name': nameController.text};
    await dbHelper.insertUser(user);
    nameController.clear();
    _loadUsers();
    print('User added successfully: ${user['name']}');
  }

  Future<void> _updateUser(int id, String newName) async {
    Map<String, dynamic> user = {'id': id, 'name': newName};
    await dbHelper.updateUser(user);
    _loadUsers();
    print('User updated successfully: $newName');
  }

  Future<void> _deleteUser(int id, String userName) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete $userName?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      await dbHelper.deleteUser(id);
      _loadUsers();
      print('User deleted successfully');
    }
  }

  Future<void> _showEditDialog(int id, String userName) async {
    String newName = userName;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: TextField(
            controller: TextEditingController(text: userName),
            onChanged: (value) {
              newName = value;
            },
            decoration: InputDecoration(labelText: 'New Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateUser(id, newName);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Enter name',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addUser,
                  child: const Text('Add User'),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return GestureDetector(
                    onTap: () {
                      _showEditDialog(user['id'], user['name']);
                    },
                    child: ListTile(
                      title: Text(user['name']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteUser(user['id'], user['name']);
                          print('User deleted: ${user['name']}');
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
