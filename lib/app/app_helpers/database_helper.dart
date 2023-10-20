import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../app_widget/app_debug_widget/debug_pointer.dart';
import '../screens/books/models/book_model.dart';

class BooksDatabaseHelper {
  static Database? _bookDb;
  static BooksDatabaseHelper? _bookDatabaseHelper;

  String table = 'bookTable';
  String colId = 'id';
  String colName = 'name';
  String colDescription = "description";
  String colAuthorName = "author";
  String colImage = 'image';

  BooksDatabaseHelper._createInstance();

  static final BooksDatabaseHelper db = BooksDatabaseHelper._createInstance();

  factory BooksDatabaseHelper() {
    _bookDatabaseHelper ??= BooksDatabaseHelper._createInstance();
    return _bookDatabaseHelper!;
  }

  Future<Database> get database async {
    _bookDb ??= await initializeDatabase();
    return _bookDb!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}books.db';
    Debug.log(path);
    var myDatabase = await openDatabase(path, version: 5, onCreate: _createDb);
    return myDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $table"
        "($colId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$colName TEXT, $colDescription TEXT, $colAuthorName TEXT, $colImage TEXT, "
        "status INTEGER)"); // Add the 'status' column
  }

  Future<List<Map<String, dynamic>>> getBookMapList() async {
    Database db = await database;
    var result = await db.query(table, orderBy: "$colId ASC");
    return result;
  }

  Future<int> insertBook(BookModel book) async {
    Database db = await database;
    var result = await db.insert(table, book.toMap());
    Debug.log(result);
    return result;
  }

  Future<int> updateBook(BookModel book) async {
    var db = await database;
    var result = await db
        .update(table, book.toMap(), where: '$colId = ?', whereArgs: [book.id]);
    return result;
  }

  Future<int> deleteBook(
    int id,
  ) async {
    var db = await database;
    int result = await db.delete(table, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  Future<int> getCount(tableName) async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableName');
    int result = Sqflite.firstIntValue(x) ?? 0;
    return result;
  }

  Future<List<BookModel>> getBookList() async {
    var bookMapList = await getBookMapList();
    int count = await getCount(table);

    List<BookModel> bookList = <BookModel>[];
    for (int i = 0; i < count; i++) {
      bookList.add(BookModel.fromMap(bookMapList[i]));
    }
    return bookList;
  }

  close() async {
    var db = await database;
    var result = db.close();
    return result;
  }
}
