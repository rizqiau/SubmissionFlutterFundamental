import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

import 'restaurant_list_provider_test.mocks.dart';

@GenerateMocks([ApiServices])
void main() {
  late MockApiServices mockApiServices;
  late RestaurantListProvider provider;

  setUp(() {
    mockApiServices = MockApiServices();
    provider = RestaurantListProvider(mockApiServices);
  });

  test('State awal provider harus RestaurantListNoneState', () {
    expect(provider.resultState, isA<RestaurantListNoneState>());
  });

  test('Mengembalikan daftar restoran saat API berhasil', () async {
    final fakeRestaurants = [
      Restaurant(
        id: '1',
        name: 'Restoran A',
        description: 'Deskripsi A',
        pictureId: 'pic1',
        city: 'Jakarta',
        rating: 4.5,
      ),
      Restaurant(
        id: '2',
        name: 'Restoran B',
        description: 'Deskripsi B',
        pictureId: 'pic2',
        city: 'Bandung',
        rating: 4.0,
      ),
    ];

    final fakeResponse = RestaurantListResponse(
      error: false,
      message: '',
      count: fakeRestaurants.length,
      restaurants: fakeRestaurants,
    );

    when(
      mockApiServices.getRestaurantList(),
    ).thenAnswer((_) async => fakeResponse);

    await provider.fetchRestaurantList();

    expect(provider.resultState, isA<RestaurantListLoadedState>());
    final state = provider.resultState as RestaurantListLoadedState;
    expect(state.data, fakeRestaurants);
  });

  test('Mengembalikan error saat API mengembalikan error', () async {
    final fakeResponse = RestaurantListResponse(
      error: true,
      message: 'Failed to fetch data',
      count: 0,
      restaurants: [],
    );

    when(
      mockApiServices.getRestaurantList(),
    ).thenAnswer((_) async => fakeResponse);

    await provider.fetchRestaurantList();

    expect(provider.resultState, isA<RestaurantListErrorState>());
    final state = provider.resultState as RestaurantListErrorState;
    expect(state.error, 'Failed to fetch data');
  });

  test('Mengembalikan error saat exception dilempar', () async {
    when(
      mockApiServices.getRestaurantList(),
    ).thenThrow(Exception('Exception error'));

    await provider.fetchRestaurantList();

    expect(provider.resultState, isA<RestaurantListErrorState>());
    final state = provider.resultState as RestaurantListErrorState;
    expect(state.error, contains('Exception error'));
  });
}
