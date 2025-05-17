import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/services/sqlite_services.dart';

class LocalDatabaseProvider with ChangeNotifier {
  final SqliteServices _sqliteServices = SqliteServices();
  List<Restaurant> _favorites = [];

  List<Restaurant> get favorites => _favorites;

  Future<void> loadFavorites() async {
    try {
      _favorites = await _sqliteServices.getFavorites();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      _favorites = [];
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(Restaurant restaurant) async {
    try {
      final isFavorite = _favorites.any((fav) => fav.id == restaurant.id);

      if (isFavorite) {
        await _sqliteServices.removeFavorite(restaurant.id);
        _favorites.removeWhere((fav) => fav.id == restaurant.id);
      } else {
        await _sqliteServices.insertFavorite(restaurant);
        _favorites.add(restaurant);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  bool isFavorite(String id) {
    return _favorites.any((fav) => fav.id == id);
  }
}
