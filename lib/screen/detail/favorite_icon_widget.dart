import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/local_database_provider.dart';

class FavoriteIconWidget extends StatelessWidget {
  final Restaurant restaurant;

  const FavoriteIconWidget({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final localDbProvider = context.watch<LocalDatabaseProvider>();
    final isFavorited = localDbProvider.isFavorite(restaurant.id);

    return IconButton(
      icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_outline),
      onPressed: () async {
        await localDbProvider.toggleFavorite(restaurant);
      },
    );
  }
}
