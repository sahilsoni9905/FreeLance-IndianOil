import 'dart:io'; // For platform detection
import 'package:oil_solution/table/models/table_data_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 

class DatabaseService {
  static Database? db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String tasksTableName = "tasks";
  final String tasksIdColumnName = "id";
  final String tasksAvgPckMsDensity = "avg_pck_ms_density";
  final String tasksInterfaceDensity = "interface_density";
  final String tasksTime = "time";
  final String tasksPercentOfPck = "percent_of_pck";
  final String tasksPercentOfMs = "percent_of_ms";
  final String tasksKlOfPck = "qty_kl_of_pck";
  final String tasksKlOfMs = "qty_kl_of_ms";
  final String tasksTotalKlInterface = "total_kl_interface";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initializeDatabase();
    return db!;
  }

  Future<Database> initializeDatabase() async {
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Use ffi for desktop platforms
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        print("Using sqflite_common_ffi for desktop platforms.");
      }

      final databaseDirPath = await getDatabasesPath();
      print('Database directory path: $databaseDirPath');
      final databasePath = join(databaseDirPath, "master_db.db");

      final database = await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, version) async {
          print('Creating tasks table...');
          await db.execute('''
            CREATE TABLE $tasksTableName(
              $tasksIdColumnName INTEGER PRIMARY KEY,
              $tasksAvgPckMsDensity REAL NOT NULL,
              $tasksInterfaceDensity REAL NOT NULL,
              $tasksTime TEXT NOT NULL,
              $tasksPercentOfPck REAL NOT NULL,
              $tasksPercentOfMs REAL NOT NULL,
              $tasksKlOfPck REAL NOT NULL,
              $tasksKlOfMs REAL NOT NULL,
              $tasksTotalKlInterface REAL NOT NULL
            )
          ''');
          print("Table $tasksTableName created successfully.");
        },
      );
      print("Database opened successfully.");
      return database;
    } catch (e) {
      print("Error during database initialization: $e");
      rethrow;
    }
  }

  Future<void> addTask({
    required double avgPckMsDensity,
    required double interfaceDensity,
    required String time,
    required double percentOfPck,
    required double percentOfMs,
    required double qtyKlOfPck,
    required double qtyKlOfMs,
    required double totalKlInterface,
  }) async {
    final db = await database;
    print('Attempting to insert task data...');
    try {
      await db.insert(tasksTableName, {
        tasksAvgPckMsDensity: avgPckMsDensity,
        tasksInterfaceDensity: interfaceDensity,
        tasksTime: time,
        tasksPercentOfPck: percentOfPck,
        tasksPercentOfMs: percentOfMs,
        tasksKlOfPck: qtyKlOfPck,
        tasksKlOfMs: qtyKlOfMs,
        tasksTotalKlInterface: totalKlInterface,
      });
      print("Data added successfully.");
      final data = await db.query(tasksTableName);
      print(data);
    } catch (e) {
      print("Error during data insertion: $e");
    }
  }

  Future<void> deleteTasksTable() async {
    final db = await database;
    print('Deleting tasks table if it exists...');
    await db.execute("DROP TABLE IF EXISTS $tasksTableName");
    print("Table $tasksTableName deleted successfully.");
  }

  Future<List<TaskData>?> getDataofTable() async {
    final db = await database;
    final data = await db.query(tasksTableName);
    print(data);
    return null;
  }

  void updateTableData(int id) async {
    final db = await database;
    await db.update(
      tasksTableName,
      {},
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }
}
