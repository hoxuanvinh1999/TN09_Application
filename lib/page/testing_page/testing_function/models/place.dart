import 'package:tn09_app_demo/page/testing_page/testing_function/models/geometry.dart';

class Place {
  final Geometry geometry;
  final String placeId;
  final String name;
  final String vicinity;

  Place(
      {required this.geometry,
      required this.placeId,
      required this.name,
      required this.vicinity});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      geometry: Geometry.fromJson(json['geometry']),
      placeId: json['place_id'],
      name: json['formatted_address'],
      vicinity: json['vicinity'],
    );
  }
}
