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
}
