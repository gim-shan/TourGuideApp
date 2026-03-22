import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Destination {
  final String id;
  final String name;
  final String description;
  final LatLng location;
  final String thumbnailUrl;
  final String arModelUrl;
  final String vrImageUrl;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.thumbnailUrl,
    required this.arModelUrl,
    required this.vrImageUrl,
  });

  factory Destination.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    GeoPoint geoPoint = data['location'] as GeoPoint;
    return Destination(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      location: LatLng(geoPoint.latitude, geoPoint.longitude),
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      arModelUrl: data['arModelUrl'] ?? '',
      vrImageUrl: data['vrImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'location': GeoPoint(location.latitude, location.longitude),
      'thumbnailUrl': thumbnailUrl,
      'arModelUrl': arModelUrl,
      'vrImageUrl': vrImageUrl,
    };
  }
}
