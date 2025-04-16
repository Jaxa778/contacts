import 'package:contacts/models/contact_models.dart';
import 'package:contacts/service/local_database.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<ContactModels> contacts = [];

  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    await LocalDatabase().init();
    contacts = await LocalDatabase().getAllContacts();
    setState(() {});
  }

  void _addContacts() async {
    await LocalDatabase().insert(
      ContactModels(
        fullName: fullNameController.text,
        phoneNumber: phoneNumberController.text,
      ),
    );
    _loadContacts();
    Navigator.pop(context);
  }

  void _editContacts(int id) async {
    await LocalDatabase().update(
      ContactModels(
        fullName: fullNameController.text,
        phoneNumber: phoneNumberController.text,
        id: id,
      ),
    );
    _loadContacts();
    Navigator.pop(context);
  }

  void _deleteContacts(int id) async {
    await LocalDatabase().delete(id: id);
    _loadContacts();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Contacts"),
        actions: [
          IconButton(
            onPressed: () async {
              fullNameController.clear();
              phoneNumberController.clear();
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Yangi kontakt qo‘shish'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Ism Familya',
                          ),
                        ),
                        TextField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Telefon raqami',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Bekor qilish'),
                      ),
                      ElevatedButton(
                        onPressed: _addContacts,
                        child: const Text('Qo‘shish'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.fullName, style: TextStyle(fontSize: 18)),
                Text(contact.phoneNumber, style: TextStyle(fontSize: 14)),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    fullNameController.text = contact.fullName;
                    phoneNumberController.text = contact.phoneNumber;

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Kontaktni tahrirlash'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: fullNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Ism Familya',
                                ),
                              ),
                              TextField(
                                controller: phoneNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'Telefon raqami',
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Bekor qilish'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _editContacts(contact.id!);
                              },
                              child: const Text('Tahrirlash'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _deleteContacts(contact.id!),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
