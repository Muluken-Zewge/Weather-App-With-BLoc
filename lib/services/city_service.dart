import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/city_model.dart';

class CityService {
  List<City> _cities = [];

  Future<void> loadCities() async {
    final String response =
        await rootBundle.loadString('assets/city_list.json');
    final List<dynamic> data = jsonDecode(response);

    _cities = data.map((json) => City.fromJson(json)).toList();
  }

  List<City> searchCities(String query) {
    if (query.isEmpty) {
      return [];
    }

    return _cities
        .where(
            (city) => city.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
  }
}
