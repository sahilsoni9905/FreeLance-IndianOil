import 'dart:io'; // For platform detection
import 'package:oil_solution/table/models/table_data_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 

class DatabaseService {
  static Database? db;
  static final DatabaseService instance = DatabaseService._constructor();

  // Table 1 - tasks
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

  // Table 2 - tasks2
  final String tasks2TableName = "tasks2";
  final String tasks2IdColumnName = "id";
  final String tasks2AvgPckMsDensity = "avg_pck_ms_density";
  final String tasks2InterfaceDensity = "interface_density";
  final String tasks2Time = "time";
  final String tasks2PercentOfPck = "percent_of_pck";
  final String tasks2PercentOfMs = "percent_of_ms";
  final String tasks2KlOfPck = "qty_kl_of_pck";
  final String tasks2KlOfMs = "qty_kl_of_ms";
  final String tasks2TotalKlInterface = "total_kl_interface";

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
          // Creating tasks table
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

          // Creating tasks2 table
          print('Creating tasks2 table...');
          await db.execute('''
            CREATE TABLE $tasks2TableName(
              $tasks2IdColumnName INTEGER PRIMARY KEY,
              $tasks2AvgPckMsDensity REAL NOT NULL,
              $tasks2InterfaceDensity REAL NOT NULL,
              $tasks2Time TEXT NOT NULL,
              $tasks2PercentOfPck REAL NOT NULL,
              $tasks2PercentOfMs REAL NOT NULL,
              $tasks2KlOfPck REAL NOT NULL,
              $tasks2KlOfMs REAL NOT NULL,
              $tasks2TotalKlInterface REAL NOT NULL
            )
          ''');
          print("Table $tasks2TableName created successfully.");
        },
      );
      print("Database opened successfully.");
      return database;
    } catch (e) {
      print("Error during database initialization: $e");
      rethrow;
    }
  }

  // Functions for tasks table
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
      print("Data added successfully to $tasksTableName.");
      final data = await db.query(tasksTableName);
      print(data);
    } catch (e) {
      print("Error during data insertion for tasks: $e");
    }
  }

  Future<void> deleteTasksTable() async {
    final db = await database;
    print('Deleting tasks table if it exists...');
    await db.execute("DROP TABLE IF EXISTS $tasksTableName");
    print("Table $tasksTableName deleted successfully.");
  }

  Future<List<TaskData>?> getDataofTasksTable() async {
    final db = await database;
    final data = await db.query(tasksTableName);
    print(data);
    return null;
  }

  void updateTaskData(int id, Map<String, dynamic> updatedValues) async {
    final db = await database;
    await db.update(
      tasksTableName,
      updatedValues,
      where: '$tasksIdColumnName = ?',
      whereArgs: [id],
    );
  }

  // Functions for tasks2 table
  Future<void> addTaskToTable2({
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
    print('Attempting to insert task2 data...');
    try {
      await db.insert(tasks2TableName, {
        tasks2AvgPckMsDensity: avgPckMsDensity,
        tasks2InterfaceDensity: interfaceDensity,
        tasks2Time: time,
        tasks2PercentOfPck: percentOfPck,
        tasks2PercentOfMs: percentOfMs,
        tasks2KlOfPck: qtyKlOfPck,
        tasks2KlOfMs: qtyKlOfMs,
        tasks2TotalKlInterface: totalKlInterface,
      });
      print("Data added successfully to $tasks2TableName.");
      final data = await db.query(tasks2TableName);
      print(data);
    } catch (e) {
      print("Error during data insertion for tasks2: $e");
    }
  }

  Future<void> deleteTasks2Table() async {
    final db = await database;
    print('Deleting tasks2 table if it exists...');
    await db.execute("DROP TABLE IF EXISTS $tasks2TableName");
    print("Table $tasks2TableName deleted successfully.");
  }

  Future<List<TaskData>?> getDataofTasks2Table() async {
    final db = await database;
    final data = await db.query(tasks2TableName);
    print(data);
    return null;
  }

  void updateTask2Data(int id, Map<String, dynamic> updatedValues) async {
    final db = await database;
    await db.update(
      tasks2TableName,
      updatedValues,
      where: '$tasks2IdColumnName = ?',
      whereArgs: [id],
    );
  }
}
