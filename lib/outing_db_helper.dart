import 'package:battle_buddies/models/outing.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class OutingDBHelper {
  static final _databaseName = 'OutingDatabase.db';
  static final _databaseVersion = 1;
  static final outingTable = 'Outing';

  static final columnId = 'id';
  static final columnIsAuto = 'is_auto';
  static final columnStartDate = 'start_date';
  static final columnEndDate = 'end_date';
  static final columnCheckInInterval = 'check_in_interval';
  static final columnContactName = 'contact_name';
  static final columnContactNumber = 'contact_number';

  static final OutingDBHelper _instance = new OutingDBHelper.internal();
  static Database _database;
  factory OutingDBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  OutingDBHelper.internal();

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $outingTable($columnId INTEGER PRIMARY KEY, $columnIsAuto TEXT NOT NULL, $columnStartDate TEXT NOT NULL, $columnEndDate TEXT NOT NULL, $columnCheckInInterval INTEGER NOT NULL, $columnContactName TEXT NOT NULL, $columnContactNumber TEXT NOT NULL)");
  }

  Future<int> insert(Outing outing) async {
    Database db = await database;
    return await db.insert(
      outingTable,
      outing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Outing>> queryAllRows() async {
    Database db = await database;
    List<Map<String, dynamic>> outingDbRows = await db.query(outingTable);
    return outingDbRows
        .map((outingDbMap) => new Outing.fromDbMap(outingDbMap))
        .toList();
  }

  Future<int> queryRowCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $outingTable'));
  }

  Future<int> update(Outing outing) async {
    Database db = await database;
    int id = outing.id;
    return await db.update(outingTable, outing.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db
        .delete(outingTable, where: '$columnId = ?', whereArgs: [id]);
  }
}
