// ignore_for_file: avoid_print

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import 'dart:io' as io;
import 'dart:async';

import '../models/mynote.dart';

class DBHelper {
  static final DBHelper _istance = DBHelper.internal();
  DBHelper.internal();

  factory DBHelper() => _istance;

  Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await setDB();
    return _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "SimpleNoteDB");
    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "Create Table mynote(id INTEGER PRIMARY KEY, title TEXT, note TEXT, createDate TEXT, updateDate TEXT, sortDate TEXT)",
    );
    print("DB Create");
  }

  //menampilkan data udah benar atau belum
  Future<int> saveNote(Mynote mynote) async {
    var dbClient = await db;
    int res = await dbClient!.insert(
      "mynote",
      mynote.toMap(),
    );
    print("data insert");
    return res;
  }

  //
  Future<List<Mynote>> getNote() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient!.rawQuery("SELECT * FROM mynote ORDER BY sortDate DESC");
    List<Mynote> notedata = [];
    for (int i = 0; i < list.length; i++) {
      var note = Mynote(
        list[i]["title"],
        list[i]["note"],
        list[i]["createDate"],
        list[i]["updateDate"],
        list[i]["sortDate"],
      );
      note.setNoteId(list[i]["id"]);
      notedata.add(note);
    }

    return notedata;
  }

  // Update
  Future<bool> updateNote(Mynote mynote) async {
    var dbClient = await db;
    int res = await dbClient!.update(
      "mynote",
      mynote.toMap(),
      where: "id=?",
      whereArgs: <int>[mynote.id as int],
    );
    return res > 0 ? true : false;
  }

  // Delete
  Future<int> deleteNote(Mynote mynote) async {
    var dbClient = await db;
    int res = await dbClient!.rawDelete(
      "DELETE FROM mynote WHERE id = ?",
      [mynote.id as int],
    );
    return res;
  }
}
