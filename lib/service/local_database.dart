import 'package:contacts/models/contact_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  factory LocalDatabase() {
    return _singleton;
  }

  static final _singleton = LocalDatabase._();
  LocalDatabase._();

  Database? _database;

  Future<void> init() async {
    _database ??= await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    final databasePath = await getApplicationDocumentsDirectory();
    final path = "$databasePath/contacts.db";
    return await openDatabase(path, version: 1, onCreate: _creatDatabase);
  }

  Future<void> _creatDatabase(Database database, version) async {
    await database.execute("""CREATE TABLE  contacts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      full_name TEXT NOT NULL,
      phone_number TEXT NOT NULL
    )""");
  }

  Future<int> insert(ContactModels contacts) async {
    final db = _database!;
    return await db.insert("contacts", contacts.toJson());
  }

  Future<List<ContactModels>> getAllContacts() async {
    final db = _database!;
    final List<Map<String, dynamic>> result = await db.query("contacts");
    return result.map((e) {
      return ContactModels.fromJson(e);
    }).toList();
  }

  Future<int> update(ContactModels contacts) async {
    final db = _database!;
    return await db.update(
      "contacts",
      contacts.toJson(),
      where: "id=?",
      whereArgs: [contacts.id],
    );
  }

  Future<void> delete({required int id}) async {
    _database?.delete("contacts", where: "id=$id");
  }

  Future<void> close() async {
    _database?.close();
  }
}
