import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tn09_app_demo/page/testing_page/testing_function/models/place_search.dart';
import 'package:tn09_app_demo/page/testing_page/testing_function/services/geolocator_service.dart';
import 'package:tn09_app_demo/page/testing_page/testing_function/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();

  //variable
  late Position currentLocation;
  List<PlaceSearch> searchResults = [];

  ApplicationBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }
}
