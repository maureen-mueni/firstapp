import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';

class DatabaseHelper {
  // Singleton pattern to ensure only one database instance is used throughout the app
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // CREATE TABLE Command
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        course TEXT NOT NULL
      )
    ''');
  }

  // 1. CREATE: Insert a student record
  Future<int> insertStudent(Student student) async {
    final db = await instance.database;
    return await db.insert('Students', student.toMap());
  }

  // 2. READ: Retrieve all student records
  Future<List<Student>> readAllStudents() async {
    final db = await instance.database;
    final result = await db.query('Students');

    return result.map((json) => Student.fromMap(json)).toList();
  }

  // 3. UPDATE: Modify an existing student record
  Future<int> updateStudent(Student student) async {
    final db = await instance.database;
    return await db.update(
      'Students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // 4. DELETE: Remove a student record permanently
  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return await db.delete(
      'Students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}