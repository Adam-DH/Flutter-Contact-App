// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'sql_helper.dart';
import 'package:sqlflite_crud/theme/theme.dart';

class EditContactPage extends StatefulWidget {
  final String id;
  final String name;
  final String surname;
  final String phone;

  const EditContactPage({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    Key? key,
  }) : super(key: key);

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController surnameController;
  late final TextEditingController phoneController;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    surnameController = TextEditingController(text: widget.surname);
    phoneController = TextEditingController(text: widget.phone);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void editContact() async {
    if (_formKey.currentState!.validate()) {
      try {
        await SQLHelper.update(
          'contacts',
          {
            'id': int.parse(widget.id),
            'name': nameController.text.trim(),
            'surname': surnameController.text.trim(),
            'phone': phoneController.text.trim(),
          },
        );

        Navigator.pop(context); // Return to the previous screen after editing
      } catch (e) {
        // Handle exceptions or errors if any
        print("Failed to edit contact: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to edit contact")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Contact"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Name",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: surnameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Surname",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a phone number";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Phone",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: editContact,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text("Edit Contact",
                        style: TextStyle(fontSize: 16)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
