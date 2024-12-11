// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'sql_helper.dart';
import 'edit_contact_page.dart';

class ContactDetailPage extends StatelessWidget {
  final Map<String, dynamic> contact;

  const ContactDetailPage({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact['name']),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey, // Default color for the avatar
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: contact['name'],
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: contact['surname'],
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Surname',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: contact['phone'],
              readOnly: true,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            const SizedBox(height: 20),
            // Removed the favorite status display
            // Removed const Divider(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditContactPage(
                    id: contact['id'].toString(),
                    name: contact['name'],
                    surname: contact['surname'],
                    phone: contact['phone'],
                  ),
                ),
              );
            },
            backgroundColor: Colors.blueGrey,
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              await SQLHelper.delete('contacts', contact['id']);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Contact deleted")),
              );
              Navigator.pop(context);
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
