import 'package:restaurant_app/data/model/category.dart';
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/data/model/menus.dart';
import 'restaurant.dart';

class RestaurantDetail extends Restaurant {
  final String address;
  final List<Category> categories;
  final Menus menus;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required String id,
    required String name,
    required String description,
    required String pictureId,
    required String city,
    required double rating,
    required this.address,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  }) : super(
         id: id,
         name: name,
         description: description,
         pictureId: pictureId,
         city: city,
         rating: rating,
       );

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: (json['rating'] as num).toDouble(),
      address: json['address'],
      categories:
          (json['categories'] as List)
              .map((e) => Category.fromJson(e))
              .toList(),
      menus: Menus.fromJson(json['menus']),
      customerReviews:
          (json['customerReviews'] as List)
              .map((e) => CustomerReview.fromJson(e))
              .toList(),
    );
  }
}
