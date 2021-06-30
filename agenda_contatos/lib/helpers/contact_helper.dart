import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idCol = "idCol";
final String nameCol = "nameCol";
final String emailCol = "emailCol";
final String phoneCol = "phoneCol";
final String imgCol = "imgCol";



class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database>get db async {
    if(_db != null){
      return _db;
    }
    else {
      _db = await initDb();
      return _db;
    }
  }
  //iniciar o banco de dados de acordo com a tabela
  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contactsNew.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $contactTable($idCol INTEGER PRIMARY KEY, $nameCol TEXT, $emailCol TEXT, $phoneCol TEXT, $imgCol TEXT)"
      );
    });
  }
  //salvar um contato no banco de dados
  Future<Contact> saveContact(Contact contact) async {
     Database dbContact = await db;
     contact.id = await dbContact.insert(contactTable, contact.toMap());
     return contact;
  }
  //get contato
  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
      columns: [idCol, nameCol, emailCol, phoneCol, imgCol],
      where: "$idCol = ?",
      whereArgs: [id]);
    if(maps.length > 0){
      return Contact.fromMap(maps.first);
    }
    else {
      return null;
    }
  }
//deletar um contato
  Future<int> deleteContact(int id) async{
    Database dbContact = await db;
    return await dbContact.delete(contactTable, where:"$idCol = ?", whereArgs: [id]);
  }
  //atualizar um contato
  Future<int> updatoContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(), where: "$idCol = ?", whereArgs: [contact.id]);
  }
  //pegar todos os contatos
  Future<List> getAllContact() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = [];
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }
  //retorna a quantidade de elementos da tabela
  Future<int> getNumber() async{
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }
  //fechar
  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {

  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map){
    id = map[idCol];
    name = map[nameCol];
    email = map[emailCol];
    phone = map[phoneCol];
    img = map[imgCol];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameCol : name,
      emailCol : email,
      phoneCol : phone,
      imgCol : img,
    };
    if(id != null){
      map[idCol] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}