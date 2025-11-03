import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../model/transaction_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transactions.db');
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

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const textTypeNullable = 'TEXT';

    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        dispenserNo $textType,
        quantityFilled $realType,
        vehicleNumber $textType,
        paymentMode $textType,
        paymentProofPath $textTypeNullable,
        latitude $realType,
        longitude $realType,
        createdAt $textType
      )
    ''');
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    const orderBy = 'createdAt DESC';
    final result = await db.query('transactions', orderBy: orderBy);
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<List<TransactionModel>> getFilteredTransactions({
    String? dispenserNo,
    String? paymentMode,
  }) async {
    final db = await database;
    final List<String> whereClauses = [];
    final List<dynamic> whereArgs = [];

    if (dispenserNo != null && dispenserNo.isNotEmpty) {
      whereClauses.add('dispenserNo = ?');
      whereArgs.add(dispenserNo);
    }

    if (paymentMode != null && paymentMode.isNotEmpty) {
      whereClauses.add('paymentMode = ?');
      whereArgs.add(paymentMode);
    }

    final whereString = whereClauses.isEmpty ? null : whereClauses.join(' AND ');
    final result = await db.query(
      'transactions',
      where: whereString,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'createdAt DESC',
    );

    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

