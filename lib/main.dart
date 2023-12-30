import 'package:flutter/material.dart';
import 'contact.dart';
import 'contact_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactList(),
    );
  }
}

class UpdateContactScreen extends StatelessWidget {
  final ContactService _contactService;
  final Contact contact;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  UpdateContactScreen(this._contactService, this.contact) {
    nameController.text = contact.name;
    phoneController.text = contact.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Contact updatedContact = Contact(
                  id: contact.id,
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                );
                _contactService.updateContact(updatedContact);
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final ContactService _contactService = ContactService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: FutureBuilder<List<Contact>>(
        future: _contactService.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Contact> contacts = snapshot.data ?? [];
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(contacts[index].name),
                  subtitle: Text(contacts[index].phoneNumber),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToUpdateContact(context, contacts[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteContact(contacts[index].id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _navigateToUpdateContact(context, contacts[index]);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _navigateToAddContact(context);
          _refreshContactList(); // Refresh UI after adding contact
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateToAddContact(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddContactScreen(_contactService)),
    );
  }

  Future<void> _navigateToUpdateContact(BuildContext context, Contact contact) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateContactScreen(_contactService, contact)),
    );
    _refreshContactList(); // Refresh UI after updating contact
  }

  Future<void> _deleteContact(String id) async {
    await _contactService.deleteContact(id);
    _refreshContactList(); // Refresh UI after deleting contact
  }

  void _refreshContactList() {
    setState(() {}); // Refresh UI by rebuilding widget tree
  }
}

class AddContactScreen extends StatelessWidget {
  final ContactService _contactService;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  AddContactScreen(this._contactService);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Create a new contact and add it to the list
                Contact newContact = Contact(
                  id: DateTime.now().toString(), // Generate a unique ID (not ideal for production)
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                );
                _contactService.addContact(newContact);
                Navigator.pop(context); // Go back to the contact list
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
