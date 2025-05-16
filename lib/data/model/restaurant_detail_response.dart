import 'package:restaurant_app/data/model/restaurant_detail.dart';

class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json["error"],
      message: json["message"],
      restaurant: RestaurantDetail.fromJson(json["restaurant"]),
    );
  }
}
