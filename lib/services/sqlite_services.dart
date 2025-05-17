import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/model/restaurant.dart';

class SqliteServices {
  static const String _dbName = 'restaurant.db';
  static const String _tableName = 'favorites';
  static const int _version = 1;
  Database? _database;

  Future<Database> _initializeDb() async {
    if (_database != null) return _database!; // Reuse existing connection

    _database = await openDatabase(
      _dbName,
      version: _version,
      onCreate: (Database database, int version) async {
        await database.execute('''
          CREATE TABLE $_tableName(
            id TEXT PRIMARY KEY NOT NULL,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
          )
        ''');
      },
    );
    return _database!;
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    try {
      final db = await _initializeDb();
      await db.insert(
        _tableName,
        restaurant.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error inserting favorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      final db = await _initializeDb();
      await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error removing favorite: $e');
      rethrow;
    }
  }

  Future<List<Restaurant>> getFavorites() async {
    try {
      final db = await _initializeDb();
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return maps.map((map) => Restaurant.fromJson(map)).toList();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      return [];
    }
  }

  Future<bool> isFavorite(String id) async {
    try {
      final db = await _initializeDb();
      final result = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking favorite: $e');
      return false;
    }
  }
}
