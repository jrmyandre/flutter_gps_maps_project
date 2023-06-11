import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;


  Directions({
    required this.bounds,
    required this.polylinePoints,

  });

  factory Directions.fromMap(Map<String, dynamic> map){
    if((map['routes'] as List).isEmpty) return Directions(bounds: LatLngBounds(southwest: LatLng(0, 0), northeast: LatLng(0, 0)), polylinePoints: []);

    final data = Map<String, dynamic>.from(map['routes'][0]);

    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      southwest: LatLng(southwest['lat'], southwest['lng']),
      northeast: LatLng(northeast['lat'], northeast['lng']),
    );



    return Directions(
      bounds: bounds,
      polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),

    );
    }
  }