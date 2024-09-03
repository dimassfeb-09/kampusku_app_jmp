import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/Mahasiswa.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mahasiswa.db');

    return await openDatabase(
      path,
      version: 2, // Increment the version number to trigger onUpgrade
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE mahasiswa(
            id INTEGER PRIMARY KEY,
            nama TEXT,
            ttl TEXT,
            jenisKelamin TEXT,
            alamat TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('DROP TABLE IF EXISTS mahasiswa');
          await db.execute('''
            CREATE TABLE mahasiswa(
              id INTEGER PRIMARY KEY,
              nama TEXT,
              ttl TEXT,
              jenisKelamin TEXT,
              alamat TEXT
            )
          ''');
        }
      },
    );
  }

  Future<List<Mahasiswa>> getMahasiswaList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mahasiswa');

    return List.generate(maps.length, (i) {
      return Mahasiswa.fromMap(maps[i]);
    });
  }

  Future<bool> checkIfIdExists(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'mahasiswa',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<void> insertMahasiswa(Mahasiswa mahasiswa) async {
    final db = await database;

    // Check if ID already exists
    final idExists = await checkIfIdExists(mahasiswa.id!);
    if (idExists) {
      throw Exception('ID sudah digunakan');
    }

    await db.insert(
      'mahasiswa',
      mahasiswa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMahasiswa(Mahasiswa mahasiswa) async {
    final db = await database;
    await db.update(
      'mahasiswa',
      mahasiswa.toMap(),
      where: 'id = ?',
      whereArgs: [mahasiswa.id],
    );
  }

  Future<void> deleteMahasiswa(int id) async {
    final db = await database;
    await db.delete(
      'mahasiswa',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
