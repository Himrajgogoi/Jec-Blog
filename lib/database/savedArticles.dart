import "dart:io";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:sqflite/sqflite.dart";
import "package:path/path.dart" as Path;
import "dart:convert";


class Saved_for_Editing {

    String header;
    String textArea;
    var image;

    Saved_for_Editing({this.header, this.textArea, this.image});

    static Database _database;

    /// getting the database
    Future<Database> get database async {
      if(_database != null){
        return _database;
      }
      else{
        _database = await initDB();
        return _database;
      }
    }


    /// creating the database
    initDB() async {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = Path.join(documentsDirectory.path, "Saved_for_Editing.db");
      return await openDatabase(path, version: 1, onOpen: (db){},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Saved_for_Editing(articleId INTEGER PRIMARY KEY, header TEXT, textArea TEXT, image TEXT)");
      });
    }


    /// inserting an article
    Future<void> insertArticle() async {
      final Database db = await database;
      await db.insert("Saved_for_Editing", {"header": header, "textArea": textArea, "image": image}, conflictAlgorithm: ConflictAlgorithm.replace,);
    }


    /// fetching the articles
    Future<List<Map<String,dynamic>>> getArticles() async {
      final Database db = await database;
      return await db.query("Saved_for_Editing");
    }


    /// deleting the entire database
    Future<void> delete() async {
      final Database db = await database;
      return await db.delete("Saved_for_Editing");
    }


    /// deleting the specific article
    Future<void> DeleteById(int id) async {
      final Database db = await database;
      return await db.delete("Saved_for_Editing", where: 'articleId = ?', whereArgs: [id]);
    }


    /// updating the specific article
    Future<void> update(Map<String, dynamic> row) async {
      final Database db = await database;
      int id= row["articleId"];
      return await db.update("Saved_for_Editing", row, where: 'articleId = ?', whereArgs: [id]);
    }
}