// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'sql_helper.dart'; // Import your SQL Helper
import 'add_contact_page.dart'; // Import your AddContactPage
import 'contact_detail_page.dart'; // Import your ContactDetailPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoading = true;

  void _refreshContacts() async {
    final data = await SQLHelper.getData('contacts');
    setState(() {
      _contacts = data;
      _isLoading = false;
      searchController.clear();
    });
  }

  void search() async {
    // Add this function
    final data =
        await SQLHelper.searchData('contacts', searchController.text.trim());
    setState(() {
      _contacts = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshContacts();
  }

  void _deleteContact(int id) async {
    await SQLHelper.delete('contacts', id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contact deleted")),
    );
    _refreshContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Contacts"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: search,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Find contact',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _contacts.isEmpty
              ? const Center(
                  child: Text(
                    "No contacts",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          contact['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(contact['phone']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteContact(contact['id']),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ContactDetailPage(contact: contact),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactPage()),
          ).then((_) => _refreshContacts());
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
  }
}
