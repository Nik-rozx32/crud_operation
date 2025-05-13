import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Crud extends StatefulWidget {
  const Crud({Key? key}) : super(key: key);

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  String url = 'https://eo2nzlcrlpp5fp7.m.pipedream.net';
  String responseMessage = '';

  List<dynamic> users = [];
  bool isLoading = false;

  Future<void> getUsers() async {
    final baseurl = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(baseurl);
      if (response.statusCode == 200) {
        setState(() {
          users = jsonDecode(response.body);
          responseMessage = 'Data Loaded';
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
      setState(() {
        responseMessage = 'Failed to load data';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addUsers(String name, String email) async {
    final response = await http.post(Uri.parse(url),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email}));

    if (response.statusCode == 200) {
      setState(() {
        responseMessage = 'User Added';
      });
    } else {
      throw Exception('Failed to add user');
    }
  }

  Future<void> updateUser(String name, String email) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email}),
    );

    if (response.statusCode == 200) {
      setState(() {
        responseMessage = 'User Updated';
      });
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser() async {
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        responseMessage = 'User Deleted';
      });
    } else {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (isLoading) const CircularProgressIndicator(),

              // ✅ Show responseMessage after every operation
              if (responseMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    responseMessage,
                    style: const TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),

              // ✅ Fixed height ListView
              Container(
                height: screenHeight * 0.4, // 40% of screen height
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(user['id'].toString())),
                      title: Text(user['title']),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Buttons with response message update
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white),
                onPressed: getUsers,
                child: const Text('GET Data'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white),
                onPressed: () => addUsers('nik', 'nik@example.com'),
                child: const Text('CREATE User'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white),
                onPressed: () => updateUser('Nikki', 'nikki@example.com'),
                child: const Text('UPDATE User'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white),
                onPressed: deleteUser,
                child: const Text('DELETE User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
