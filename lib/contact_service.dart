import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'contact.dart';
import 'database_helper.dart';

class ContactService {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<void> addContact(Contact contact) async {
    await dbHelper.insertContact(contact);
  }

  Future<List<Contact>> getContacts() async {
    return await dbHelper.getContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await dbHelper.updateContact(contact);
  }

  Future<void> deleteContact(String id) async {
    await dbHelper.deleteContact(id);
  }
}
