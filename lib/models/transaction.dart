import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Transaction {
  final String id;
  final String title;
  final int amount;
  final DateTime date;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toString(), //可能要改
    };
  }
}

class TransactionDB {
  static Database database;

  static Future<Database> initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'transaction.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE transactions(id TEXT PRIMARY KEY, title TEXT, amount DOUBLE, date TEXT)",
        );
      },
      version: 1,
    );
    return database;
  }

  static Future<Database> getDBConnect() async {
    if (database != null) {
      return database;
    }
    return await initDatabase();
  }

  //下方為正式方法

  static Future<List<Transaction>> getTransactions() async {
    final Database db = await getDBConnect();
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) {
      return Transaction(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  static Future<void> addTransactions(Transaction tx) async {
    final Database db = await getDBConnect();
    await db.insert(
      'transactions',
      tx.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteTransactions(String id) async {
    final Database db = await getDBConnect();
    await db.delete(
      'transactions',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
