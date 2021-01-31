import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


// database table and column names
final String tableRSSURL = 'rssurl';
final String columnUserID = 'userid';
final String columnUrl = 'url';
final String columnID = 'id';

// data model class
class RSS {
  int id;
  String url;
  String userID;

  RSS(String _url,  String _userID){
    url = _url;
    userID = _userID;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnUserID: userID,
      columnUrl: url
    };
    if (id != null) {
      map[columnID] = id;
    }
    return map;
  }

}

class DatabaseHelper{
  static const tableName = 'rss';
  static const id = 'id';
  static const userID = 'userID';
  static const url = 'url';

  static final _databaseName = "RSS_Feeds.db";
  static final _databaseVersion = 1;

  static Database _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  static DatabaseHelper get instance {
    return _instance;
  }

  Future<void> _createTable(Database db) async{
    final sql = '''
      CREATE TABLE $tableName
      (
        $id INTEGER PRIMARY KEY,
        $userID TEXT,
        $url TEXT
      )
    ''';
    await db.execute(sql);
  }

  Future<String> _getDatabasePath(String dbName) async {
    var databasePath = await getDatabasesPath();

    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    print("testDB: _getDatabasePath end");
    return path;
  }

  Future<void> initDatabase() async {
    print("testDB: inside initDatabase");

    if (_database == null) {
      final path = await _getDatabasePath(_databaseName);


      print("testDB: path");
      print("testDB: path $path");

      _database =
      await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
      print("testDB: _db $_database");
    }
    else{
      print("testDB: initDatabase else");
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTable(db);
  }

  void status(){
    print('testDB: isOpen ' + _database.isOpen.toString());
  }

  Future <RSS> insertRSS(RSS rss) async{
    rss.id = await _database.insert(tableName, rss.toMap());
    return rss;
  }

  Future <List<Map>> getRSSList(String _userID) async {

    print("userid $_userID");

    List<Map> maps = await _database.query(tableName,
        columns: [columnUrl],
        where: '$columnUserID = ?',
        whereArgs: [_userID]);
    if (maps.length > 0) {
      print("length $_userID");
      return maps;
    }
    return null;
  }

  void restartDatabase() async{
    if (_database != null) {
      final path = await _getDatabasePath(_databaseName);
      await deleteDatabase(path);
      _database = null;
    }

  }
}